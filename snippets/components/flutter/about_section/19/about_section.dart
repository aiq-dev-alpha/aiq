import 'package:flutter/material.dart';

class CustomSection extends StatefulWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final Widget? action;
  final EdgeInsetsGeometry? padding;

  const CustomSection({
    Key? key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.action,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomSection> createState() => _CustomSectionState();
}

class _CustomSectionState extends State<CustomSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1750),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - _controller.value)),
            child: Container(
              padding: widget.padding ?? const EdgeInsets.all(39),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(14.toDouble()),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.13),
                    blurRadius: 29.toDouble(),
                    offset: Offset(0, 3.toDouble()),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 30.toDouble(),
                      fontWeight: FontWeight.w800,
                      color: widget.textColor,
                      letterSpacing: -0.6000000000000001,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 16.toDouble(),
                      height: 1.6,
                      color: widget.textColor.withOpacity(0.79),
                    ),
                  ),
                  if (widget.action != null) ...[
                    const SizedBox(height: 24),
                    Transform.scale(
                      scale: _controller.value,
                      alignment: Alignment.centerLeft,
                      child: widget.action!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
