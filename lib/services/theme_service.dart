import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const key = "darkMode";

  static Future<void> saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}