import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  final Color inactiveColor;
  
  const CustomToggleSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.activeColor = const Color(0xFF4CAF50),
    this.inactiveColor = const Color(0xFFBDBDBD),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      inactiveTrackColor: inactiveColor,
    );
  }
}
