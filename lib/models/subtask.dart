class SubTask {
  String title;
  bool completed;

  SubTask({required this.title, this.completed = false});

  Map<String, dynamic> toMap() => {
        'title': title,
        'completed': completed,
      };

  factory SubTask.fromMap(Map<String, dynamic> map) =>
      SubTask(title: map['title'], completed: map['completed']);
}