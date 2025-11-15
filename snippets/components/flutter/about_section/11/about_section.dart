import 'package:flutter/material.dart';

class CustomSection extends StatefulWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final Widget? action;
  final bool showDivider;
  final EdgeInsetsGeometry? padding;

  const CustomSection({
    Key? key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.action,
    this.showDivider = true,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomSection> createState() => _CustomSectionState();
}

class _CustomSectionState extends State<CustomSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _isExpanded = true);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      padding: widget.padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 400),
            style: TextStyle(
              fontSize: _isExpanded ? 28 : 24,
              fontWeight: FontWeight.w700,
              color: widget.textColor,
              letterSpacing: -0.4,
            ),
            child: Text(widget.title),
          ),
          if (widget.showDivider) ...[
            const SizedBox(height: 14),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              width: _isExpanded ? 80 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: widget.textColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
          SizedBox(height: widget.showDivider ? 14 : 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: _isExpanded ? 1.0 : 0.0,
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: 16,
                height: 1.65,
                color: widget.textColor.withOpacity(0.8),
              ),
            ),
          ),
          if (widget.action != null) ...[
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _controller,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOut,
                )),
                child: widget.action!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
