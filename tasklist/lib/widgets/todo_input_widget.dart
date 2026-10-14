import 'package:flutter/material.dart';
import '../state/todo_scope.dart';

class TodoInputWidget extends StatefulWidget {
  const TodoInputWidget({super.key});

  @override
  State<TodoInputWidget> createState() => _TodoInputWidgetState();
}

class _TodoInputWidgetState extends State<TodoInputWidget> {
  final _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _errorText = 'Порожня назва');
      return;
    }
    // Отримуємо модель напряму через Scope без callback від батька
    TodoScope.of(context).add(text);
    _controller.clear();
    setState(() => _errorText = null);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build: TodoInputWidget'); // Доведено: не перебудовується при toggle справи!
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Нова справа',
                errorText: _errorText,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}