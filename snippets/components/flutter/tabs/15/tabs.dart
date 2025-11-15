import 'package:flutter/material.dart';

class CustomTabs extends StatelessWidget {
  final List<String> tabs;
  final List<Widget> children;
  final Color selectedColor;
  
  const CustomTabs({
    Key? key,
    required this.tabs,
    required this.children,
    this.selectedColor = const Color(0xFF6200EE),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            labelColor: selectedColor,
            tabs: tabs.map((t) => Tab(text: t)).toList(),
          ),
          Expanded(
            child: TabBarView(children: children),
          ),
        ],
      ),
    );
  }
}
