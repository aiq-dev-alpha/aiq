import 'package:flutter/material.dart';

abstract class InputFieldStyler {
  InputDecoration buildDecoration(String? label, String? hint);
  TextStyle get textStyle;
  EdgeInsets get contentPadding;
}

class UnderlineInputStyle implements InputFieldStyler {
  final Color accentColor;

  const UnderlineInputStyle({
    this.accentColor = const Color(0xFF1976D2),
  });

  @override
  InputDecoration buildDecoration(String? label, String? hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: accentColor),
      contentPadding: contentPadding,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
    );
  }

  @override
  TextStyle get textStyle => const TextStyle(fontSize: 16);

  @override
  EdgeInsets get contentPadding => const EdgeInsets.symmetric(vertical: 12);
}

class OutlinedInputStyle implements InputFieldStyler {
  final Color borderColor;
  final Color focusColor;

  const OutlinedInputStyle({
    this.borderColor = const Color(0xFFBDBDBD),
    this.focusColor = const Color(0xFF6200EE),
  });

  @override
  InputDecoration buildDecoration(String? label, String? hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      contentPadding: contentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusColor, width: 2),
      ),
    );
  }

  @override
  TextStyle get textStyle => const TextStyle(fontSize: 15);

  @override
  EdgeInsets get contentPadding => const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
}

class CustomInputField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final InputFieldStyler styler;
  final bool isPassword;
  final String? Function(String?)? validate;

  const CustomInputField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    InputFieldStyler? styler,
    this.isPassword = false,
    this.validate,
  })  : styler = styler ?? const OutlinedInputStyle(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validate,
      style: styler.textStyle,
      decoration: styler.buildDecoration(label, hint),
    );
  }
}
