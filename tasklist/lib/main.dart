import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'state/todo_scope.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TodoScope(
      model: TodoModel(),
      child: MaterialApp(
        title: 'Todo App - InheritedNotifier',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
