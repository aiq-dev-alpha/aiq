import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'How do I reset my password?',
      answer: 'To reset your password, go to Settings > Account Settings > Change Password. You can also use the "Forgot Password" link on the login screen.',
      category: 'Account',
    ),
    FAQItem(
      question: 'How do I change my profile picture?',
      answer: 'Go to your Profile, tap the Edit button, then tap on your profile picture to select a new one from your gallery or take a new photo.',
      category: 'Profile',
    ),
    FAQItem(
      question: 'Why am I not receiving notifications?',
      answer: 'Check your notification settings in Settings > Notifications. Also make sure notifications are enabled for this app in your device settings.',
      category: 'Notifications',
    ),
    FAQItem(
      question: 'How do I delete my account?',
      answer: 'Go to Settings > Account Settings > Delete Account. Please note that this action cannot be undone.',
      category: 'Account',
    ),
    FAQItem(
      question: 'How do I contact support?',
      answer: 'You can contact our support team through this Help & Support screen, email us at support@app.com, or use the live chat feature.',
      category: 'Support',
    ),
    FAQItem(
      question: 'Is my data secure?',
      answer: 'Yes, we take data security seriously. All data is encrypted and stored securely. Read our Privacy Policy for more details.',
      category: 'Privacy',
    ),
    FAQItem(
      question: 'How do I change the app theme?',
      answer: 'Go to Settings > Theme Settings to choose between light, dark, or system theme, and customize accent colors.',
      category: 'Settings',
    ),
    FAQItem(
      question: 'Can I use the app offline?',
      answer: 'Some features work offline, but you\'ll need an internet connection for real-time updates and syncing.',
      category: 'General',
    ),
  ];

  List<FAQItem> get _filteredFAQs {
    if (_searchQuery.isEmpty) return _faqItems;
    return _faqItems.where((faq) {
      return faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             faq.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for help...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Quick Actions
          if (_searchQuery.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.chat_bubble_outline,
                          title: 'Live Chat',
                          subtitle: 'Chat with support',
                          onTap: () => _startLiveChat(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.email_outlined,
                          title: 'Email Us',
                          subtitle: 'Send us an email',
                          onTap: () => _sendEmail(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.phone_outlined,
                          title: 'Call Support',
                          subtitle: '24/7 phone support',
                          onTap: () => _callSupport(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.bug_report_outlined,
                          title: 'Report Bug',
                          subtitle: 'Report an issue',
                          onTap: () => _reportBug(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],

          // FAQ Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                if (_searchQuery.isEmpty) ...[
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  Text(
                    'Search Results (${_filteredFAQs.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // FAQ Items
                ..._filteredFAQs.map((faq) => _buildFAQItem(faq)),

                if (_filteredFAQs.isEmpty && _searchQuery.isNotEmpty) ...[
                  const SizedBox(height: 48),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try different keywords or contact support',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _contactSupport(),
                          icon: const Icon(Icons.support_agent),
                          label: const Text('Contact Support'),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Additional Resources
                if (_searchQuery.isEmpty) ...[
                  const Text(
                    'Additional Resources',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        _buildResourceTile(
                          icon: Icons.article_outlined,
                          title: 'User Guide',
                          subtitle: 'Complete app tutorial',
                          onTap: () => _openUserGuide(),
                        ),
                        const Divider(height: 1),
                        _buildResourceTile(
                          icon: Icons.video_library_outlined,
                          title: 'Video Tutorials',
                          subtitle: 'Watch how-to videos',
                          onTap: () => _openVideoTutorials(),
                        ),
                        const Divider(height: 1),
                        _buildResourceTile(
                          icon: Icons.forum_outlined,
                          title: 'Community Forum',
                          subtitle: 'Connect with other users',
                          onTap: () => _openCommunityForum(),
                        ),
                        const Divider(height: 1),
                        _buildResourceTile(
                          icon: Icons.new_releases_outlined,
                          title: 'What\'s New',
                          subtitle: 'Latest app updates',
                          onTap: () => _showWhatsNew(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Contact Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Still need help?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildContactInfo(
                          Icons.email,
                          'Email',
                          'support@awesomeapp.com',
                        ),
                        const SizedBox(height: 8),
                        _buildContactInfo(
                          Icons.phone,
                          'Phone',
                          '+1 (555) 123-HELP',
                        ),
                        const SizedBox(height: 8),
                        _buildContactInfo(
                          Icons.access_time,
                          'Hours',
                          'Mon-Fri 9AM-6PM EST',
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _contactSupport(),
                            icon: const Icon(Icons.support_agent),
                            label: const Text('Contact Support Team'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startLiveChat(),
        icon: const Icon(Icons.chat),
        label: const Text('Live Chat'),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          faq.category,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).primaryColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.answer,
                  style: const TextStyle(height: 1.5),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _markHelpful(faq),
                      icon: const Icon(Icons.thumb_up_outlined, size: 18),
                      label: const Text('Helpful'),
                    ),
                    TextButton.icon(
                      onPressed: () => _markNotHelpful(faq),
                      icon: const Icon(Icons.thumb_down_outlined, size: 18),
                      label: const Text('Not helpful'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildContactInfo(IconData icon, String title, String info) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$title: ',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(info),
      ],
    );
  }

  void _startLiveChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Live Chat'),
        content: const Text(
          'Our support team is available to chat Monday through Friday, 9 AM to 6 PM EST. '
          'Would you like to start a chat session?',
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
                const SnackBar(content: Text('Starting live chat...')),
              );
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _sendEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening email app...')),
    );
    // In a real app, use url_launcher to open email
  }

  void _callSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Support'),
        content: const Text('Call +1 (555) 123-HELP for immediate assistance.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening phone dialer...')),
              );
            },
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _reportBug() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BugReportScreen(),
      ),
    );
  }

  void _contactSupport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ContactSupportSheet(),
    );
  }

  void _openUserGuide() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening user guide...')),
    );
  }

  void _openVideoTutorials() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening video tutorials...')),
    );
  }

  void _openCommunityForum() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening community forum...')),
    );
  }

  void _showWhatsNew() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('What\'s New in v1.0.0'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎉 New Features:'),
            Text('• Dark mode support'),
            Text('• Enhanced notifications'),
            Text('• Improved performance'),
            SizedBox(height: 8),
            Text('🐛 Bug Fixes:'),
            Text('• Fixed login issues'),
            Text('• Resolved crash on startup'),
            Text('• UI improvements'),
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

  void _markHelpful(FAQItem faq) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
  }

  void _markNotHelpful(FAQItem faq) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('We\'ll work on improving this answer.')),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({Key? key}) : super(key: key);

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'UI/UX Issue';

  final List<String> _categories = [
    'UI/UX Issue',
    'App Crash',
    'Performance Issue',
    'Login Problem',
    'Notification Issue',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Bug'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Help us improve by reporting bugs',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Bug Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Bug Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a bug title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the bug in detail...',
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please describe the bug';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bug report submitted successfully!')),
                  );
                }
              },
              icon: const Icon(Icons.send),
              label: const Text('Submit Report'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class ContactSupportSheet extends StatefulWidget {
  const ContactSupportSheet({Key? key}) : super(key: key);

  @override
  State<ContactSupportSheet> createState() => _ContactSupportSheetState();
}

class _ContactSupportSheetState extends State<ContactSupportSheet> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Support',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              hintText: 'Describe your issue...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message sent to support team!')),
                    );
                  },
                  child: const Text('Send'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}