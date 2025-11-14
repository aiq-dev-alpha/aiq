import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Edit your profile information',
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.account_circle,
                  title: 'Account Settings',
                  subtitle: 'Email, password, and security',
                  onTap: () => Navigator.pushNamed(context, '/account-settings'),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.shield,
                  title: 'Privacy Settings',
                  subtitle: 'Control your privacy and data',
                  onTap: () => Navigator.pushNamed(context, '/privacy-settings'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Preferences Section
          _buildSectionHeader('Preferences'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Push notifications, email alerts',
                  onTap: () => Navigator.pushNamed(context, '/notification-settings'),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.palette,
                  title: 'Theme',
                  subtitle: 'Light, dark, or system theme',
                  onTap: () => Navigator.pushNamed(context, '/theme-settings'),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'Choose your preferred language',
                  onTap: () => Navigator.pushNamed(context, '/language-settings'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // App Section
          _buildSectionHeader('App'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.storage,
                  title: 'Storage',
                  subtitle: 'Manage app data and cache',
                  onTap: () => _showStorageDialog(context),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.download,
                  title: 'Downloads',
                  subtitle: 'Manage downloaded content',
                  onTap: () => _showComingSoonSnackBar(context),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.backup,
                  title: 'Backup & Sync',
                  subtitle: 'Sync your data across devices',
                  onTap: () => _showComingSoonSnackBar(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Support Section
          _buildSectionHeader('Support'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.help,
                  title: 'Help & Support',
                  subtitle: 'FAQ, contact us, troubleshooting',
                  onTap: () => Navigator.pushNamed(context, '/help-support'),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.feedback,
                  title: 'Send Feedback',
                  subtitle: 'Help us improve the app',
                  onTap: () => _showFeedbackDialog(context),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.star_rate,
                  title: 'Rate App',
                  subtitle: 'Rate us on the App Store',
                  onTap: () => _showRateAppDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('About'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.info,
                  title: 'About',
                  subtitle: 'Version, terms, privacy policy',
                  onTap: () => Navigator.pushNamed(context, '/about'),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.update,
                  title: 'Check for Updates',
                  subtitle: 'Version 1.0.0 (Latest)',
                  onTap: () => _checkForUpdates(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Logout Button
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () => _showLogoutDialog(context),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showStorageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Usage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStorageItem('App Data', '24 MB'),
            _buildStorageItem('Cache', '156 MB'),
            _buildStorageItem('Downloads', '2.1 GB'),
            const Divider(),
            _buildStorageItem('Total', '2.28 GB', isTotal: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(String label, String size, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            size,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Help us improve by sharing your thoughts and suggestions.'),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showRateAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Our App'),
        content: const Text('If you enjoy using our app, would you mind taking a moment to rate it?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for rating our app!')),
              );
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You are using the latest version'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!')),
    );
  }
}