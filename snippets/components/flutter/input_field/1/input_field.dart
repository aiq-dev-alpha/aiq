import 'package:flutter/material.dart';
class CustomInputField extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final Color? color;
  const CustomInputField({
  Key? key,
  this.child,
  this.onTap,
  this.color,
  }) : super(key: key);
  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
  return GestureDetector(
  onTap: widget.onTap,
  child: Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
  gradient: LinearGradient(
  colors: [
  widget.color ?? Theme.of(context).primaryColor,
  (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.8),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
  BoxShadow(
  color: (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.3),
  blurRadius: 15,
  offset: const Offset(0, 5),
  ),
  ],
  ),
  child: widget.child ?? const Text('Component', style: const TextStyle(color: Colors.white)),
  ),
  );
  }
}
