import 'package:flutter/material.dart';

class ProgressBarConfig {
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final double borderRadius;
  final bool showPercentage;

  const ProgressBarConfig({
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = const Color(0xFF4CAF50),
    this.height = 8.0,
    this.borderRadius = 4.0,
    this.showPercentage = false,
  });
}

class CustomProgressBar extends StatelessWidget {
  final double value;
  final ProgressBarConfig? config;

  const CustomProgressBar({
    Key? key,
    required this.value,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const ProgressBarConfig();
    final clampedValue = value.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: effectiveConfig.height,
          decoration: BoxDecoration(
            color: effectiveConfig.backgroundColor,
            borderRadius: BorderRadius.circular(effectiveConfig.borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(effectiveConfig.borderRadius),
            child: LinearProgressIndicator(
              value: clampedValue,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveConfig.progressColor),
            ),
          ),
        ),
        if (effectiveConfig.showPercentage) ...[
          const SizedBox(height: 4),
          Text(
            '${(clampedValue * 100).toInt()}%',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }
}
