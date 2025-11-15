import 'package:flutter/material.dart';

class BadgeConfig {
  final Color backgroundColor;
  final Color textColor;
  final double size;
  final EdgeInsets padding;
  final BadgePosition position;

  const BadgeConfig({
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.size = 18.0,
    this.padding = const EdgeInsets.all(4),
    this.position = BadgePosition.topRight,
  });
}

enum BadgePosition { topRight, topLeft, bottomRight, bottomLeft }

class CustomBadge extends StatelessWidget {
  final Widget child;
  final String? count;
  final bool showBadge;
  final BadgeConfig? config;

  const CustomBadge({
    Key? key,
    required this.child,
    this.count,
    this.showBadge = true,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const BadgeConfig();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showBadge && count != null)
          Positioned(
            top: _getTop(effectiveConfig.position),
            right: _getRight(effectiveConfig.position),
            bottom: _getBottom(effectiveConfig.position),
            left: _getLeft(effectiveConfig.position),
            child: Container(
              padding: effectiveConfig.padding,
              constraints: BoxConstraints(minWidth: effectiveConfig.size),
              decoration: BoxDecoration(
                color: effectiveConfig.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count!,
                  style: TextStyle(
                    color: effectiveConfig.textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  double? _getTop(BadgePosition pos) {
    return pos == BadgePosition.topRight || pos == BadgePosition.topLeft ? -4 : null;
  }

  double? _getRight(BadgePosition pos) {
    return pos == BadgePosition.topRight || pos == BadgePosition.bottomRight ? -4 : null;
  }

  double? _getBottom(BadgePosition pos) {
    return pos == BadgePosition.bottomRight || pos == BadgePosition.bottomLeft ? -4 : null;
  }

  double? _getLeft(BadgePosition pos) {
    return pos == BadgePosition.topLeft || pos == BadgePosition.bottomLeft ? -4 : null;
  }
}
