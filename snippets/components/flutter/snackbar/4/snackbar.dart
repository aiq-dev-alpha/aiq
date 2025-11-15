import 'package:flutter/material.dart';

class SnackbarConfig {
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;
  final SnackBarBehavior behavior;

  const SnackbarConfig({
    this.backgroundColor = const Color(0xFF323232),
    this.textColor = Colors.white,
    this.duration = const Duration(seconds: 3),
    this.behavior = SnackBarBehavior.floating,
  });
}

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarConfig? config,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final effectiveConfig = config ?? const SnackbarConfig();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: effectiveConfig.textColor),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: effectiveConfig.textColor),
              ),
            ),
          ],
        ),
        backgroundColor: effectiveConfig.backgroundColor,
        duration: effectiveConfig.duration,
        behavior: effectiveConfig.behavior,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: effectiveConfig.textColor,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(
      context,
      message: message,
      config: const SnackbarConfig(backgroundColor: Color(0xFF4CAF50)),
      icon: Icons.check_circle,
    );
  }

  static void showError(BuildContext context, String message) {
    show(
      context,
      message: message,
      config: const SnackbarConfig(backgroundColor: Color(0xFFF44336)),
      icon: Icons.error,
    );
  }

  static void showWarning(BuildContext context, String message) {
    show(
      context,
      message: message,
      config: const SnackbarConfig(backgroundColor: Color(0xFFFF9800)),
      icon: Icons.warning,
    );
  }
}
