import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoModel extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);

  void add(String title, [String description = '']) {
    _todos.add(Todo(
      id: DateTime.now().toIso8601String(),
      title: title,
      description: description,
    ));
    notifyListeners();
  }

  void toggle(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(isCompleted: !_todos[index].isCompleted);
      notifyListeners();
    }
  }

  void update(Todo updated) {
    final index = _todos.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _todos[index] = updated;
      notifyListeners();
    }
  }

  void remove(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void restore(Todo todo, int index) {
    _todos.insert(index, todo);
    notifyListeners();
  }
}

class TodoScope extends InheritedNotifier<TodoModel> {
  const TodoScope({
    super.key,
    required TodoModel model,
    required super.child,
  }) : super(notifier: model);

  static TodoModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TodoScope>();
    assert(scope != null, 'No TodoScope found in context');
    return scope!.notifier!;
  }
}