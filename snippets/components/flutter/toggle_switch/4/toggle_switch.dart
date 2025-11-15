import 'package:flutter/material.dart';

class ToggleSwitchConfig {
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double width;
  final double height;

  const ToggleSwitchConfig({
    this.activeColor = const Color(0xFF4CAF50),
    this.inactiveColor = const Color(0xFFBDBDBD),
    this.thumbColor = Colors.white,
    this.width = 50.0,
    this.height = 28.0,
  });
}

class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final ToggleSwitchConfig? config;

  const CustomToggleSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const ToggleSwitchConfig();

    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: effectiveConfig.width,
        height: effectiveConfig.height,
        decoration: BoxDecoration(
          color: value ? effectiveConfig.activeColor : effectiveConfig.inactiveColor,
          borderRadius: BorderRadius.circular(effectiveConfig.height / 2),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: effectiveConfig.height - 4,
            height: effectiveConfig.height - 4,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: effectiveConfig.thumbColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
