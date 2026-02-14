import 'package:flutter/material.dart';
import 'tasks_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const TasksScreen(),
      const CalendarScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: "Tareas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calendario"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dark_mode), label: "Modo"),
        ],
        onTap: (index) {
          if (index == 2) {
            widget.toggleTheme();
          } else {
            setState(() => currentIndex = index);
          }
        },
      ),
    );
  }
}