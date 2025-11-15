import 'package:flutter/material.dart';

class SocialFlow {
  final Color primaryColor;

  const SocialFlow({this.primaryColor = const Color(0xFF1976D2)});

  Future<List<String>> start(BuildContext context) async {
    final result = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(builder: (_) => _FlowScreen(color: primaryColor)),
    );
    return result ?? [];
  }
}

class _FlowScreen extends StatefulWidget {
  final Color color;

  const _FlowScreen({required this.color});

  @override
  State<_FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends State<_FlowScreen> {
  final List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select'),
        backgroundColor: widget.color,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_selected),
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final item = 'Item ${index + 1}';
          final isSelected = _selected.contains(item);
          return CheckboxListTile(
            title: Text(item),
            value: isSelected,
            activeColor: widget.color,
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _selected.add(item);
                } else {
                  _selected.remove(item);
                }
              });
            },
          );
        },
      ),
    );
  }
}
