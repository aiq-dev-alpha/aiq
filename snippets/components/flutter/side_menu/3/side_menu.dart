import 'package:flutter/material.dart';

class CustomNavigation extends StatefulWidget {
  final List<SideMenuItem> items;
  final int selectedIndex;
  final Function(int)? onItemSelected;
  final bool isCollapsed;
  final Color? backgroundColor;

  const CustomNavigation({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.isCollapsed = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class SideMenuItem {
  final IconData icon;
  final String label;
  final int? badgeCount;

  const SideMenuItem({
    required this.icon,
    required this.label,
    this.badgeCount,
  });
}

class _CustomNavigationState extends State<CustomNavigation> with SingleTickerProviderStateMixin {
  late AnimationController _widthController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _widthController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _updateAnimation();
    if (widget.isCollapsed) {
      _widthController.value = 1;
    }
  }

  void _updateAnimation() {
    _widthAnimation = Tween<double>(
      begin: 240,
      end: 72,
    ).animate(CurvedAnimation(
      parent: _widthController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(CustomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsed != oldWidget.isCollapsed) {
      if (widget.isCollapsed) {
        _widthController.forward();
      } else {
        _widthController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? Colors.grey.shade100;
    final selectedColor = Theme.of(context).primaryColor;

    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        final isCollapsed = _widthAnimation.value < 150;

        return Container(
          width: _widthAnimation.value,
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final isSelected = index == widget.selectedIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: InkWell(
                  onTap: () => widget.onItemSelected?.call(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor.withOpacity(0.1) : null,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: selectedColor, width: 1.5)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? selectedColor : Colors.grey.shade700,
                          size: 22,
                        ),
                        if (!isCollapsed) ...[
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? selectedColor : Colors.grey.shade800,
                              ),
                            ),
                          ),
                          if (item.badgeCount != null && item.badgeCount! > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${item.badgeCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
