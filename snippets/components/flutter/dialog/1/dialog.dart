import 'package:flutter/material.dart';

class DialogConfig {
  final Color backgroundColor;
  final Color titleColor;
  final Color contentColor;
  final double borderRadius;
  final EdgeInsets padding;

  const DialogConfig({
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black87,
    this.contentColor = Colors.black54,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(24),
  });
}

class CustomDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    DialogConfig? config,
  }) {
    final effectiveConfig = config ?? const DialogConfig();

    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(effectiveConfig.borderRadius),
        ),
        child: Container(
          padding: effectiveConfig.padding,
          decoration: BoxDecoration(
            color: effectiveConfig.backgroundColor,
            borderRadius: BorderRadius.circular(effectiveConfig.borderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: effectiveConfig.titleColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  color: effectiveConfig.contentColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (cancelText != null)
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(cancelText),
                    ),
                  if (cancelText != null) const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(confirmText ?? 'OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showAlert(
    BuildContext context, {
    required String title,
    required String message,
    DialogConfig? config,
  }) {
    return show(
      context,
      title: title,
      content: message,
      confirmText: 'OK',
      config: config,
    ).then((_) {});
  }

  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    DialogConfig? config,
  }) {
    return show(
      context,
      title: title,
      content: message,
      confirmText: confirmText ?? 'Confirm',
      cancelText: cancelText ?? 'Cancel',
      config: config,
    ).then((value) => value ?? false);
  }
}
