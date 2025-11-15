import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final Widget child;
  final int? count;
  final bool showZero;
  final Color? badgeColor;
  final Color? textColor;
  final double? size;

  const CustomBadge({
    Key? key,
    required this.child,
    this.count,
    this.showZero = false,
    this.badgeColor,
    this.textColor,
    this.size,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final shouldShow = count != null && (count! > 0 || showZero);
    final badgeSize = size ?? 20;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (shouldShow)
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              constraints: BoxConstraints(minWidth: badgeSize),
              height: badgeSize,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.red,
                borderRadius: BorderRadius.circular(badgeSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: (badgeColor ?? Colors.red).withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  count! > 99 ? '99+' : count.toString(),
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: badgeSize * 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
