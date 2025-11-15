import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  
  const CustomProgressBar({
    Key? key,
    required this.value,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = const Color(0xFF4CAF50),
    this.height = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        ),
      ),
    );
  }
}
