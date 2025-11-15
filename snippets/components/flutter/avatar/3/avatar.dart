import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showBadge;
  final Color? badgeColor;

  const CustomAvatar({
    Key? key,
    this.imageUrl,
    this.initials,
    this.size = 48,
    this.backgroundColor,
    this.onTap,
    this.showBadge = false,
    this.badgeColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.2),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: imageUrl == null && initials != null
                ? Center(
                    child: Text(
                      initials!,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: size * 0.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : imageUrl == null
                    ? Icon(
                        Icons.person,
                        size: size * 0.6,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
          ),
          if (showBadge)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
