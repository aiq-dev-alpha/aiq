import 'package:flutter/material.dart';

class TodoTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final Color completedColor;
  final Color pendingColor;

  const TodoTheme({
    this.primaryColor = const Color(0xFF6200EE),
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.completedColor = const Color(0xFF4CAF50),
    this.pendingColor = const Color(0xFFFF9800),
  });
}

class TodoListScreen extends StatefulWidget {
  final TodoTheme? theme;
  final List<TodoItem>? initialItems;

  const TodoListScreen({
    Key? key,
    this.theme,
    this.initialItems,
  }) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late List<TodoItem> _items;
  final _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = widget.initialItems ?? [];
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _addTodo() {
    if (_inputController.text.trim().isEmpty) return;
    setState(() {
      _items.add(TodoItem(
        id: DateTime.now().toString(),
        title: _inputController.text,
        completed: false,
      ));
      _inputController.clear();
    });
  }

  void _toggleTodo(int index) {
    setState(() {
      _items[index] = _items[index].copyWith(completed: !_items[index].completed);
    });
  }

  void _deleteTodo(int index) {
    setState(() => _items.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const TodoTheme();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: theme.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _addTodo,
                  backgroundColor: theme.primaryColor,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text(
                      'No tasks yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) => _TodoTile(
                      item: _items[index],
                      theme: theme,
                      onToggle: () => _toggleTodo(index),
                      onDelete: () => _deleteTodo(index),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TodoTile extends StatelessWidget {
  final TodoItem item;
  final TodoTheme theme;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TodoTile({
    required this.item,
    required this.theme,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: item.completed,
          onChanged: (_) => onToggle(),
          activeColor: theme.completedColor,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.completed ? TextDecoration.lineThrough : null,
            color: item.completed ? Colors.grey : Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class TodoItem {
  final String id;
  final String title;
  final bool completed;

  TodoItem({
    required this.id,
    required this.title,
    required this.completed,
  });

  TodoItem copyWith({bool? completed}) {
    return TodoItem(
      id: id,
      title: title,
      completed: completed ?? this.completed,
    );
  }
}
