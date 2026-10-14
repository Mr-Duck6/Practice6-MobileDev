import 'package:flutter/material.dart';
import '../state/todo_scope.dart';

class EditTodoScreen extends StatefulWidget {
  final String todoId;

  const EditTodoScreen({super.key, required this.todoId});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  String? _errorText;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final todo = TodoScope.of(context).todos.firstWhere((t) => t.id == widget.todoId);
    _titleController = TextEditingController(text: todo.title);
    _descController = TextEditingController(text: todo.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _errorText = 'Назва не може бути порожньою');
      return;
    }

    final todoModel = TodoScope.of(context);
    final currentTodo = todoModel.todos.firstWhere((t) => t.id == widget.todoId);

    final updated = currentTodo.copyWith(
      title: title,
      description: _descController.text.trim(),
    );
    todoModel.update(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редагувати справу'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _handleSave),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Назва',
                errorText: _errorText,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Опис'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}