import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? '${widget.contact.name} added to favorites'
                        : '${widget.contact.name} removed from favorites',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editContact(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share Contact'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete Contact', style: TextStyle(color: Colors.red)),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _getAvatarColor(widget.contact.id),
                    child: Text(
                      widget.contact.avatar,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.contact.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Contact',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(
                    icon: Icons.call,
                    label: 'Call',
                    color: Colors.green,
                    onTap: () => _makeCall(widget.contact.phone),
                  ),
                  _buildQuickAction(
                    icon: Icons.message,
                    label: 'Message',
                    color: Colors.blue,
                    onTap: () => _sendMessage(widget.contact.phone),
                  ),
                  _buildQuickAction(
                    icon: Icons.email,
                    label: 'Email',
                    color: Colors.orange,
                    onTap: () => _sendEmail(widget.contact.email),
                  ),
                  _buildQuickAction(
                    icon: Icons.videocam,
                    label: 'Video',
                    color: Colors.purple,
                    onTap: () => _startVideoCall(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Contact Information
            _buildContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Contact Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildContactItem(
          icon: Icons.phone,
          title: 'Phone',
          subtitle: widget.contact.phone,
          onTap: () => _copyToClipboard(widget.contact.phone, 'Phone number copied'),
        ),
        _buildContactItem(
          icon: Icons.email,
          title: 'Email',
          subtitle: widget.contact.email,
          onTap: () => _copyToClipboard(widget.contact.email, 'Email address copied'),
        ),
        _buildContactItem(
          icon: Icons.cake,
          title: 'Birthday',
          subtitle: 'January 15, 1990',
          onTap: () {},
        ),
        _buildContactItem(
          icon: Icons.work,
          title: 'Company',
          subtitle: 'Tech Solutions Inc.',
          onTap: () {},
        ),
        _buildContactItem(
          icon: Icons.location_on,
          title: 'Address',
          subtitle: '123 Main St, Anytown, ST 12345',
          onTap: () => _openMaps(),
        ),
        _buildContactItem(
          icon: Icons.note,
          title: 'Notes',
          subtitle: 'Met at tech conference 2023. Interested in mobile development.',
          onTap: () => _editNotes(),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Color _getAvatarColor(String id) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[id.hashCode % colors.length];
  }

  void _editContact() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit contact functionality would be implemented here')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        _shareContact();
        break;
      case 'delete':
        _deleteContact();
        break;
    }
  }

  void _shareContact() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing contact...')),
    );
  }

  void _deleteContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${widget.contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.contact.name} deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _makeCall(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phone...')),
    );
  }

  void _sendMessage(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Messaging $phone...')),
    );
  }

  void _sendEmail(String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening email to $email...')),
    );
  }

  void _startVideoCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting video call...')),
    );
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openMaps() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening maps...')),
    );
  }

  void _editNotes() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit notes functionality would be implemented here')),
    );
  }
}

class Contact {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;

  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
  });
}