import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final bool isFavorite;
  final Function(bool)? onToggle;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;

  const CustomButton({
    Key? key,
    this.isFavorite = false,
    this.onToggle,
    this.activeColor,
    this.inactiveColor,
    this.size = 32,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (_isFavorite) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      if (_isFavorite) {
        _controller.forward(from: 0);
      }
      widget.onToggle?.call(_isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? Colors.red;
    final inactiveColor = widget.inactiveColor ?? Colors.grey.shade400;

    return GestureDetector(
      onTap: _toggleFavorite,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? activeColor : inactiveColor,
              size: widget.size,
            ),
          );
        },
      ),
    );
  }
}
