import 'package:flutter/material.dart';
import '../state/todo_scope.dart';
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
  TodoFilter _filter = TodoFilter.all;

  @override
  Widget build(BuildContext context) {
    debugPrint('build: HomeScreen');
    final todoModel = TodoScope.of(context);
    final todos = todoModel.todos;

    final completedCount = todos.where((t) => t.isCompleted).length;
    final totalCount = todos.length;

    final filteredTodos = todos.where((todo) {
      if (_filter == TodoFilter.active) return !todo.isCompleted;
      if (_filter == TodoFilter.completed) return todo.isCompleted;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Мої справи ($completedCount з $totalCount)'),
      ),
      body: Column(
        children: [
          const TodoInputWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TodoFilterWidget(
              currentFilter: _filter,
              onFilterChanged: (f) => setState(() => _filter = f),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];
                return TodoItemWidget(
                  todo: todo,
                  onToggle: () => todoModel.toggle(todo.id),
                  onDelete: () {
                    final removedIndex = todoModel.todos.indexWhere((t) => t.id == todo.id);
                    todoModel.remove(todo.id);

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Видалено "${todo.title}"'),
                        action: SnackBarAction(
                          label: 'Скасувати',
                          onPressed: () => todoModel.restore(todo, removedIndex),
                        ),
                      ),
                    );
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTodoScreen(todoId: todo.id),
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