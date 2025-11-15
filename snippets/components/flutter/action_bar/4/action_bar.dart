import 'package:flutter/material.dart';

class BarComponent extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const BarComponent({
  Key? key,
  this.child,
  this.onTap,
  this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return GestureDetector(
  onTap: onTap,
  child: Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.12),
  borderRadius: BorderRadius.circular(8),
  ),
  child: child ?? const Text('Component'),
  ),
  );
  }
}
