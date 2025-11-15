import 'package:flutter/material.dart';

class AvatarConfig {
  final double size;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final bool showBorder;

  const AvatarConfig({
    this.size = 48.0,
    this.backgroundColor = const Color(0xFF6200EE),
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
    this.showBorder = false,
  });
}

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final IconData? icon;
  final AvatarConfig? config;
  final VoidCallback? onTap;

  const CustomAvatar({
    Key? key,
    this.imageUrl,
    this.initials,
    this.icon,
    this.config,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const AvatarConfig();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: effectiveConfig.size,
        height: effectiveConfig.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: effectiveConfig.showBorder
              ? Border.all(
                  color: effectiveConfig.borderColor,
                  width: effectiveConfig.borderWidth,
                )
              : null,
        ),
        child: CircleAvatar(
          radius: effectiveConfig.size / 2,
          backgroundColor: effectiveConfig.backgroundColor,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null ? _buildFallback(effectiveConfig) : null,
        ),
      ),
    );
  }

  Widget _buildFallback(AvatarConfig config) {
    if (initials != null) {
      return Text(
        initials!,
        style: TextStyle(
          color: Colors.white,
          fontSize: config.size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Icon(
      icon ?? Icons.person,
      color: Colors.white,
      size: config.size * 0.5,
    );
  }
}
