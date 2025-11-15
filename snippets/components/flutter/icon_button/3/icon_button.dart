import 'package:flutter/material.dart';
class CustomComponent extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  const CustomComponent({
  Key? key,
  this.text = 'Button',
  this.onPressed,
  this.isLoading = false,
  this.color,
  }) : super(key: key);
  @override
  State<CustomComponent> createState() => _CustomComponentState();
}

class _CustomComponentState extends State<CustomComponent> {
  @override
  Widget build(BuildContext context) {
  return Material(
  color: Colors.transparent,
  child: InkWell(
  onTap: widget.isLoading ? null : widget.onPressed,
  borderRadius: BorderRadius.circular(10),
  splashColor: (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.2),
  highlightColor: (widget.color ?? Theme.of(context).primaryColor).withOpacity(0.1),
  child: Ink(
  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
  decoration: BoxDecoration(
  color: widget.color ?? Theme.of(context).primaryColor,
  borderRadius: BorderRadius.circular(10),
  ),
  child: widget.isLoading
  ? const SizedBox(
  width: 24,
  height: 24,
  child: CircularProgressIndicator(
  color: Colors.white,
  strokeWidth: 2.5,
  ),
  )
  : Text(
  widget.text,
  style: const TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.8,
  ),
  ),
  ),
  ),
  );
  }
}
