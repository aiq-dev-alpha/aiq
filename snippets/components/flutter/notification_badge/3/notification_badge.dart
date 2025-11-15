import 'package:flutter/material.dart';

class CustomBadge extends StatefulWidget {
  final Widget child;
  final int count;
  final Color? badgeColor;
  final Color? textColor;
  final double? maxCount;
  final bool showZero;
  final bool animate;

  const CustomBadge({
    Key? key,
    required this.child,
    this.count = 0,
    this.badgeColor,
    this.textColor,
    this.maxCount,
    this.showZero = false,
    this.animate = true,
  }) : super(key: key);

  @override
  State<CustomBadge> createState() => _CustomBadgeState();
}

class _CustomBadgeState extends State<CustomBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    if (widget.count > 0 || widget.showZero) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CustomBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count && widget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getBadgeText() {
    if (widget.maxCount != null && widget.count > widget.maxCount!) {
      return '${widget.maxCount!.toInt()}+';
    }
    return widget.count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final shouldShow = widget.count > 0 || widget.showZero;
    final badgeColor = widget.badgeColor ?? Colors.red;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (shouldShow)
          Positioned(
            top: -8,
            right: -8,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.animate ? _scaleAnimation.value : 1.0,
                  child: Opacity(
                    opacity: widget.animate ? _fadeAnimation.value : 1.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: badgeColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          _getBadgeText(),
                          style: TextStyle(
                            color: widget.textColor ?? Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
