import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String? label;
  final String? hint;
  final IconData? icon;
  final TextEditingController? controller;
  final bool obscure;
  final Color focusColor;
  
  const CustomField({
    Key? key,
    this.label,
    this.hint,
    this.icon,
    this.controller,
    this.obscure = false,
    this.focusColor = const Color(0xFF6200EE),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: focusColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusColor, width: 2),
        ),
      ),
    );
  }
}
