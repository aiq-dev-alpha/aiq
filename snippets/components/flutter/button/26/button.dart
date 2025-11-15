import 'package:flutter/material.dart';

class ButtonThemeConfig {
  final Color primaryColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;

  const ButtonThemeConfig({
    this.primaryColor = const Color(0xFF6200EE),
    this.textColor = Colors.white,
    this.height = 48.0,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonThemeConfig? theme;
  final bool loading;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.theme,
    this.loading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const ButtonThemeConfig();

    return SizedBox(
      height: effectiveTheme.height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveTheme.primaryColor,
          foregroundColor: effectiveTheme.textColor,
          padding: effectiveTheme.padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
          ),
        ),
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTheme.textColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}
