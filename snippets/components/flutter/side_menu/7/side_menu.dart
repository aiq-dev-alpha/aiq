import 'package:flutter/material.dart';

class CustomNavigation extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final List<NavigationItem> items;
  
  const CustomNavigation({
    Key? key,
    this.backgroundColor = const Color(0xFF6200EE),
    this.textColor = Colors.white,
    this.items = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navItems = items.isEmpty
        ? [
            NavigationItem(icon: Icons.home, label: 'Home'),
            NavigationItem(icon: Icons.search, label: 'Search'),
            NavigationItem(icon: Icons.person, label: 'Profile'),
          ]
        : items;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: navItems.map((item) => ListTile(
            leading: Icon(item.icon, color: textColor),
            title: Text(item.label, style: TextStyle(color: textColor)),
            onTap: item.onTap,
          )).toList(),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  NavigationItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}
