import 'package:flutter/material.dart';
class BarComponent extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final Color? borderColor;
  const BarComponent({
  Key? key,
  this.child,
  this.onTap,
  this.borderColor,
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
  duration: const Duration(milliseconds: 200),
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
  color: _isHovered
  ? (widget.borderColor ?? Theme.of(context).primaryColor).withOpacity(0.1)
  : Colors.transparent,
  border: Border.all(
  color: widget.borderColor ?? Theme.of(context).primaryColor,
  width: 2,
  ),
  borderRadius: BorderRadius.circular(12),
  ),
  child: widget.child ?? const Text('Component'),
  ),
  ),
  );
  }
}
