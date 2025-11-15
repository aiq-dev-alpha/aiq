import 'package:flutter/material.dart';

class ActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool isPrimary;

  ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.isPrimary = false,
  });
}

class CustomActionBar extends StatefulWidget {
  final List<ActionItem> actions;
  final String? title;
  final Color? backgroundColor;
  final Color? primaryColor;
  final bool showLabels;
  final bool elevated;

  const CustomActionBar({
    Key? key,
    required this.actions,
    this.title,
    this.backgroundColor,
    this.primaryColor,
    this.showLabels = true,
    this.elevated = true,
  }) : super(key: key);

  @override
  State<CustomActionBar> createState() => _CustomActionBarState();
}

class _CustomActionBarState extends State<CustomActionBar> with SingleTickerProviderStateMixin {
  int? _hoveredIndex;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.primaryColor;
    final bgColor = widget.backgroundColor ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: widget.elevated
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: primaryColor.withOpacity(0.2), height: 1),
              const SizedBox(height: 16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                widget.actions.length,
                (index) => _buildActionButton(
                  widget.actions[index],
                  index,
                  primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(ActionItem action, int index, Color primaryColor) {
    final isHovered = _hoveredIndex == index;
    final buttonColor = action.color ?? (action.isPrimary ? primaryColor : Colors.grey.shade600);

    return Expanded(
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _hoveredIndex = index);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _hoveredIndex = null);
          _controller.reverse();
        },
        child: GestureDetector(
          onTap: action.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            transform: Matrix4.identity()
              ..scale(isHovered ? 1.05 : 1.0)
              ..translate(0.0, isHovered ? -4.0 : 0.0, 0.0),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              gradient: action.isPrimary
                  ? LinearGradient(
                      colors: [buttonColor, buttonColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: action.isPrimary ? null : (isHovered ? buttonColor.withOpacity(0.1) : Colors.transparent),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: buttonColor.withOpacity(isHovered ? 0.6 : 0.3),
                width: isHovered ? 2 : 1,
              ),
              boxShadow: action.isPrimary && isHovered
                  ? [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  action.icon,
                  color: action.isPrimary ? Colors.white : buttonColor,
                  size: 28,
                ),
                if (widget.showLabels) ...[
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
                      color: action.isPrimary ? Colors.white : buttonColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
