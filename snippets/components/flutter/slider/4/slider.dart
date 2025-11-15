import 'package:flutter/material.dart';

class SliderConfig {
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double min;
  final double max;
  final int divisions;
  final bool showLabel;

  const SliderConfig({
    this.activeColor = const Color(0xFF6200EE),
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.thumbColor = const Color(0xFF6200EE),
    this.min = 0.0,
    this.max = 100.0,
    this.divisions = 10,
    this.showLabel = true,
  });
}

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final SliderConfig? config;

  const CustomSlider({
    Key? key,
    required this.value,
    this.onChanged,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const SliderConfig();

    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: effectiveConfig.activeColor,
        inactiveTrackColor: effectiveConfig.inactiveColor,
        thumbColor: effectiveConfig.thumbColor,
        overlayColor: effectiveConfig.thumbColor.withOpacity(0.2),
        trackHeight: 4,
      ),
      child: Slider(
        value: value.clamp(effectiveConfig.min, effectiveConfig.max),
        min: effectiveConfig.min,
        max: effectiveConfig.max,
        divisions: effectiveConfig.divisions,
        label: effectiveConfig.showLabel ? value.toStringAsFixed(0) : null,
        onChanged: onChanged,
      ),
    );
  }
}
