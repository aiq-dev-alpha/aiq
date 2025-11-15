import 'package:flutter/material.dart';
class BarComponent extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  const BarComponent({
  Key? key,
  this.child,
  this.onTap,
  }) : super(key: key);
  @override
  State<BarComponent> createState() => _BarComponentState();
}

class _BarComponentState extends State<BarComponent> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
  return MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  child: GestureDetector(
  onTap: widget.onTap,
  child: AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
  padding: const EdgeInsets.all(22),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  boxShadow: [
  BoxShadow(
  color: Colors.black.withOpacity(_isHovered ? 0.18 : 0.08),
  blurRadius: _isHovered ? 25 : 12,
  offset: Offset(0, _isHovered ? 10 : 4),
  ),
  ],
  ),
  child: widget.child ?? const Text('Component'),
  ),
  ),
  );
  }
}
