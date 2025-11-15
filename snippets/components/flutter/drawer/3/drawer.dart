import 'package:flutter/material.dart';

class CustomNavigation extends StatefulWidget {
  final List<DrawerItem> items;
  final int selectedIndex;
  final Function(int)? onItemSelected;
  final Color? backgroundColor;
  final Color? selectedColor;

  const CustomNavigation({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.backgroundColor,
    this.selectedColor,
  }) : super(key: key);

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class DrawerItem {
  final IconData icon;
  final String label;
  final int? badgeCount;

  const DrawerItem({
    required this.icon,
    required this.label,
    this.badgeCount,
  });
}

class _CustomNavigationState extends State<CustomNavigation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
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
    final selectedColor = widget.selectedColor ?? Theme.of(context).primaryColor;
    final bgColor = widget.backgroundColor ?? Colors.white;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [selectedColor, selectedColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 32),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'user@example.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = index == widget.selectedIndex;
                final isHovered = index == _hoveredIndex;

                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = -1),
                  child: GestureDetector(
                    onTap: () => widget.onItemSelected?.call(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColor.withOpacity(0.12)
                            : isHovered
                                ? Colors.grey.shade100
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? selectedColor : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? selectedColor : Colors.grey.shade700,
                            size: 22,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item.label,
                              style: TextStyle(
                                color: isSelected ? selectedColor : Colors.grey.shade800,
                                fontSize: 15,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (item.badgeCount != null && item.badgeCount! > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${item.badgeCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
