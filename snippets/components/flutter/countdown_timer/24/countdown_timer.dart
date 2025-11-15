import 'package:flutter/material.dart';

class CustomComponent extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  
  const CustomComponent({
    Key? key,
    required this.text,
    this.backgroundColor = const Color(0xFF2196F3),
    this.textColor = Colors.white,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 16),
            const SizedBox(width: 4),
          ],
          Text(text, style: TextStyle(color: textColor, fontSize: 13)),
        ],
      ),
    );
  }
}
