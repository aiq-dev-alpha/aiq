import 'package:flutter/material.dart';

class CustomSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? description;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final String? backgroundImage;
  final bool darkMode;

  const CustomSection({
    Key? key,
    required this.title,
    required this.subtitle,
    this.description,
    this.primaryAction,
    this.secondaryAction,
    this.backgroundImage,
    this.darkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 500),
      decoration: BoxDecoration(
        image: backgroundImage != null
            ? DecorationImage(
                image: NetworkImage(backgroundImage!),
                fit: BoxFit.cover,
              )
            : null,
        gradient: backgroundImage == null
            ? LinearGradient(
                colors: darkMode
                    ? [Colors.grey.shade900, Colors.grey.shade800]
                    : [Colors.white, Colors.grey.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
      ),
      child: Container(
        decoration: backgroundImage != null
            ? BoxDecoration(
                color: Colors.black.withOpacity(darkMode ? 0.6 : 0.3),
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: darkMode ? Colors.white70 : Theme.of(context).primaryColor,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: darkMode ? Colors.white : Colors.grey.shade900,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  description!,
                  style: TextStyle(
                    fontSize: 18,
                    color: darkMode ? Colors.white.withOpacity(0.9) : Colors.grey.shade700,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (primaryAction != null) primaryAction!,
                if (primaryAction != null && secondaryAction != null)
                  const SizedBox(width: 16),
                if (secondaryAction != null) secondaryAction!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
