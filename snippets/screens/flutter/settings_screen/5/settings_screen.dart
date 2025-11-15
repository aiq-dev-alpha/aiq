import 'package:flutter/material.dart';

abstract class SettingsStyler {
  Color get backgroundColor;
  Color get itemBackground;
  Color get primaryColor;
  TextStyle get sectionHeaderStyle;
  TextStyle get itemTitleStyle;
  Widget buildItem(SettingOption option, VoidCallback onTap);
}

class MinimalSettingsStyle implements SettingsStyler {
  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get itemBackground => const Color(0xFFF8F9FA);

  @override
  Color get primaryColor => const Color(0xFF1A73E8);

  @override
  TextStyle get sectionHeaderStyle => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
        letterSpacing: 0.5,
      );

  @override
  TextStyle get itemTitleStyle => const TextStyle(
        fontSize: 15,
        color: Colors.black87,
      );

  @override
  Widget buildItem(SettingOption option, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: itemBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(option.icon, color: primaryColor, size: 22),
        title: Text(option.label, style: itemTitleStyle),
        subtitle: option.subtitle != null ? Text(option.subtitle!) : null,
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final SettingsStyler styler;
  final List<SettingGroup> groups;

  const SettingsScreen({
    Key? key,
    SettingsStyler? styler,
    List<SettingGroup>? groups,
  })  : styler = styler ?? const MinimalSettingsStyle(),
        groups = groups ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingGroups = groups.isEmpty ? _defaultGroups() : groups;

    return Scaffold(
      backgroundColor: styler.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: styler.backgroundColor,
        foregroundColor: Colors.black87,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: settingGroups.length,
        itemBuilder: (context, index) => _buildGroup(settingGroups[index]),
      ),
    );
  }

  Widget _buildGroup(SettingGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            group.header.toUpperCase(),
            style: styler.sectionHeaderStyle,
          ),
        ),
        ...group.options.map(
          (option) => styler.buildItem(option, option.onTap ?? () {}),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  List<SettingGroup> _defaultGroups() {
    return [
      SettingGroup(
        header: 'Account',
        options: [
          SettingOption(
            icon: Icons.person_outline,
            label: 'Edit Profile',
            subtitle: 'Update your personal information',
          ),
          SettingOption(
            icon: Icons.verified_user_outlined,
            label: 'Account Security',
            subtitle: 'Manage passwords and 2FA',
          ),
        ],
      ),
      SettingGroup(
        header: 'App Settings',
        options: [
          SettingOption(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
          ),
          SettingOption(
            icon: Icons.dark_mode_outlined,
            label: 'Appearance',
          ),
          SettingOption(
            icon: Icons.language_outlined,
            label: 'Language',
          ),
        ],
      ),
      SettingGroup(
        header: 'Support',
        options: [
          SettingOption(
            icon: Icons.help_outline,
            label: 'Help Center',
          ),
          SettingOption(
            icon: Icons.feedback_outlined,
            label: 'Send Feedback',
          ),
        ],
      ),
    ];
  }
}

class SettingGroup {
  final String header;
  final List<SettingOption> options;

  const SettingGroup({
    required this.header,
    required this.options,
  });
}

class SettingOption {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  const SettingOption({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
  });
}
