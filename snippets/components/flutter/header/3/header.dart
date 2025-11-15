import 'package:flutter/material.dart';

class CustomNavigation extends StatelessWidget {
  final String title;
  final List<NavItem>? navItems;
  final Widget? trailing;
  final Color? backgroundColor;
  final double height;

  const CustomNavigation({
    Key? key,
    required this.title,
    this.navItems,
    this.trailing,
    this.backgroundColor,
    this.height = 72,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (navItems != null)
              ...navItems!.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: InkWell(
                    onTap: item.onTap,
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: item.isActive
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            if (trailing != null) ...[
              const SizedBox(width: 24),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const NavItem({
    required this.label,
    this.onTap,
    this.isActive = false,
  });
}
