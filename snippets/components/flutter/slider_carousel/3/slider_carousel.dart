import 'package:flutter/material.dart';

class CustomCarousel extends StatefulWidget {
  final List<Widget> items;
  final double itemWidth;
  final double itemHeight;
  final double spacing;
  final EdgeInsets padding;

  const CustomCarousel({
    Key? key,
    required this.items,
    this.itemWidth = 300,
    this.itemHeight = 200,
    this.spacing = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  }) : super(key: key);

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.itemHeight,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final itemPosition = (index * (widget.itemWidth + widget.spacing)) - _scrollOffset;
          final screenWidth = MediaQuery.of(context).size.width;
          final centerPosition = (screenWidth / 2) - (widget.itemWidth / 2);
          final distanceFromCenter = (itemPosition - centerPosition).abs();
          final scale = (1 - (distanceFromCenter / screenWidth)).clamp(0.8, 1.0);

          return Padding(
            padding: EdgeInsets.only(right: widget.spacing),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: widget.itemWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.items[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
