import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const key = "tasks";

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final data =
        tasks.map((task) => jsonEncode(task.toMap())).toList();
    await prefs.setStringList(key, data);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key);
    if (data == null) return [];
    return data.map((e) => Task.fromMap(jsonDecode(e))).toList();
  }
}