import 'package:flutter/material.dart';
class CustomComponent extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  const CustomComponent({
  Key? key,
  this.text = 'Button',
  this.onPressed,
  this.icon,
  this.color,
  }) : super(key: key);
  @override
  State<CustomComponent> createState() => _CustomComponentState();
}

class _CustomComponentState extends State<CustomComponent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
  super.initState();
  _controller = AnimationController(
  duration: const Duration(milliseconds: 150),
  vsync: this,
  );
  _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }
  @override
  void dispose() {
  _controller.dispose();
  super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  return GestureDetector(
  onTapDown: (_) => _controller.forward(),
  onTapUp: (_) {
  _controller.reverse();
  widget.onPressed?.call();
  },
  onTapCancel: () => _controller.reverse(),
  child: ScaleTransition(
  scale: _scaleAnimation,
  child: Container(
  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  decoration: BoxDecoration(
  gradient: LinearGradient(
  colors: [
  widget.color ?? Theme.of(context).primaryColor,
  (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.7),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
  BoxShadow(
  color: (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.4),
  blurRadius: 16,
  offset: const Offset(0, 6),
  ),
  ],
  ),
  child: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
  if (widget.icon != null) ...[
  Icon(widget.icon, color: Colors.white, size: 22),
  const SizedBox(width: 10),
  ],
  Text(
  widget.text,
  style: const TextStyle(
  color: Colors.white,
  fontSize: 17,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.5,
  ),
  ),
  ],
  ),
  ),
  ),
  );
  }
}
