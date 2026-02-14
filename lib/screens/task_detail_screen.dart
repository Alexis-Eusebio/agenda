import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../services/storage_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task task;
  late TextEditingController titleController;
  late TextEditingController notesController;

  final categories = [
    "Trabajo",
    "Personal",
    "Lista de deseos",
    "Cumpleaños"
  ];

  @override
  void initState() {
    super.initState();
    task = widget.task;
    titleController = TextEditingController(text: task.title);
    notesController = TextEditingController(text: task.notes);
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: task.dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        task.dueDate = DateTime(
          date.year,
          date.month,
          date.day,
          task.dueDate?.hour ?? 0,
          task.dueDate?.minute ?? 0,
        );
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          task.dueDate ?? DateTime.now()),
    );

    if (time != null) {
      final current = task.dueDate ?? DateTime.now();
      setState(() {
        task.dueDate = DateTime(
          current.year,
          current.month,
          current.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void addSubtask() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nueva Subtarea"),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(labelText: "Título"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  task.subtasks
                      .add(SubTask(title: controller.text));
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Agregar"),
          )
        ],
      ),
    );
  }

  void saveChanges() async {
    final tasks = await StorageService.loadTasks();
    final index =
        tasks.indexWhere((t) => t.title == widget.task.title);

    task.title = titleController.text;
    task.notes = notesController.text;

    tasks[index] = task;
    await StorageService.saveTasks(tasks);
    Navigator.pop(context);
  }

  void deleteTask() async {
    final tasks = await StorageService.loadTasks();
    tasks.removeWhere((t) => t.title == task.title);
    await StorageService.saveTasks(tasks);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de Tarea"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Text("Marcar como hecho"),
                onTap: () {
                  task.completed = true;
                  saveChanges();
                },
              ),
              PopupMenuItem(
                child: const Text("Eliminar"),
                onTap: deleteTask,
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// TITULO
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(labelText: "Título"),
            ),

            const SizedBox(height: 10),

            /// CATEGORIA
            DropdownButtonFormField<String>(
              value: task.category,
              items: categories
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) =>
                  setState(() => task.category = val!),
              decoration:
                  const InputDecoration(labelText: "Categoría"),
            ),

            const SizedBox(height: 20),

            /// FECHA
            ListTile(
              title: const Text("Fecha de vencimiento"),
              subtitle: Text(task.dueDate != null
                  ? task.dueDate.toString()
                  : "No seleccionada"),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: pickDate,
              ),
            ),

            /// HORA
            ListTile(
              title: const Text("Hora"),
              subtitle: Text(task.dueDate != null
                  ? "${task.dueDate!.hour}:${task.dueDate!.minute}"
                  : "No seleccionada"),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: pickTime,
              ),
            ),

            /// RECORDATORIO
            SwitchListTile(
              title: const Text("Recordatorio"),
              value: task.reminder,
              onChanged: (val) =>
                  setState(() => task.reminder = val),
            ),

            /// REPETIR
            SwitchListTile(
              title: const Text("Repetir tarea"),
              value: task.repeat,
              onChanged: (val) =>
                  setState(() => task.repeat = val),
            ),

            const SizedBox(height: 20),

            /// SUBTAREAS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtareas",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addSubtask,
                )
              ],
            ),

            Column(
              children: task.subtasks.map((sub) {
                return CheckboxListTile(
                  title: Text(sub.title),
                  value: sub.completed,
                  onChanged: (val) =>
                      setState(() => sub.completed = val!),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// NOTAS
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration:
                  const InputDecoration(labelText: "Notas"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveChanges,
              child: const Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}