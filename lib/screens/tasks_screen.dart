import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  String selectedCategory = "Todas";

  final categories = [
    "Todas",
    "Trabajo",
    "Personal",
    "Lista de deseos",
    "Cumpleaños"
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    tasks = await StorageService.loadTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategory == "Todas"
        ? tasks
        : tasks.where((t) => t.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Tareas")),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selectedCategory == cat,
                    onSelected: (_) =>
                        setState(() => selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                return TaskCard(
                  task: filtered[i],
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                TaskDetailScreen(task: filtered[i])));
                    load();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddTaskScreen()));
          load();
        },
      ),
    );
  }
}