import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isRefreshing;
  final Color? color;
  final double size;
  final String? label;

  const CustomButton({
    Key? key,
    this.onPressed,
    this.isRefreshing = false,
    this.color,
    this.size = 40,
    this.label,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    if (widget.isRefreshing) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRefreshing != oldWidget.isRefreshing) {
      if (widget.isRefreshing) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    if (widget.label != null) {
      return ElevatedButton.icon(
        onPressed: widget.isRefreshing ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: RotationTransition(
          turns: _controller,
          child: Icon(Icons.refresh, size: widget.size * 0.6),
        ),
        label: Text(
          widget.label!,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );
    }

    return IconButton(
      onPressed: widget.isRefreshing ? null : widget.onPressed,
      icon: RotationTransition(
        turns: _controller,
        child: Icon(
          Icons.refresh,
          size: widget.size,
          color: color,
        ),
      ),
    );
  }
}
