import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundColor;
  
  const Screen({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Screen'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: primaryColor),
            const SizedBox(height: 24),
            const Text('Screen Content', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
