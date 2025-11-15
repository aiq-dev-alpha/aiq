import 'package:flutter/material.dart';

class CustomNavigation extends StatefulWidget {
  final bool isOpen;
  final VoidCallback? onTap;
  final Color? color;
  final Duration animationDuration;

  const CustomNavigation({
    Key? key,
    this.isOpen = false,
    this.onTap,
    this.color,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topBarRotation;
  late Animation<double> _middleBarOpacity;
  late Animation<double> _bottomBarRotation;
  late Animation<double> _topBarTranslation;
  late Animation<double> _bottomBarTranslation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _topBarRotation = Tween<double>(begin: 0, end: 0.785).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _middleBarOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _bottomBarRotation = Tween<double>(begin: 0, end: -0.785).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _topBarTranslation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _bottomBarTranslation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isOpen) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(CustomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
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

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Top bar
                Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, _topBarTranslation.value)
                    ..rotateZ(_topBarRotation.value),
                  alignment: Alignment.center,
                  child: Container(
                    width: 28,
                    height: 3,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Middle bar
                Opacity(
                  opacity: _middleBarOpacity.value,
                  child: Container(
                    width: 28,
                    height: 3,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Bottom bar
                Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, _bottomBarTranslation.value)
                    ..rotateZ(_bottomBarRotation.value),
                  alignment: Alignment.center,
                  child: Container(
                    width: 28,
                    height: 3,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
