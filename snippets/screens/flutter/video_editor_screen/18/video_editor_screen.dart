import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Color themeColor;
  final String title;
  final IconData icon;
  
  const Screen({
    Key? key,
    this.themeColor = const Color(0xFF1976D2),
    this.title = 'Screen',
    this.icon = Icons.location_on,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: themeColor,
      ),
      body: Stack(
        children: [
          Container(
            color: themeColor.withOpacity(0.1),
            child: Center(
              child: Icon(icon, size: 120, color: themeColor),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {},
              child: const Text('Action'),
            ),
          ),
        ],
      ),
    );
  }
}
