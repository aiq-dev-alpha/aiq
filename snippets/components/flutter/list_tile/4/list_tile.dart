import 'package:flutter/material.dart';

class ListTileConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color subtitleColor;
  final double height;
  final EdgeInsets padding;

  const ListTileConfig({
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.subtitleColor = Colors.black54,
    this.height = 72.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });
}

class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final ListTileConfig? config;

  const CustomListTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const ListTileConfig();

    return InkWell(
      onTap: onTap,
      child: Container(
        height: effectiveConfig.height,
        color: effectiveConfig.backgroundColor,
        padding: effectiveConfig.padding,
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: effectiveConfig.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: effectiveConfig.subtitleColor,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 16),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
