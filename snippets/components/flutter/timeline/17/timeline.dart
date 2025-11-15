import 'package:flutter/material.dart';

class CustomComponent extends StatelessWidget {
  final double value;
  final Color color;
  final Color backgroundColor;
  final double size;
  
  const CustomComponent({
    Key? key,
    this.value = 0.5,
    this.color = const Color(0xFF6200EE),
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.size = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value.clamp(0.0, 1.0),
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: 8,
          ),
          Text(
            '${(value * 100).toInt()}%',
            style: TextStyle(
              fontSize: size * 0.15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
