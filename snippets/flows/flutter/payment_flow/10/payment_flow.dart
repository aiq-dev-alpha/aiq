import 'package:flutter/material.dart';

class _PaymentMethodScreen extends StatefulWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const _PaymentMethodScreen({
    Key? key,
    this.backgroundColor,
    this.textColor,
    this.padding,
  }) : super(key: key);

  @override
  State<_PaymentMethodScreen> createState() => __PaymentMethodScreenState();
}

class __PaymentMethodScreenState extends State<_PaymentMethodScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
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
    return FadeTransition(
      opacity: _controller,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: Text('Component')),
      ),
    );
  }
}
