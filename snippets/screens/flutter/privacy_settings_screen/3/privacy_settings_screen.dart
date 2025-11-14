import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  // Profile Privacy
  bool _publicProfile = true;
  bool _showEmail = false;
  bool _showPhone = false;
  bool _showLastSeen = true;
  String _whoCanMessage = 'Everyone';
  String _whoCanFollow = 'Everyone';

  // Data Collection
  bool _personalizedAds = true;
  bool _analyticsData = true;
  bool _crashReports = true;
  bool _locationData = false;

  // Activity Privacy
  bool _showOnlineStatus = true;
  bool _readReceipts = true;
  bool _shareActivity = false;

  // Content Privacy
  String _defaultPostPrivacy = 'Public';
  bool _tagApproval = false;
  bool _hideFromSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Privacy Section
          _buildSectionHeader('Profile Privacy'),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.public,
                  title: 'Public Profile',
                  subtitle: 'Anyone can view your profile',
                  value: _publicProfile,
                  onChanged: (value) {
                    setState(() {
                      _publicProfile = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.email,
                  title: 'Show Email Address',
                  subtitle: 'Display email on your profile',
                  value: _showEmail,
                  onChanged: (value) {
                    setState(() {
                      _showEmail = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.phone,
                  title: 'Show Phone Number',
                  subtitle: 'Display phone on your profile',
                  value: _showPhone,
                  onChanged: (value) {
                    setState(() {
                      _showPhone = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.access_time,
                  title: 'Show Last Seen',
                  subtitle: 'Others can see when you were last active',
                  value: _showLastSeen,
                  onChanged: (value) {
                    setState(() {
                      _showLastSeen = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Contact Permissions Section
          _buildSectionHeader('Contact Permissions'),
          Card(
            child: Column(
              children: [
                _buildDropdownTile(
                  icon: Icons.message,
                  title: 'Who can message you',
                  value: _whoCanMessage,
                  options: ['Everyone', 'Friends only', 'No one'],
                  onChanged: (value) {
                    setState(() {
                      _whoCanMessage = value!;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildDropdownTile(
                  icon: Icons.person_add,
                  title: 'Who can follow you',
                  value: _whoCanFollow,
                  options: ['Everyone', 'Friends of friends', 'No one'],
                  onChanged: (value) {
                    setState(() {
                      _whoCanFollow = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data Collection Section
          _buildSectionHeader('Data Collection & Usage'),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.ads_click,
                  title: 'Personalized Ads',
                  subtitle: 'Use your data to show relevant ads',
                  value: _personalizedAds,
                  onChanged: (value) {
                    setState(() {
                      _personalizedAds = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.analytics,
                  title: 'Analytics Data',
                  subtitle: 'Help improve the app with usage data',
                  value: _analyticsData,
                  onChanged: (value) {
                    setState(() {
                      _analyticsData = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.bug_report,
                  title: 'Crash Reports',
                  subtitle: 'Send crash reports to help fix issues',
                  value: _crashReports,
                  onChanged: (value) {
                    setState(() {
                      _crashReports = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.location_on,
                  title: 'Location Data',
                  subtitle: 'Allow location tracking for features',
                  value: _locationData,
                  onChanged: (value) {
                    setState(() {
                      _locationData = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Activity Privacy Section
          _buildSectionHeader('Activity Privacy'),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.circle,
                  title: 'Show Online Status',
                  subtitle: 'Others can see when you\'re online',
                  value: _showOnlineStatus,
                  onChanged: (value) {
                    setState(() {
                      _showOnlineStatus = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.done_all,
                  title: 'Read Receipts',
                  subtitle: 'Others can see if you\'ve read their messages',
                  value: _readReceipts,
                  onChanged: (value) {
                    setState(() {
                      _readReceipts = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.share,
                  title: 'Share Activity',
                  subtitle: 'Share your activity with friends',
                  value: _shareActivity,
                  onChanged: (value) {
                    setState(() {
                      _shareActivity = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Content Privacy Section
          _buildSectionHeader('Content Privacy'),
          Card(
            child: Column(
              children: [
                _buildDropdownTile(
                  icon: Icons.post_add,
                  title: 'Default Post Privacy',
                  value: _defaultPostPrivacy,
                  options: ['Public', 'Friends only', 'Private'],
                  onChanged: (value) {
                    setState(() {
                      _defaultPostPrivacy = value!;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.local_offer,
                  title: 'Tag Approval',
                  subtitle: 'Approve tags before they appear on your profile',
                  value: _tagApproval,
                  onChanged: (value) {
                    setState(() {
                      _tagApproval = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.search_off,
                  title: 'Hide from Search',
                  subtitle: 'Don\'t appear in search results',
                  value: _hideFromSearch,
                  onChanged: (value) {
                    setState(() {
                      _hideFromSearch = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Advanced Privacy Section
          _buildSectionHeader('Advanced Privacy'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.block,
                  title: 'Blocked Users',
                  subtitle: 'Manage your blocked users list',
                  onTap: () => _showBlockedUsersDialog(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.report,
                  title: 'Content Filtering',
                  subtitle: 'Filter inappropriate content',
                  onTap: () => _showContentFilterDialog(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.history,
                  title: 'Data Download',
                  subtitle: 'Download a copy of your data',
                  onTap: () => _showDataDownloadDialog(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.delete_forever,
                  title: 'Clear Data',
                  subtitle: 'Clear cached data and history',
                  onTap: () => _showClearDataDialog(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Legal Section
          _buildSectionHeader('Legal & Policies'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () => _openPrivacyPolicy(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.gavel,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms of service',
                  onTap: () => _openTermsOfService(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.cookie,
                  title: 'Cookie Policy',
                  subtitle: 'Learn about our cookie usage',
                  onTap: () => _openCookiePolicy(),
                ),
              ],
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, size: 24),
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
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title),
      subtitle: Text(value),
      trailing: DropdownButton<String>(
        value: value,
        underline: Container(),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _showBlockedUsersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Blocked Users'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Currently blocked users:'),
            const SizedBox(height: 16),
            _buildBlockedUserItem('@spammer123', 'Blocked 2 days ago'),
            _buildBlockedUserItem('@trolluser', 'Blocked 1 week ago'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedUserItem(String username, String blockedDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  blockedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$username unblocked')),
              );
            },
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }

  void _showContentFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Content Filtering'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Hide explicit content'),
              value: true,
              onChanged: (value) {},
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Filter profanity'),
              value: false,
              onChanged: (value) {},
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Hide sensitive topics'),
              value: false,
              onChanged: (value) {},
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
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
                const SnackBar(content: Text('Content filters updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDataDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Your Data'),
        content: const Text(
          'We will prepare a copy of your data and send a download link to your email address. '
          'This may take up to 24 hours to complete.',
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
                const SnackBar(content: Text('Data download request submitted')),
              );
            },
            child: const Text('Request Download'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Data'),
        content: const Text(
          'This will clear your cached data, search history, and temporary files. '
          'Your account and posts will not be affected.',
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
                const SnackBar(content: Text('Data cleared successfully')),
              );
            },
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Privacy Policy...')),
    );
    // In a real app, open URL or navigate to privacy policy screen
  }

  void _openTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Terms of Service...')),
    );
    // In a real app, open URL or navigate to terms screen
  }

  void _openCookiePolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Cookie Policy...')),
    );
    // In a real app, open URL or navigate to cookie policy screen
  }
}