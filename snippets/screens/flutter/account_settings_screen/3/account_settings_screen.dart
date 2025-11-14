import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _twoFactorEnabled = false;
  bool _loginNotifications = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Account Information Section
          _buildSectionHeader('Account Information'),
          Card(
            child: Column(
              children: [
                _buildAccountInfoTile(
                  icon: Icons.email,
                  title: 'Email Address',
                  value: 'john.doe@example.com',
                  onTap: () => _showChangeEmailDialog(),
                ),
                const Divider(height: 1),
                _buildAccountInfoTile(
                  icon: Icons.phone,
                  title: 'Phone Number',
                  value: '+1 (555) 123-4567',
                  onTap: () => _showChangePhoneDialog(),
                ),
                const Divider(height: 1),
                _buildAccountInfoTile(
                  icon: Icons.calendar_today,
                  title: 'Member Since',
                  value: 'January 15, 2023',
                  onTap: null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Security Section
          _buildSectionHeader('Security'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () => _showChangePasswordDialog(),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.security,
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add an extra layer of security',
                  value: _twoFactorEnabled,
                  onChanged: (value) => _toggleTwoFactor(value),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.devices,
                  title: 'Manage Devices',
                  subtitle: 'View and manage logged in devices',
                  onTap: () => _showDevicesDialog(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.history,
                  title: 'Login Activity',
                  subtitle: 'View recent login attempts',
                  onTap: () => _showLoginActivityDialog(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionHeader('Security Notifications'),
          Card(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications_active,
                  title: 'Login Notifications',
                  subtitle: 'Get notified of new logins',
                  value: _loginNotifications,
                  onChanged: (value) {
                    setState(() {
                      _loginNotifications = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  icon: Icons.warning,
                  title: 'Security Alerts',
                  subtitle: 'Alerts for suspicious activity',
                  value: true,
                  onChanged: (value) {
                    // Handle security alerts toggle
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data Management Section
          _buildSectionHeader('Data Management'),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.download,
                  title: 'Download Data',
                  subtitle: 'Download a copy of your data',
                  onTap: () => _showDownloadDataDialog(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  icon: Icons.delete_forever,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  onTap: () => _showDeleteAccountDialog(),
                  titleColor: Colors.red,
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

  Widget _buildAccountInfoTile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title),
      subtitle: Text(value),
      trailing: onTap != null ? const Icon(Icons.edit, size: 20) : null,
      onTap: onTap,
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24, color: titleColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor,
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

  void _showChangeEmailDialog() {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'New Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
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
              _showSuccessSnackBar('Email address updated successfully');
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangePhoneDialog() {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Phone Number'),
        content: TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'New Phone Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Phone number updated successfully');
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
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
              _showSuccessSnackBar('Password changed successfully');
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _toggleTwoFactor(bool value) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (value) {
      // Show setup dialog
      _showTwoFactorSetupDialog();
    } else {
      setState(() {
        _twoFactorEnabled = false;
        _isLoading = false;
      });
      _showSuccessSnackBar('Two-factor authentication disabled');
    }
  }

  void _showTwoFactorSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Two-Factor Authentication'),
        content: const Text(
          'Two-factor authentication adds an extra layer of security to your account. '
          'You will need an authenticator app like Google Authenticator or Authy.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isLoading = false;
              });
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _twoFactorEnabled = true;
                _isLoading = false;
              });
              _showSuccessSnackBar('Two-factor authentication enabled');
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _showDevicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Devices'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeviceItem('iPhone 13', 'Current device', true),
            _buildDeviceItem('MacBook Pro', 'Last active: 2 hours ago', false),
            _buildDeviceItem('iPad', 'Last active: 1 day ago', false),
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

  Widget _buildDeviceItem(String device, String status, bool isCurrent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.devices),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrent ? Colors.green : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            TextButton(
              onPressed: () {
                _showSuccessSnackBar('Device removed');
              },
              child: const Text('Remove'),
            ),
        ],
      ),
    );
  }

  void _showLoginActivityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recent Login Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLoginActivity('iPhone 13', 'San Francisco, CA', 'Just now', true),
            _buildLoginActivity('MacBook Pro', 'San Francisco, CA', '2 hours ago', false),
            _buildLoginActivity('Unknown Device', 'New York, NY', '3 days ago', false, suspicious: true),
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

  Widget _buildLoginActivity(String device, String location, String time, bool isCurrent, {bool suspicious = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.devices,
                color: suspicious ? Colors.red : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  device,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: suspicious ? Colors.red : null,
                  ),
                ),
              ),
              if (isCurrent)
                const Text(
                  'Current',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              '$location • $time',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Your Data'),
        content: const Text(
          'We will prepare a copy of your data and send a download link to your email address. '
          'This may take up to 24 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Data download request submitted');
            },
            child: const Text('Request Download'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirmationDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Account Deletion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Type "DELETE" to confirm account deletion:'),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type DELETE here',
              ),
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
              if (confirmController.text == 'DELETE') {
                Navigator.pop(context);
                _showSuccessSnackBar('Account deletion initiated');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please type "DELETE" to confirm')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}