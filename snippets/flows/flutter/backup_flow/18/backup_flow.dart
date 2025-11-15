import 'package:flutter/material.dart';

class Flow {
  final Color primaryColor;

  const Flow({this.primaryColor = const Color(0xFF1976D2)});

  void start(BuildContext context, {VoidCallback? onComplete}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FlowScreen(color: primaryColor, onComplete: onComplete),
      ),
    );
  }
}

class _FlowScreen extends StatelessWidget {
  final Color color;
  final VoidCallback? onComplete;

  const _FlowScreen({required this.color, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow'),
        backgroundColor: color,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: color),
            const SizedBox(height: 24),
            const Text('Flow in progress', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: color),
              onPressed: () {
                onComplete?.call();
                Navigator.of(context).pop();
              },
              child: const Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
