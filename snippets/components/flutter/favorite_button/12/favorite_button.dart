import 'package:flutter/material.dart';

class CustomComponent extends StatefulWidget {
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback? onTap;
  
  const CustomComponent({
    Key? key,
    this.activeColor = const Color(0xFFFF9800),
    this.inactiveColor = const Color(0xFFBDBDBD),
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomComponent> createState() => _CustomComponentState();
}

class _CustomComponentState extends State<CustomComponent> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _active = !_active);
        widget.onTap?.call();
      },
      child: Icon(
        Icons.star,
        color: _active ? widget.activeColor : widget.inactiveColor,
        size: 32,
      ),
    );
  }
}
