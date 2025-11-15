import 'package:flutter/material.dart';
class Screen extends StatelessWidget {
  const Screen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(title: const Text('Screen')),
      body: const Padding(padding: EdgeInsets.all(16), child: Text('Content')),
    );
  }
}
