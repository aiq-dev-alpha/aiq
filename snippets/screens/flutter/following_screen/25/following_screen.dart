import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Color accentColor;
  final String title;
  
  const Screen({
    Key? key,
    this.accentColor = const Color(0xFF03DAC6),
    this.title = 'Screen',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: accentColor,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => ListTile(
          title: Text('Item ${index + 1}'),
          leading: Icon(Icons.circle, color: accentColor),
        ),
      ),
    );
  }
}
