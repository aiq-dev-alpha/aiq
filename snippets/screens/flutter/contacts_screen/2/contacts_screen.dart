import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Contact> _contacts = [
    Contact(id: '1', name: 'Alice Johnson', email: 'alice@example.com', phone: '+1 555-0101', avatar: 'AJ'),
    Contact(id: '2', name: 'Bob Smith', email: 'bob@example.com', phone: '+1 555-0102', avatar: 'BS'),
    Contact(id: '3', name: 'Carol Davis', email: 'carol@example.com', phone: '+1 555-0103', avatar: 'CD'),
    Contact(id: '4', name: 'David Wilson', email: 'david@example.com', phone: '+1 555-0104', avatar: 'DW'),
    Contact(id: '5', name: 'Emma Brown', email: 'emma@example.com', phone: '+1 555-0105', avatar: 'EB'),
  ];

  List<Contact> get _filteredContacts {
    if (_searchQuery.isEmpty) return _contacts;
    return _contacts.where((contact) =>
        contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        contact.email.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddContactDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Contacts List
          Expanded(
            child: _filteredContacts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contact_page_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No contacts yet' : 'No contacts found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () => _showAddContactDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Contact'),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getAvatarColor(contact.id),
                            child: Text(
                              contact.avatar,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(contact.email),
                              Text(
                                contact.phone,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.phone),
                                onPressed: () => _makeCall(contact.phone),
                              ),
                              IconButton(
                                icon: const Icon(Icons.message),
                                onPressed: () => _sendMessage(contact.phone),
                              ),
                            ],
                          ),
                          onTap: () => _navigateToContactDetail(contact),
                        ),
                      );
                    },
                  ),
          ),
        ],
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

  void _navigateToContactDetail(Contact contact) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactDetailScreen(contact: contact),
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

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Contact'),
        content: const Text('Add contact functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

// This would typically be in a separate file
class ContactDetailScreen extends StatelessWidget {
  final Contact contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
      ),
      body: const Center(
        child: Text('Contact Detail Screen'),
      ),
    );
  }
}