import 'package:flutter/material.dart';

class CustomRating extends StatefulWidget {
  final double rating;
  final Function(double)? onRatingUpdate;
  final int starCount;
  final double size;
  final Color? color;
  final bool readOnly;

  const CustomRating({
    Key? key,
    this.rating = 0,
    this.onRatingUpdate,
    this.starCount = 5,
    this.size = 28,
    this.color,
    this.readOnly = false,
  }) : super(key: key);
  @override
  State<CustomRating> createState() => _CustomRatingState();
}

class _CustomRatingState extends State<CustomRating> with TickerProviderStateMixin {
  late double _currentRating;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
    _controllers = List.generate(
      widget.starCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 50)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    Future.delayed(Duration.zero, () {
      for (var controller in _controllers) {
        controller.forward();
      }
    });
  }
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTap(int index) {
    if (widget.readOnly || widget.onRatingUpdate == null) return;

    final newRating = (index + 1).toDouble();
    setState(() {
      _currentRating = newRating;
    });

    _controllers[index].forward(from: 0.7);
    widget.onRatingUpdate?.call(newRating);
  }
  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Colors.amber;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) {
        final isFilled = index < _currentRating;

        return GestureDetector(
          onTap: () => _handleTap(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _animations[index].value,
                  child: Icon(
                    isFilled ? Icons.star : Icons.star_border,
                    size: widget.size,
                    color: isFilled ? color : Colors.grey.shade300,
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
