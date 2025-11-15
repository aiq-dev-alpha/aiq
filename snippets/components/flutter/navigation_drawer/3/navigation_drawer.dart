import 'package:flutter/material.dart';

class CustomNavigation extends StatefulWidget {
  final Widget? header;
  final List<DrawerMenuItem> items;
  final int selectedIndex;
  final Function(int)? onItemSelected;
  final Color? backgroundColor;

  const CustomNavigation({
    Key? key,
    this.header,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.backgroundColor,
  }) : super(key: key);
  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class DrawerMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;

  const DrawerMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
  });
}

class _CustomNavigationState extends State<CustomNavigation> with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )..forward();
  }
  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? Colors.grey.shade50;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      )),
      child: Container(
        width: 300,
        color: bgColor,
        child: Column(
          children: [
            if (widget.header != null)
              widget.header!
            else
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.menu, size: 48, color: Colors.white),
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = index == widget.selectedIndex;

                  return InkWell(
                    onTap: () => widget.onItemSelected?.call(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade700,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade900,
                                  ),
                                ),
                                if (item.subtitle != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    item.subtitle!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
