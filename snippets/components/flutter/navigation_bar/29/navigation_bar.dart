import 'package:flutter/material.dart';

class BarComponent extends StatefulWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;

  const BarComponent({
    Key? key,
    this.backgroundColor,
    this.textColor,
    this.accentColor,
    this.padding,
  }) : super(key: key);

  @override
  State<BarComponent> createState() => _BarComponentState();
}

class _BarComponentState extends State<BarComponent> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 860),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -3.0 : 0.0),
          padding: widget.padding ?? const EdgeInsets.all(33),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: (widget.accentColor ?? Colors.blue).withOpacity(_isHovered ? 0.6 : 0.2),
              width: _isHovered ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
                blurRadius: _isHovered ? 16.0 : 10.0,
                offset: Offset(0, _isHovered ? 4.0 : 2.0),
              ),
            ],
          ),
          child: const Center(child: Text('Component')),
        ),
      ),
    );
  }
}
