import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  final Color primaryColor;
  final int initialScore;
  
  const Screen({
    Key? key,
    this.primaryColor = const Color(0xFFFF9800),
    this.initialScore = 0,
  }) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  late int _score;

  @override
  void initState() {
    super.initState();
    _score = widget.initialScore;
  }

  void _incrementScore() {
    setState(() => _score++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        backgroundColor: widget.primaryColor,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Score: $_score',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.games, size: 100, color: widget.primaryColor),
            const SizedBox(height: 32),
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              onPressed: _incrementScore,
              child: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
