import 'package:flutter/material.dart';

class CustomComponent extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final bool elevated;

  const CustomComponent({
  Key? key,
  this.text = 'Button',
  this.onPressed,
  this.backgroundColor,
  this.elevated = true,
  }) : super(key: key);

  @override
  State<CustomComponent> createState() => _CustomComponentState();
}

class _CustomComponentState extends State<CustomComponent> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
  return MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  child: GestureDetector(
  onTap: widget.onPressed,
  child: AnimatedContainer(
  duration: const Duration(milliseconds: 280),
  curve: Curves.easeInOutCubic,
  transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
  decoration: BoxDecoration(
  color: widget.backgroundColor ?? Theme.of(context).primaryColor,
  borderRadius: BorderRadius.circular(12),
  boxShadow: widget.elevated
  ? [
  BoxShadow(
  color: (widget.backgroundColor ?? Theme.of(context).primaryColor)
  .withOpacity(_isHovered ? 0.6 : 0.35),
  blurRadius: _isHovered ? 24 : 12,
  offset: Offset(0, _isHovered ? 10 : 5),
  ),
  ]
  : [],
  ),
  child: Text(
  widget.text,
  style: const TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.2,
  ),
  ),
  ),
  ),
  );
  }
}
