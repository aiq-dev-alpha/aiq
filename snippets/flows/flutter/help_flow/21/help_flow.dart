import 'package:flutter/material.dart';

class Flow {
  final Color primaryColor;

  const Flow({this.primaryColor = const Color(0xFF6200EE)});

  Future<bool> start(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => _FlowScreen(color: primaryColor)),
    );
    return result ?? false;
  }
}

class _FlowScreen extends StatefulWidget {
  final Color color;

  const _FlowScreen({required this.color});

  @override
  State<_FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends State<_FlowScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow'),
        backgroundColor: widget.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
