import 'package:flutter/material.dart';

abstract class CardStyler {
  Color get backgroundColor;
  double get elevation;
  BorderRadius get borderRadius;
  EdgeInsets get contentPadding;
  Widget wrapContent(Widget content);
}

class MinimalCardStyle implements CardStyler {
  @override
  Color get backgroundColor => Colors.white;

  @override
  double get elevation => 1.0;

  @override
  BorderRadius get borderRadius => BorderRadius.circular(8);

  @override
  EdgeInsets get contentPadding => const EdgeInsets.all(12);

  @override
  Widget wrapContent(Widget content) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: borderRadius,
      ),
      child: content,
    );
  }
}

class ElevatedCardStyle implements CardStyler {
  @override
  Color get backgroundColor => Colors.white;

  @override
  double get elevation => 4.0;

  @override
  BorderRadius get borderRadius => BorderRadius.circular(16);

  @override
  EdgeInsets get contentPadding => const EdgeInsets.all(20);

  @override
  Widget wrapContent(Widget content) => content;
}

class CustomCard extends StatelessWidget {
  final Widget content;
  final CardStyler styler;
  final VoidCallback? onPressed;

  const CustomCard({
    Key? key,
    required this.content,
    CardStyler? styler,
    this.onPressed,
  })  : styler = styler ?? const MinimalCardStyle(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: styler.backgroundColor,
      elevation: styler.elevation,
      borderRadius: styler.borderRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: styler.borderRadius,
        child: styler.wrapContent(
          Padding(
            padding: styler.contentPadding,
            child: content,
          ),
        ),
      ),
    );
  }
}
