import 'package:flutter/material.dart';

class CustomNavigation extends StatefulWidget {
  final List<NavBarItem> items;
  final int selectedIndex;
  final Function(int)? onItemTapped;
  final Color? backgroundColor;
  final Color? selectedColor;

  const CustomNavigation({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemTapped,
    this.backgroundColor,
    this.selectedColor,
  }) : super(key: key);

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class NavBarItem {
  final IconData icon;
  final String label;

  const NavBarItem({
    required this.icon,
    required this.label,
  });
}

class _CustomNavigationState extends State<CustomNavigation> {
  @override
  Widget build(BuildContext context) {
    final selectedColor = widget.selectedColor ?? Theme.of(context).primaryColor;

    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          final isSelected = index == widget.selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onItemTapped?.call(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.icon,
                      color: isSelected ? selectedColor : Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? selectedColor : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
