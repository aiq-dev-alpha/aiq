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
      duration: const Duration(milliseconds: 1850),
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
            offset: Offset(0, 21 * (1 - _controller.value)),
            child: Container(
              padding: widget.padding ?? const EdgeInsets.all(41),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(16.toDouble()),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 31.toDouble(),
                    offset: Offset(0, 5.toDouble()),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 25.toDouble(),
                      fontWeight: FontWeight.w700,
                      color: widget.textColor,
                      letterSpacing: -0.30000000000000004,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 15.toDouble(),
                      height: 1.5,
                      color: widget.textColor.withOpacity(0.81),
                    ),
                  ),
                  if (widget.action != null) ...[
                    const SizedBox(height: 21),
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
