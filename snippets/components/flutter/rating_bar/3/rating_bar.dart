import 'package:flutter/material.dart';

class CustomRatingBar extends StatefulWidget {
  final double rating;
  final Function(double)? onRatingChanged;
  final int itemCount;
  final double itemSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final IconData? icon;
  final bool allowHalfRating;

  const CustomRatingBar({
    Key? key,
    this.rating = 0,
    this.onRatingChanged,
    this.itemCount = 5,
    this.itemSize = 32,
    this.activeColor,
    this.inactiveColor,
    this.icon,
    this.allowHalfRating = true,
  }) : super(key: key);
  @override
  State<CustomRatingBar> createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar> {
  late double _rating;
  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
  }

  void _updateRating(double newRating) {
    setState(() {
      _rating = newRating.clamp(0.0, widget.itemCount.toDouble());
    });
    widget.onRatingChanged?.call(_rating);
  }
  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? Colors.amber;
    final inactiveColor = widget.inactiveColor ?? Colors.grey.shade300;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.itemCount, (index) {
        return GestureDetector(
          onTapDown: (details) {
            if (widget.onRatingChanged == null) return;

            final box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);
            final starWidth = widget.itemSize;
            final clickedStarIndex = (localPosition.dx / starWidth).floor();
            final clickPositionInStar = localPosition.dx % starWidth;

            double newRating;
            if (widget.allowHalfRating && clickPositionInStar < starWidth / 2) {
              newRating = clickedStarIndex + 0.5;
            } else {
              newRating = (clickedStarIndex + 1).toDouble();
            }

            _updateRating(newRating);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _buildStar(index, activeColor, inactiveColor),
          ),
        );
      }),
    );
  }

  Widget _buildStar(int index, Color activeColor, Color inactiveColor) {
    final iconData = widget.icon ?? Icons.star;
    final diff = _rating - index;

    if (diff >= 1) {
      return Icon(iconData, size: widget.itemSize, color: activeColor);
    } else if (diff > 0) {
      return Stack(
        children: [
          Icon(iconData, size: widget.itemSize, color: inactiveColor),
          ClipRect(
            clipper: _HalfClipper(percentage: diff),
            child: Icon(iconData, size: widget.itemSize, color: activeColor),
          ),
        ],
      );
    } else {
      return Icon(
        Icons.star_border,
        size: widget.itemSize,
        color: inactiveColor,
      );
    }
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  final double percentage;

  _HalfClipper({required this.percentage});
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * percentage, size.height);
  }
  @override
  bool shouldReclip(_HalfClipper oldClipper) {
    return oldClipper.percentage != percentage;
  }
}
