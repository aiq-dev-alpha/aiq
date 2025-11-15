import 'package:flutter/material.dart';

class TabsConfig {
  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;
  final double indicatorHeight;
  final bool isScrollable;

  const TabsConfig({
    this.selectedColor = const Color(0xFF6200EE),
    this.unselectedColor = Colors.black54,
    this.indicatorColor = const Color(0xFF6200EE),
    this.indicatorHeight = 3.0,
    this.isScrollable = false,
  });
}

class CustomTabs extends StatelessWidget {
  final List<TabItem> tabs;
  final List<Widget> children;
  final TabsConfig? config;

  const CustomTabs({
    Key? key,
    required this.tabs,
    required this.children,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const TabsConfig();

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: effectiveConfig.isScrollable,
            labelColor: effectiveConfig.selectedColor,
            unselectedLabelColor: effectiveConfig.unselectedColor,
            indicatorColor: effectiveConfig.indicatorColor,
            indicatorWeight: effectiveConfig.indicatorHeight,
            tabs: tabs.map((tab) => Tab(
              icon: tab.icon != null ? Icon(tab.icon) : null,
              text: tab.label,
            )).toList(),
          ),
          Expanded(
            child: TabBarView(children: children),
          ),
        ],
      ),
    );
  }
}

class TabItem {
  final String label;
  final IconData? icon;

  TabItem({required this.label, this.icon});
}
