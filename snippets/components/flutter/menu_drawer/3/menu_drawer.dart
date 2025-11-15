import 'package:flutter/material.dart';

class CustomNavigation extends StatefulWidget {
  final List<MenuSection> sections;
  final Color? backgroundColor;
  final Widget? footer;

  const CustomNavigation({
    Key? key,
    required this.sections,
    this.backgroundColor,
    this.footer,
  }) : super(key: key);
  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class MenuSection {
  final String? title;
  final List<MenuItem> items;

  const MenuSection({
    this.title,
    required this.items,
  });
}

class MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class _CustomNavigationState extends State<CustomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.sections.length,
              itemBuilder: (context, sectionIndex) {
                final section = widget.sections[sectionIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (section.title != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8, top: 16),
                        child: Text(
                          section.title!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                    ...section.items.map((item) {
                      return InkWell(
                        onTap: item.onTap,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                size: 20,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }
}
