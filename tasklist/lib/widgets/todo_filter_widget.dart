import 'package:flutter/material.dart';

enum TodoFilter { all, active, completed }

class TodoFilterWidget extends StatelessWidget {
  final TodoFilter currentFilter;
  final ValueChanged<TodoFilter> onFilterChanged;

  const TodoFilterWidget({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TodoFilter>(
      segments: const [
        ButtonSegment(value: TodoFilter.all, label: Text('Усі')),
        ButtonSegment(value: TodoFilter.active, label: Text('Активні')),
        ButtonSegment(value: TodoFilter.completed, label: Text('Виконані')),
      ],
      selected: {currentFilter},
      onSelectionChanged: (selected) => onFilterChanged(selected.first),
    );
  }
}