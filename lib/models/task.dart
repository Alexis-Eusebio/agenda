import 'subtask.dart';

class Task {
  String title;
  String category;
  DateTime? dueDate;
  bool reminder;
  bool repeat;
  bool completed;
  String notes;
  List<SubTask> subtasks;

  Task({
    required this.title,
    required this.category,
    this.dueDate,
    this.reminder = false,
    this.repeat = false,
    this.completed = false,
    this.notes = '',
    List<SubTask>? subtasks,
  }) : subtasks = subtasks ?? [];

  Map<String, dynamic> toMap() => {
        'title': title,
        'category': category,
        'dueDate': dueDate?.toIso8601String(),
        'reminder': reminder,
        'repeat': repeat,
        'completed': completed,
        'notes': notes,
        'subtasks': subtasks.map((e) => e.toMap()).toList(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        title: map['title'],
        category: map['category'],
        dueDate:
            map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
        reminder: map['reminder'],
        repeat: map['repeat'],
        completed: map['completed'],
        notes: map['notes'],
        subtasks: (map['subtasks'] as List)
            .map((e) => SubTask.fromMap(e))
            .toList(),
      );
}