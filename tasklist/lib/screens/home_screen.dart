import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_filter_widget.dart';
import '../widgets/todo_input_widget.dart';
import '../widgets/todo_item_widget.dart';
import 'edit_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  TodoFilter _filter = TodoFilter.all;

  void _addTodo(String title) {
    setState(() {
      _todos.add(Todo(
        id: DateTime.now().toIso8601String(),
        title: title,
      ));
    });
  }

  void _toggleTodo(String id, bool? value) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(isCompleted: value ?? false);
      }
    });
  }

  void _updateTodo(Todo updated) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == updated.id);
      if (index != -1) {
        _todos[index] = updated;
      }
    });
  }

  void _removeTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) return;
    
    final removedTodo = _todos[index];
    setState(() {
      _todos.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Видалено "${removedTodo.title}"'),
        action: SnackBarAction(
          label: 'Скасувати',
          onPressed: () {
            setState(() {
              _todos.insert(index, removedTodo);
            });
          },
        ),
      ),
    );
  }

  List<Todo> get _filteredTodos {
    return _todos.where((todo) {
      if (_filter == TodoFilter.active) return !todo.isCompleted;
      if (_filter == TodoFilter.completed) return todo.isCompleted;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _todos.where((t) => t.isCompleted).length;
    final totalCount = _todos.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Мої справи ($completedCount з $totalCount)'),
      ),
      body: Column(
        children: [
          TodoInputWidget(onAdd: _addTodo),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TodoFilterWidget(
              currentFilter: _filter,
              onFilterChanged: (f) => setState(() => _filter = f),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = _filteredTodos[index];
                return TodoItemWidget(
                  todo: todo,
                  onToggle: (val) => _toggleTodo(todo.id, val),
                  onDelete: () => _removeTodo(todo.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTodoScreen(
                          todo: todo,
                          onSave: _updateTodo,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}