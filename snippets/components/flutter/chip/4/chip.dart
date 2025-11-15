import 'package:flutter/material.dart';

class ChipConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool showBorder;

  const ChipConfig({
    this.backgroundColor = const Color(0xFFE3F2FD),
    this.textColor = const Color(0xFF1976D2),
    this.borderColor = const Color(0xFF1976D2),
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.showBorder = false,
  });
}

class CustomChip extends StatelessWidget {
  final String label;
  final ChipConfig? config;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final IconData? leadingIcon;

  const CustomChip({
    Key? key,
    required this.label,
    this.config,
    this.onTap,
    this.onDelete,
    this.leadingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const ChipConfig();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: effectiveConfig.padding,
        decoration: BoxDecoration(
          color: effectiveConfig.backgroundColor,
          borderRadius: BorderRadius.circular(effectiveConfig.borderRadius),
          border: effectiveConfig.showBorder
              ? Border.all(color: effectiveConfig.borderColor)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 16,
                color: effectiveConfig.textColor,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: effectiveConfig.textColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: effectiveConfig.textColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
