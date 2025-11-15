import 'package:flutter/material.dart';
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final bool outlined;
  const CustomButton({
  Key? key,
  this.text = 'Button',
  this.onPressed,
  this.borderColor,
  this.outlined = true,
  }) : super(key: key);
  @override
  State<CustomButton> createState() => _CustomButtonState();
}
class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
  final color = widget.borderColor ?? Theme.of(context).primaryColor;
  return MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  child: GestureDetector(
  onTap: widget.onPressed,
  child: AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeInOut,
  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
  decoration: BoxDecoration(
  color: _isHovered ? color : Colors.transparent,
  border: Border.all(color: color, width: 2),
  borderRadius: BorderRadius.circular(25),
  boxShadow: _isHovered
  ? [
  BoxShadow(
  color: color.withOpacity(0.3),
  blurRadius: 12,
  offset: const Offset(0, 4),
  ),
  ]
  : [],
  ),
  child: Text(
  widget.text,
  style: TextStyle(
  color: _isHovered ? Colors.white : color,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  ),
  ),
  ),
  ),
  );
  }
}
