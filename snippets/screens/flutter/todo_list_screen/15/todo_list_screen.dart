import 'package:flutter/material.dart';

class TodoListScreen extends StatefulWidget {
  final Color primaryColor;
  final Color backgroundColor;
  
  const TodoListScreen({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> _todos = [];
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: widget.primaryColor,
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
              onSubmitted: (v) {
                if (v.trim().isNotEmpty) {
                  setState(() => _todos.add(v));
                  _controller.clear();
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_todos[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => _todos.removeAt(index)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
