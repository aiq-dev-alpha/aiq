import 'package:flutter/material.dart';

class BarComponent extends StatefulWidget {
  final List<String> tabs;
  final int initialTab;
  final Function(int)? onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const BarComponent({
    Key? key,
    required this.tabs,
    this.initialTab = 0,
    this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);
  @override
  State<BarComponent> createState() => _BarComponentState();
}

class _BarComponentState extends State<BarComponent> with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    if (index == _selectedIndex) return;

    final oldIndex = _selectedIndex;
    setState(() => _selectedIndex = index);

    _slideAnimation = Tween<double>(
      begin: oldIndex.toDouble(),
      end: index.toDouble(),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward(from: 0);
    widget.onTabChanged?.call(index);
  }
  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final inactiveColor = widget.inactiveColor ?? Colors.grey.shade600;
    final tabCount = widget.tabs.length;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated indicator
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                left: (_slideAnimation.value / tabCount) * MediaQuery.of(context).size.width,
                top: 4,
                bottom: 4,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 8) / tabCount,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Tabs
          Row(
            children: List.generate(tabCount, (index) {
              final isSelected = index == _selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: isSelected ? Colors.white : inactiveColor,
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      child: Text(widget.tabs[index]),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
