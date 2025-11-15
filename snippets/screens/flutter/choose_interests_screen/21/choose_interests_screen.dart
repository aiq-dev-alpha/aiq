import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  final Color primaryColor;
  
  const Screen({
    Key? key,
    this.primaryColor = const Color(0xFF1976D2),
  }) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen'),
        backgroundColor: widget.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Screen Content', style: TextStyle(color: widget.primaryColor)),
          ],
        ),
      ),
    );
  }
}
