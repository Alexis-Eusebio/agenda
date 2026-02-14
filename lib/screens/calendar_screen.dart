import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    tasks = await StorageService.loadTasks();
    setState(() {});
  }

  List<Task> getTasksForDay(DateTime day) {
    return tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == day.year &&
          task.dueDate!.month == day.month &&
          task.dueDate!.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dayTasks = getTasksForDay(selectedDay);

    return Scaffold(
      appBar: AppBar(title: const Text("Calendario")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) =>
                isSameDay(selectedDay, day),
            onDaySelected: (selected, _) {
              setState(() => selectedDay = selected);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final tasksForDay = getTasksForDay(date);

                if (tasksForDay.isEmpty) return null;

                bool hasPending =
                    tasksForDay.any((t) => !t.completed);
                bool hasCompleted =
                    tasksForDay.any((t) => t.completed);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasPending)
                      const Icon(Icons.circle,
                          size: 8, color: Colors.red),
                    if (hasCompleted)
                      const Icon(Icons.circle,
                          size: 8, color: Colors.green),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              children: dayTasks.map((task) {
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.category),
                  trailing: Icon(
                    task.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task.completed
                        ? Colors.green
                        : Colors.red,
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}