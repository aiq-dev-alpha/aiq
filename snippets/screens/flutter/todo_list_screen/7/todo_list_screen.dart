import 'package:flutter/material.dart';

abstract class TodoStyler {
  Color get backgroundColor;
  Color get primaryColor;
  Widget buildTodoItem(Todo todo, VoidCallback onToggle, VoidCallback onDelete);
  Widget buildEmptyState();
  Widget buildAddButton(VoidCallback onPressed);
}

class MinimalTodoStyle implements TodoStyler {
  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get primaryColor => const Color(0xFF1976D2);

  @override
  Widget buildTodoItem(Todo todo, VoidCallback onToggle, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            todo.done ? Icons.check_circle : Icons.circle_outlined,
            color: todo.done ? primaryColor : Colors.grey,
          ),
          onPressed: onToggle,
        ),
        title: Text(
          todo.text,
          style: TextStyle(
            decoration: todo.done ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: onDelete,
        ),
      ),
    );
  }

  @override
  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('No tasks', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  @override
  Widget buildAddButton(VoidCallback onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: primaryColor,
      child: const Icon(Icons.add),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  final TodoStyler styler;
  final List<Todo> todos;

  const TodoListScreen({
    Key? key,
    TodoStyler? styler,
    List<Todo>? todos,
  })  : styler = styler ?? const MinimalTodoStyle(),
        todos = todos ?? const [],
        super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late List<Todo> _todos;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _todos = List.from(widget.todos);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _todos.add(Todo(id: '${_todos.length}', text: _controller.text, done: false));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.styler.backgroundColor,
      appBar: AppBar(
        title: const Text('Todos'),
        backgroundColor: widget.styler.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'New task',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addTodo(),
            ),
          ),
          Expanded(
            child: _todos.isEmpty
                ? widget.styler.buildEmptyState()
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, i) => widget.styler.buildTodoItem(
                      _todos[i],
                      () => setState(() => _todos[i] = _todos[i].toggle()),
                      () => setState(() => _todos.removeAt(i)),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.styler.buildAddButton(_addTodo),
    );
  }
}

class Todo {
  final String id;
  final String text;
  final bool done;

  const Todo({required this.id, required this.text, required this.done});

  Todo toggle() => Todo(id: id, text: text, done: !done);
}
