import 'package:flutter/material.dart';

class CustomChip extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool selected;
  final Color? backgroundColor;
  final Color? selectedColor;

  const CustomChip({
    Key? key,
    required this.label,
    this.icon,
    this.onTap,
    this.onDelete,
    this.selected = false,
    this.backgroundColor,
    this.selectedColor,
  }) : super(key: key);
  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.selected
        ? (widget.selectedColor ?? Theme.of(context).primaryColor)
        : (widget.backgroundColor ?? Colors.grey.shade200);
    final textColor = widget.selected ? Colors.white : Colors.grey.shade800;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.onDelete != null ? 12 : 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: bgColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 18,
                  color: textColor,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              if (widget.onDelete != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: widget.onDelete,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
