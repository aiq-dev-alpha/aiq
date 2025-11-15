import 'package:flutter/material.dart';

class SettingsThemeConfig {
  final Color backgroundColor;
  final Color cardColor;
  final Color iconColor;
  final Color textColor;
  final double itemHeight;
  final double sectionSpacing;

  const SettingsThemeConfig({
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.cardColor = Colors.white,
    this.iconColor = const Color(0xFF6200EE),
    this.textColor = Colors.black87,
    this.itemHeight = 56.0,
    this.sectionSpacing = 16.0,
  });
}

class SettingsScreen extends StatelessWidget {
  final SettingsThemeConfig? themeConfig;
  final List<SettingsSection>? sections;

  const SettingsScreen({
    Key? key,
    this.themeConfig,
    this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = themeConfig ?? const SettingsThemeConfig();
    final settingsSections = sections ?? _defaultSections();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(theme.sectionSpacing),
        itemCount: settingsSections.length,
        separatorBuilder: (_, __) => SizedBox(height: theme.sectionSpacing),
        itemBuilder: (context, index) => _SettingsSectionWidget(
          section: settingsSections[index],
          theme: theme,
        ),
      ),
    );
  }

  List<SettingsSection> _defaultSections() {
    return [
      SettingsSection(
        title: 'Account',
        items: [
          SettingsItem(icon: Icons.person, title: 'Profile', onTap: () {}),
          SettingsItem(icon: Icons.security, title: 'Privacy', onTap: () {}),
          SettingsItem(icon: Icons.lock, title: 'Security', onTap: () {}),
        ],
      ),
      SettingsSection(
        title: 'Preferences',
        items: [
          SettingsItem(icon: Icons.notifications, title: 'Notifications', onTap: () {}),
          SettingsItem(icon: Icons.language, title: 'Language', onTap: () {}),
          SettingsItem(icon: Icons.palette, title: 'Theme', onTap: () {}),
        ],
      ),
      SettingsSection(
        title: 'Other',
        items: [
          SettingsItem(icon: Icons.help, title: 'Help & Support', onTap: () {}),
          SettingsItem(icon: Icons.info, title: 'About', onTap: () {}),
          SettingsItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {},
            isDanger: true,
          ),
        ],
      ),
    ];
  }
}

class _SettingsSectionWidget extends StatelessWidget {
  final SettingsSection section;
  final SettingsThemeConfig theme;

  const _SettingsSectionWidget({
    required this.section,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              section.title!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.textColor.withOpacity(0.6),
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: section.items
                .asMap()
                .entries
                .map((entry) => _SettingsItemWidget(
                      item: entry.value,
                      theme: theme,
                      isLast: entry.key == section.items.length - 1,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItemWidget extends StatelessWidget {
  final SettingsItem item;
  final SettingsThemeConfig theme;
  final bool isLast;

  const _SettingsItemWidget({
    required this.item,
    required this.theme,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = item.isDanger ? Colors.red : theme.iconColor;

    return InkWell(
      onTap: item.onTap,
      child: Container(
        height: theme.itemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            Icon(item.icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 16,
                  color: item.isDanger ? Colors.red : theme.textColor,
                ),
              ),
            ),
            if (item.trailing != null)
              item.trailing!
            else
              Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

class SettingsSection {
  final String? title;
  final List<SettingsItem> items;

  SettingsSection({this.title, required this.items});
}

class SettingsItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDanger;

  SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.isDanger = false,
  });
}
