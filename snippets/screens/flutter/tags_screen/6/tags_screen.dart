import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  
  const Screen({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    this.secondaryColor = const Color(0xFF03DAC6),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Screen'),
        backgroundColor: primaryColor,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: List.generate(
          8,
          (i) => Card(
            color: i.isEven ? primaryColor.withOpacity(0.1) : secondaryColor.withOpacity(0.1),
            child: Center(child: Text('${i + 1}')),
          ),
        ),
      ),
    );
  }
}
