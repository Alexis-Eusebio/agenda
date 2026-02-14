import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
                task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.category),
        trailing: task.completed
            ? const Icon(Icons.check, color: Colors.green)
            : null,
      ),
    );
  }
}