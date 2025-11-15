import 'package:flutter/material.dart';
class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);
  @override
  State<Screen> createState() => _ScreenState();
}
class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(title: const Text('Screen'), backgroundColor: const Color(0xFF3B82F6)),
      body: ListView(padding: const EdgeInsets.all(16), children: const [Text('Content')]),
    );
  }
}
