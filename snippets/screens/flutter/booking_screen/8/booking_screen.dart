import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;
  
  const Screen({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    this.accentColor = const Color(0xFF03DAC6),
  }) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen'),
        backgroundColor: widget.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, size: 80, color: widget.primaryColor),
            const SizedBox(height: 24),
            Text(
              'Selected: $_selectedIndex',
              style: TextStyle(fontSize: 18, color: widget.accentColor),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: widget.primaryColor,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
