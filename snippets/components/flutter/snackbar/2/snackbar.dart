import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, backgroundColor: const Color(0xFF4CAF50));
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, backgroundColor: const Color(0xFFF44336));
  }
}
