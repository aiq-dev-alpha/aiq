import 'package:flutter/material.dart';

class CustomComponent extends StatelessWidget {
  final Color color;
  final double size;
  
  const CustomComponent({
    Key? key,
    this.color = const Color(0xFF6200EE),
    this.size = 48.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: color,
      child: const Center(child: Icon(Icons.widgets)),
    );
  }
}
