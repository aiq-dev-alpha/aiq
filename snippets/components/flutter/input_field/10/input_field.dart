import 'package:flutter/material.dart';

class InputFieldTheme {
  final Color borderColor;
  final Color focusedBorderColor;
  final Color fillColor;
  final Color textColor;
  final Color labelColor;
  final double borderRadius;
  final bool filled;

  const InputFieldTheme({
    this.borderColor = const Color(0xFFE0E0E0),
    this.focusedBorderColor = const Color(0xFF6200EE),
    this.fillColor = const Color(0xFFF5F5F5),
    this.textColor = Colors.black87,
    this.labelColor = Colors.black54,
    this.borderRadius = 8.0,
    this.filled = true,
  });
}

class CustomInputField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final InputFieldTheme? theme;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomInputField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.theme,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const InputFieldTheme();

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: effectiveTheme.textColor),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: effectiveTheme.labelColor),
        filled: effectiveTheme.filled,
        fillColor: effectiveTheme.fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
          borderSide: BorderSide(color: effectiveTheme.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
          borderSide: BorderSide(color: effectiveTheme.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
          borderSide: BorderSide(color: effectiveTheme.focusedBorderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
