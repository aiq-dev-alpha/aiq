import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const CustomPicker({
    Key? key,
    this.backgroundColor,
    this.textColor,
    this.accentColor,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 960),
      vsync: this,
    );
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 204),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
        _hoverController.forward();
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
        _hoverController.reverse();
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 204),
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -2.0 : 0.0),
            padding: widget.padding ?? const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: (widget.accentColor ?? Theme.of(context).primaryColor).withOpacity(
                  _isHovered ? 0.6 : 0.2
                ),
                width: _isHovered ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.16 : 0.8),
                  blurRadius: _isHovered ? 19.0 : 12.0,
                  offset: Offset(0, _isHovered ? 4.0 : 3.0),
                ),
              ],
            ),
            child: const Center(
              child: Text('Component', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}
