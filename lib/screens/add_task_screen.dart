import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final notesController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool reminder = false;
  bool repeat = false;

  String category = "Trabajo";

  final categories = [
    "Trabajo",
    "Personal",
    "Lista de deseos",
    "Cumpleaños"
  ];

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  void save() async {
    if (titleController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      return;
    }

    final dueDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final tasks = await StorageService.loadTasks();

    tasks.add(Task(
      title: titleController.text,
      category: category,
      dueDate: dueDate,
      reminder: reminder,
      repeat: repeat,
      notes: notesController.text,
    ));

    await StorageService.saveTasks(tasks);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Tarea")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Título"),
            ),

            DropdownButtonFormField(
              value: category,
              items: categories
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) =>
                  setState(() => category = val!),
              decoration:
                  const InputDecoration(labelText: "Categoría"),
            ),

            const SizedBox(height: 10),

            ListTile(
              title: const Text("Fecha de vencimiento"),
              subtitle: Text(selectedDate != null
                  ? selectedDate.toString()
                  : "Seleccionar fecha"),
              trailing: const Icon(Icons.calendar_today),
              onTap: pickDate,
            ),

            ListTile(
              title: const Text("Hora"),
              subtitle: Text(selectedTime != null
                  ? selectedTime!.format(context)
                  : "Seleccionar hora"),
              trailing: const Icon(Icons.access_time),
              onTap: pickTime,
            ),

            SwitchListTile(
              title: const Text("Recordatorio"),
              value: reminder,
              onChanged: (val) =>
                  setState(() => reminder = val),
            ),

            SwitchListTile(
              title: const Text("Repetir tarea"),
              value: repeat,
              onChanged: (val) =>
                  setState(() => repeat = val),
            ),

            TextField(
              controller: notesController,
              maxLines: 3,
              decoration:
                  const InputDecoration(labelText: "Notas"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: save,
                child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }
}