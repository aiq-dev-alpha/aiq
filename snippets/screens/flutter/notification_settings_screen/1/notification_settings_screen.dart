import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Push Notification Settings
  bool _pushNotificationsEnabled = true;
  bool _messagesNotifications = true;
  bool _followNotifications = true;
  bool _likeNotifications = false;
  bool _commentNotifications = true;
  bool _mentionNotifications = true;
  bool _systemNotifications = true;

  // Email Notification Settings
  bool _emailNotificationsEnabled = true;
  bool _weeklyDigest = true;
  bool _promotionalEmails = false;
  bool _securityEmails = true;

  // Sound and Vibration
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _selectedSound = 'Default';

  // Quiet Hours
  bool _quietHoursEnabled = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Push Notifications Section
          _buildSectionHeader('Push Notifications'),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications,
                  title: 'Enable Push Notifications',
                  subtitle: 'Receive notifications on this device',
                  value: _pushNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _pushNotificationsEnabled = value;
                    });
                  },
                ),
                if (_pushNotificationsEnabled) ...[
                  const Divider(height: 1),
                  _buildSwitchTile(
                    icon: Icons.message,
                    title: 'Messages',
                    subtitle: 'New direct messages',
                    value: _messagesNotifications,
                    onChanged: (value) {
                      setState(() {
                        _messagesNotifications = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    icon: Icons.person_add,
                    title: 'New Followers',
                    subtitle: 'When someone follows you',
                    value: _followNotifications,
                    onChanged: (value) {
                      setState(() {
                        _followNotifications = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    icon: Icons.favorite,
                    title: 'Likes',
                    subtitle: 'When someone likes your posts',
                    value: _likeNotifications,
                    onChanged: (value) {
                      setState(() {
                        _likeNotifications = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    icon: Icons.comment,
                    title: 'Comments',
                    subtitle: 'Comments on your posts',
                    value: _commentNotifications,
                    onChanged: (value) {
                      setState(() {
                        _commentNotifications = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    icon: Icons.alternate_email,
                    title: 'Mentions',
                    subtitle: 'When someone mentions you',
                    value: _mentionNotifications,
                    onChanged: (value) {
                      setState(() {
                        _mentionNotifications = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    icon: Icons.system_update,
                    title: 'System Notifications',
                    subtitle: 'App updates and maintenance',
                    value: _systemNotifications,
                    onChanged: (value) {
                      setState(() {
                        _systemNotifications = value;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Email Notifications Section
          _buildSectionHeader('Email Notifications'),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.email,
                  title: 'Enable Email Notifications',
                  subtitle: 'Receive notifications via email',
                  value: _emailNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _emailNotificationsEnabled = value;
                    });
                  },
                ),
                if (_emailNotificationsEnabled) ...[
                  const Divider(height: 1),
                  _buildSwitchTile(
                    icon: Icons.summarize,
                    title: 'Weekly Digest',
                    subtitle: 'Summary of your activity',
                    value: _weeklyDigest,
                    onChanged: (value) {
                      setState(() {
                        _weeklyDigest = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    icon: Icons.local_offer,
                    title: 'Promotional Emails',
                    subtitle: 'Special offers and updates',
                    value: _promotionalEmails,
                    onChanged: (value) {
                      setState(() {
                        _promotionalEmails = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    icon: Icons.security,
                    title: 'Security Alerts',
                    subtitle: 'Login and security notifications',
                    value: _securityEmails,
                    onChanged: (value) {
                      setState(() {
                        _securityEmails = value;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Sound and Vibration Section
          _buildSectionHeader('Sound & Vibration'),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.volume_up,
                  title: 'Sound',
                  subtitle: 'Play sound for notifications',
                  value: _soundEnabled,
                  onChanged: (value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                  },
                ),
                if (_soundEnabled) ...[
                  const Divider(height: 1),
                  _buildSettingsTile(
                    icon: Icons.music_note,
                    title: 'Notification Sound',
                    subtitle: _selectedSound,
                    onTap: () => _showSoundSelectionDialog(),
                  ),
                ],
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.vibration,
                  title: 'Vibration',
                  subtitle: 'Vibrate for notifications',
                  value: _vibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quiet Hours Section
          _buildSectionHeader('Quiet Hours'),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.do_not_disturb,
                  title: 'Enable Quiet Hours',
                  subtitle: 'Mute notifications during specific hours',
                  value: _quietHoursEnabled,
                  onChanged: (value) {
                    setState(() {
                      _quietHoursEnabled = value;
                    });
                  },
                ),
                if (_quietHoursEnabled) ...[
                  const Divider(height: 1),
                  _buildTimeTile(
                    icon: Icons.bedtime,
                    title: 'Start Time',
                    time: _quietStart,
                    onTap: () => _selectQuietStartTime(),
                  ),
                  const Divider(height: 1),
                  _buildTimeTile(
                    icon: Icons.wb_sunny,
                    title: 'End Time',
                    time: _quietEnd,
                    onTap: () => _selectQuietEndTime(),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Advanced Settings Section
          _buildSectionHeader('Advanced'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.block,
                  title: 'Blocked Users',
                  subtitle: 'Manage blocked users notifications',
                  onTap: () => _showBlockedUsersDialog(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.filter_list,
                  title: 'Notification Filters',
                  subtitle: 'Custom notification filters',
                  onTap: () => _showNotificationFiltersDialog(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.history,
                  title: 'Notification History',
                  subtitle: 'View past notifications',
                  onTap: () => _showNotificationHistoryDialog(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Test Notification Button
          ElevatedButton.icon(
            onPressed: _sendTestNotification,
            icon: const Icon(Icons.send),
            label: const Text('Send Test Notification'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildTimeTile({
    required IconData icon,
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title),
      subtitle: Text(time.format(context)),
      trailing: const Icon(Icons.access_time),
      onTap: onTap,
    );
  }

  void _showSoundSelectionDialog() {
    final sounds = ['Default', 'Bell', 'Chime', 'Ding', 'Pop', 'Whistle'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Notification Sound'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: sounds.map((sound) {
            return RadioListTile<String>(
              title: Text(sound),
              value: sound,
              groupValue: _selectedSound,
              onChanged: (value) {
                setState(() {
                  _selectedSound = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectQuietStartTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _quietStart,
    );
    if (time != null) {
      setState(() {
        _quietStart = time;
      });
    }
  }

  Future<void> _selectQuietEndTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _quietEnd,
    );
    if (time != null) {
      setState(() {
        _quietEnd = time;
      });
    }
  }

  void _showBlockedUsersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Blocked Users'),
        content: const Text('No blocked users at the moment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Filters'),
        content: const Text('Custom notification filters will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHistoryItem('John liked your post', '2 hours ago'),
            _buildHistoryItem('Sarah started following you', '1 day ago'),
            _buildHistoryItem('New comment on your post', '2 days ago'),
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

  Widget _buildHistoryItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _sendTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}