import 'package:flutter/material.dart';

class BarComponent extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final List<Widget>? actions;
  final Widget? leading;
  final double height;
  
  const BarComponent({
    Key? key,
    this.backgroundColor = const Color(0xFF6200EE),
    this.foregroundColor = Colors.white,
    this.actions,
    this.leading,
    this.height = 56.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: backgroundColor,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 16),
          ],
          const Expanded(
            child: Text(
              'Bar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
