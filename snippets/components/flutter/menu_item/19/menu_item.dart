import 'package:flutter/material.dart';

class CustomComponent extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final double width;
  final double height;
  
  const CustomComponent({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    this.secondaryColor = const Color(0xFF03DAC6),
    this.width = 200.0,
    this.height = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Icon(Icons.widgets, color: Colors.white)),
    );
  }
}
