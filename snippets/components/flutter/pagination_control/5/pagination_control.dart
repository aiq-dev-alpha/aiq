import 'package:flutter/material.dart';
class ControlComponent extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  const ControlComponent({
  Key? key,
  this.child,
  this.onTap,
  }) : super(key: key);
  @override
  State<ControlComponent> createState() => _ControlComponentState();
}
class _ControlComponentState extends State<ControlComponent> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
  return GestureDetector(
  onTapDown: (_) => setState(() => _isPressed = true),
  onTapUp: (_) {
  setState(() => _isPressed = false);
  widget.onTap?.call();
  },
  onTapCancel: () => setState(() => _isPressed = false),
  child: AnimatedContainer(
  duration: const Duration(milliseconds: 150),
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
  color: Colors.grey.shade200,
  borderRadius: BorderRadius.circular(20),
  boxShadow: _isPressed
  ? [
  BoxShadow(
  color: Colors.grey.shade400,
  offset: const Offset(2, 2),
  blurRadius: 4,
  ),
  const BoxShadow(
  color: Colors.white,
  offset: Offset(-2, -2),
  blurRadius: 4,
  ),
  ]
  : [
  BoxShadow(
  color: Colors.grey.shade400,
  offset: const Offset(4, 4),
  blurRadius: 8,
  ),
  const BoxShadow(
  color: Colors.white,
  offset: Offset(-4, -4),
  blurRadius: 8,
  ),
  ],
  ),
  child: widget.child ?? const Text('Component'),
  ),
  );
  }
}
