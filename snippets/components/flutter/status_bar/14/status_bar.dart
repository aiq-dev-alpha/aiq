import 'package:flutter/material.dart';

class BarComponent extends StatefulWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final BoxShadow? shadow;

  const BarComponent({
    Key? key,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.shadow,
  }) : super(key: key);

  @override
  State<BarComponent> createState() => _BarComponentState();
}

class _BarComponentState extends State<BarComponent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? Colors.white;
    final txtColor = widget.textColor ?? Colors.black87;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: widget.padding ?? const EdgeInsets.all(34),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 24),
            boxShadow: widget.shadow != null ? [widget.shadow!] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Text('Component'),
          ),
        ),
      ),
    );
  }
}
