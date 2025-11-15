import 'package:flutter/material.dart';

class CardConfig {
  final Color backgroundColor;
  final Color shadowColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  final Border? border;

  const CardConfig({
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black12,
    this.elevation = 2.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16),
    this.border,
  });
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final CardConfig? config;
  final VoidCallback? onTap;

  const CustomCard({
    Key? key,
    required this.child,
    this.config,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const CardConfig();

    return Material(
      color: effectiveConfig.backgroundColor,
      borderRadius: BorderRadius.circular(effectiveConfig.borderRadius),
      elevation: effectiveConfig.elevation,
      shadowColor: effectiveConfig.shadowColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveConfig.borderRadius),
        child: Container(
          padding: effectiveConfig.padding,
          decoration: BoxDecoration(
            border: effectiveConfig.border,
            borderRadius: BorderRadius.circular(effectiveConfig.borderRadius),
          ),
          child: child,
        ),
      ),
    );
  }
}
