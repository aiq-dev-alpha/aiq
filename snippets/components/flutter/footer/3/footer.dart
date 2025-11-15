import 'package:flutter/material.dart';

class CustomNavigation extends StatelessWidget {
  final List<FooterSection> sections;
  final String? copyrightText;
  final List<SocialLink>? socialLinks;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomNavigation({
    Key? key,
    required this.sections,
    this.copyrightText,
    this.socialLinks,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.grey.shade900;
    final txtColor = textColor ?? Colors.white;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Wrap(
              spacing: 48,
              runSpacing: 32,
              children: sections.map((section) {
                return SizedBox(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: TextStyle(
                          color: txtColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...section.links.map((link) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: link.onTap,
                            child: Text(
                              link.label,
                              style: TextStyle(
                                color: txtColor.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  copyrightText ?? '© 2025 Company Name. All rights reserved.',
                  style: TextStyle(
                    color: txtColor.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
                if (socialLinks != null)
                  Row(
                    children: socialLinks!.map((social) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: InkWell(
                          onTap: social.onTap,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              social.icon,
                              color: txtColor,
                              size: 18,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterSection {
  final String title;
  final List<FooterLink> links;

  const FooterSection({
    required this.title,
    required this.links,
  });
}

class FooterLink {
  final String label;
  final VoidCallback? onTap;

  const FooterLink({
    required this.label,
    this.onTap,
  });
}

class SocialLink {
  final IconData icon;
  final VoidCallback? onTap;

  const SocialLink({
    required this.icon,
    this.onTap,
  });
}
