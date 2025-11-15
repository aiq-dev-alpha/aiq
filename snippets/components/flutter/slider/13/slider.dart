import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final Color activeColor;
  
  const CustomSlider({
    Key? key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.activeColor = const Color(0xFF6200EE),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value.clamp(min, max),
      min: min,
      max: max,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }
}
