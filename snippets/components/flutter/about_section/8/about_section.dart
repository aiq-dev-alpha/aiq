import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomSection extends StatefulWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final Widget? action;
  final List<Color>? decorativeColors;
  final EdgeInsetsGeometry? padding;

  const CustomSection({
    Key? key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.action,
    this.decorativeColors,
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
      duration: const Duration(milliseconds: 2000),
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
    final colors = widget.decorativeColors ?? [
      Colors.blue,
      Colors.purple,
      Colors.pink,
    ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.1 * _controller.value,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: widget.padding ?? const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: Offset(0, 20 * (1 - _controller.value)),
                    child: Opacity(
                      opacity: _controller.value,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: widget.textColor,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Transform.scale(
                        scale: _controller.value,
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          width: index == 0 ? 24 : 16,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colors[index % colors.length].withOpacity(0.7),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Transform.translate(
                    offset: Offset(0, 30 * (1 - _controller.value)),
                    child: Opacity(
                      opacity: _controller.value,
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.7,
                          color: widget.textColor.withOpacity(0.85),
                        ),
                      ),
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
          ],
        );
      },
    );
  }
}
