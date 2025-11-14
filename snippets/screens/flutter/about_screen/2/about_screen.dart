import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Icon and Name
            const SizedBox(height: 32),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.flutter_dash,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'My Awesome App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version 1.0.0 (Build 123)',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // App Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About This App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This is an amazing Flutter application that provides a comprehensive set of features for modern mobile users. Built with care and attention to detail, it offers a seamless user experience across different platforms.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // App Information
            Card(
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.info,
                    title: 'Version',
                    subtitle: '1.0.0 (Build 123)',
                    onTap: () => _showVersionDetails(context),
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.calendar_today,
                    title: 'Release Date',
                    subtitle: 'January 15, 2024',
                    onTap: null,
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.storage,
                    title: 'App Size',
                    subtitle: '45.2 MB',
                    onTap: null,
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.star_rate,
                    title: 'Rating',
                    subtitle: '4.8 ⭐ (1,234 reviews)',
                    onTap: () => _showRatingDetails(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Developer Information
            Card(
              child: Column(
                children: [
                  _buildSectionHeader('Developer'),
                  _buildInfoTile(
                    icon: Icons.business,
                    title: 'Company',
                    subtitle: 'Awesome Development Studio',
                    onTap: null,
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.email,
                    title: 'Contact',
                    subtitle: 'support@awesomeapp.com',
                    onTap: () => _copyToClipboard(context, 'support@awesomeapp.com'),
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.language,
                    title: 'Website',
                    subtitle: 'www.awesomeapp.com',
                    onTap: () => _openWebsite(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Legal Information
            Card(
              child: Column(
                children: [
                  _buildSectionHeader('Legal'),
                  _buildInfoTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    subtitle: 'How we protect your data',
                    onTap: () => _openPrivacyPolicy(context),
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.gavel,
                    title: 'Terms of Service',
                    subtitle: 'Usage terms and conditions',
                    onTap: () => _openTermsOfService(context),
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.article,
                    title: 'Open Source Licenses',
                    subtitle: 'Third-party licenses',
                    onTap: () => _showLicensePage(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Social Links
            Card(
              child: Column(
                children: [
                  _buildSectionHeader('Connect With Us'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: Icons.facebook,
                        label: 'Facebook',
                        color: const Color(0xFF1877F2),
                        onTap: () => _openSocialLink(context, 'Facebook'),
                      ),
                      _buildSocialButton(
                        icon: Icons.alternate_email,
                        label: 'Twitter',
                        color: const Color(0xFF1DA1F2),
                        onTap: () => _openSocialLink(context, 'Twitter'),
                      ),
                      _buildSocialButton(
                        icon: Icons.camera_alt,
                        label: 'Instagram',
                        color: const Color(0xFFE4405F),
                        onTap: () => _openSocialLink(context, 'Instagram'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // System Information
            Card(
              child: Column(
                children: [
                  _buildSectionHeader('System Information'),
                  _buildInfoTile(
                    icon: Icons.phone_android,
                    title: 'Platform',
                    subtitle: 'Flutter ${_getFlutterVersion()}',
                    onTap: () => _showSystemInfo(context),
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.code,
                    title: 'Dart Version',
                    subtitle: _getDartVersion(),
                    onTap: null,
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.settings,
                    title: 'Device Info',
                    subtitle: 'Tap to view details',
                    onTap: () => _showDeviceInfo(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Credits
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Credits & Acknowledgments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '• Flutter Team - For the amazing framework\n'
                      '• Material Design - For design inspiration\n'
                      '• Unsplash - For beautiful placeholder images\n'
                      '• Open Source Community - For countless packages',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Made with ❤️ using Flutter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Copyright
            Text(
              '© 2024 Awesome Development Studio\nAll rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
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
      trailing: onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getFlutterVersion() {
    return '3.16.0'; // In a real app, get this dynamically
  }

  String _getDartVersion() {
    return '3.2.0'; // In a real app, get this dynamically
  }

  void _showVersionDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Version Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Version', '1.0.0'),
            _buildDetailRow('Build Number', '123'),
            _buildDetailRow('Release Type', 'Stable'),
            _buildDetailRow('Minimum OS', 'iOS 11.0 / Android 21'),
            _buildDetailRow('Target OS', 'iOS 17.0 / Android 34'),
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

  void _showRatingDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Reviews'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRatingBar('5 stars', 0.7, Colors.green),
            _buildRatingBar('4 stars', 0.2, Colors.lightGreen),
            _buildRatingBar('3 stars', 0.05, Colors.orange),
            _buildRatingBar('2 stars', 0.03, Colors.deepOrange),
            _buildRatingBar('1 star', 0.02, Colors.red),
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
                const SnackBar(content: Text('Thank you for rating!')),
              );
            },
            child: const Text('Rate App'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $text to clipboard')),
    );
  }

  void _openWebsite(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening website...')),
    );
    // In a real app, use url_launcher package
  }

  void _openPrivacyPolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Privacy Policy...')),
    );
  }

  void _openTermsOfService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Terms of Service...')),
    );
  }

  void _showLicensePage(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'My Awesome App',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.flutter_dash, size: 48),
    );
  }

  void _openSocialLink(BuildContext context, String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $platform...')),
    );
  }

  void _showSystemInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('System Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Flutter', _getFlutterVersion()),
            _buildDetailRow('Dart', _getDartVersion()),
            _buildDetailRow('Platform', 'Android/iOS'),
            _buildDetailRow('Render Engine', 'Skia'),
            _buildDetailRow('Architecture', 'ARM64'),
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

  void _showDeviceInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Device Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Model', 'Simulated Device'),
            _buildDetailRow('OS Version', 'Latest'),
            _buildDetailRow('Screen Size', '6.1 inches'),
            _buildDetailRow('Resolution', '1080x2400'),
            _buildDetailRow('RAM', '8 GB'),
            _buildDetailRow('Storage', '128 GB'),
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
}