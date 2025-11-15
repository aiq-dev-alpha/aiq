import 'package:flutter/material.dart';

class CustomComponent extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? leftIcon;
  final IconData? rightIcon;

  const CustomComponent({
    Key? key,
    this.text = 'Button',
    this.onPressed,
    this.leftIcon,
    this.rightIcon,
  }) : super(key: key);

  @override
  State<CustomComponent> createState() => _CustomComponentState();
}

class _CustomComponentState extends State<CustomComponent> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: _isPressed
              ? Theme.of(context).primaryColor.withOpacity(0.85)
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.leftIcon != null) ...[
              Icon(widget.leftIcon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (widget.rightIcon != null) ...[
              const SizedBox(width: 10),
              Icon(widget.rightIcon, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
