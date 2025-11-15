import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final Color? color;

  const CustomSlider({
    Key? key,
    this.child,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        child: widget.child ?? const Text('Component', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
