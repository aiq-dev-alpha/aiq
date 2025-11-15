import 'package:flutter/material.dart';

class CustomTabs extends StatefulWidget {
  final List<TabItem> tabs;
  final int initialIndex;
  final Function(int)? onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomTabs({
    Key? key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class TabItem {
  final String label;
  final IconData? icon;
  final Widget content;

  const TabItem({
    required this.label,
    this.icon,
    required this.content,
  });
}

class _CustomTabsState extends State<CustomTabs> with TickerProviderStateMixin {
  late int _selectedIndex;
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _controller.addListener(() {
      if (_controller.indexIsChanging) {
        setState(() {
          _selectedIndex = _controller.index;
        });
        widget.onTabChanged?.call(_controller.index);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final inactiveColor = widget.inactiveColor ?? Colors.grey.shade600;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 2,
              ),
            ),
          ),
          child: TabBar(
            controller: _controller,
            isScrollable: true,
            labelColor: activeColor,
            unselectedLabelColor: inactiveColor,
            indicatorColor: activeColor,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            tabs: widget.tabs.map((tab) {
              return Tab(
                icon: tab.icon != null ? Icon(tab.icon) : null,
                text: tab.label,
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }
}
