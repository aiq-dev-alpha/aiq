import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Conversation> conversations = [
    Conversation(
      id: '1',
      username: 'alice_wonder',
      displayName: 'Alice Wonder',
      avatar: 'https://example.com/avatar3.jpg',
      lastMessage: 'Hey! How are you doing?',
      timestamp: '2m',
      unreadCount: 2,
      isOnline: true,
      lastMessageType: MessageType.text,
    ),
    Conversation(
      id: '2',
      username: 'bob_builder',
      displayName: 'Bob Builder',
      avatar: 'https://example.com/avatar4.jpg',
      lastMessage: 'Thanks for the photo!',
      timestamp: '1h',
      unreadCount: 0,
      isOnline: false,
      lastMessageType: MessageType.text,
    ),
    Conversation(
      id: '3',
      username: 'charlie_brown',
      displayName: 'Charlie Brown',
      avatar: 'https://example.com/avatar5.jpg',
      lastMessage: 'Photo',
      timestamp: '3h',
      unreadCount: 1,
      isOnline: true,
      lastMessageType: MessageType.image,
    ),
    Conversation(
      id: '4',
      username: 'diana_prince',
      displayName: 'Diana Prince',
      avatar: 'https://example.com/avatar6.jpg',
      lastMessage: 'Voice message',
      timestamp: '1d',
      unreadCount: 0,
      isOnline: false,
      lastMessageType: MessageType.voice,
    ),
    Conversation(
      id: '5',
      username: 'edward_stark',
      displayName: 'Edward Stark',
      avatar: 'https://example.com/avatar7.jpg',
      lastMessage: 'Video',
      timestamp: '2d',
      unreadCount: 0,
      isOnline: true,
      lastMessageType: MessageType.video,
    ),
  ];

  List<Conversation> filteredConversations = [];
  bool isSelectionMode = false;
  Set<String> selectedConversations = {};

  @override
  void initState() {
    super.initState();
    filteredConversations = List.from(conversations);
    _searchController.addListener(_filterConversations);
  }

  void _filterConversations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredConversations = List.from(conversations);
      } else {
        filteredConversations = conversations.where((conversation) {
          return conversation.username.toLowerCase().contains(query) ||
                 conversation.displayName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Messages',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (conversations.where((c) => c.unreadCount > 0).isNotEmpty)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  conversations.where((c) => c.unreadCount > 0).length.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          if (isSelectionMode) ...[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: selectedConversations.isNotEmpty ? _deleteSelected : null,
            ),
            IconButton(
              icon: Icon(Icons.archive),
              onPressed: selectedConversations.isNotEmpty ? _archiveSelected : null,
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _exitSelectionMode,
            ),
          ] else ...[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _newMessage,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          // Quick actions
          Container(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildQuickAction(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: _openCamera,
                ),
                _buildQuickAction(
                  icon: Icons.favorite,
                  label: 'Your Story',
                  onTap: _viewOwnStory,
                ),
                ...conversations
                    .where((c) => c.isOnline)
                    .take(5)
                    .map((c) => _buildActiveUser(c)),
              ],
            ),
          ),
          // Conversations list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshMessages,
              child: ListView.builder(
                itemCount: filteredConversations.length,
                itemBuilder: (context, index) {
                  return _buildConversationItem(filteredConversations[index]);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newMessage,
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Icon(icon, size: 24),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveUser(Conversation conversation) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => _openChat(conversation),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(conversation.avatar),
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              conversation.username.length > 8
                  ? '${conversation.username.substring(0, 8)}...'
                  : conversation.username,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationItem(Conversation conversation) {
    bool isSelected = selectedConversations.contains(conversation.id);

    return ListTile(
      selected: isSelected,
      onTap: () {
        if (isSelectionMode) {
          _toggleSelection(conversation.id);
        } else {
          _openChat(conversation);
        }
      },
      onLongPress: () {
        if (!isSelectionMode) {
          setState(() {
            isSelectionMode = true;
            selectedConversations.add(conversation.id);
          });
        }
      },
      leading: Stack(
        children: [
          if (isSelectionMode)
            Positioned(
              left: -4,
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleSelection(conversation.id),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left: isSelectionMode ? 24 : 0),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(conversation.avatar),
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      title: Row(
        children: [
          Text(
            conversation.displayName,
            style: TextStyle(
              fontWeight: conversation.unreadCount > 0
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          if (conversation.unreadCount > 0)
            Container(
              margin: EdgeInsets.only(left: 8),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          _getMessageTypeIcon(conversation.lastMessageType),
          if (conversation.lastMessageType != MessageType.text)
            SizedBox(width: 4),
          Expanded(
            child: Text(
              conversation.lastMessage,
              style: TextStyle(
                color: conversation.unreadCount > 0
                    ? Colors.black87
                    : Colors.grey[600],
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            conversation.timestamp,
            style: TextStyle(
              fontSize: 12,
              color: conversation.unreadCount > 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          ),
          if (conversation.unreadCount > 0)
            Container(
              margin: EdgeInsets.only(top: 4),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                conversation.unreadCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _getMessageTypeIcon(MessageType type) {
    switch (type) {
      case MessageType.image:
        return Icon(Icons.photo, size: 16, color: Colors.grey[600]);
      case MessageType.video:
        return Icon(Icons.videocam, size: 16, color: Colors.grey[600]);
      case MessageType.voice:
        return Icon(Icons.mic, size: 16, color: Colors.grey[600]);
      case MessageType.text:
      default:
        return SizedBox.shrink();
    }
  }

  void _toggleSelection(String conversationId) {
    setState(() {
      if (selectedConversations.contains(conversationId)) {
        selectedConversations.remove(conversationId);
        if (selectedConversations.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedConversations.add(conversationId);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedConversations.clear();
    });
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Conversations'),
        content: Text(
          'Are you sure you want to delete ${selectedConversations.length} conversation(s)?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                conversations.removeWhere((c) => selectedConversations.contains(c.id));
                filteredConversations.removeWhere((c) => selectedConversations.contains(c.id));
                selectedConversations.clear();
                isSelectionMode = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Conversations deleted')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _archiveSelected() {
    setState(() {
      // In real app, move to archived conversations
      conversations.removeWhere((c) => selectedConversations.contains(c.id));
      filteredConversations.removeWhere((c) => selectedConversations.contains(c.id));
      selectedConversations.clear();
      isSelectionMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Conversations archived')),
    );
  }

  void _openCamera() {
    Navigator.pushNamed(context, '/camera');
  }

  void _viewOwnStory() {
    Navigator.pushNamed(context, '/stories', arguments: 'current_user');
  }

  void _openChat(Conversation conversation) {
    // Mark as read when opening
    setState(() {
      conversation.unreadCount = 0;
    });

    Navigator.pushNamed(
      context,
      '/chat',
      arguments: conversation.username,
    );
  }

  void _newMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'New Message',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search people...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 10, // Sample contacts
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://example.com/contact$index.jpg',
                            ),
                          ),
                          title: Text('Contact $index'),
                          subtitle: Text('@contact_$index'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/chat',
                              arguments: 'contact_$index',
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _refreshMessages() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // Update conversations with new messages
      for (var conversation in conversations) {
        if (conversation.username == 'alice_wonder') {
          conversation.lastMessage = 'Just sent you something cool!';
          conversation.timestamp = 'now';
          conversation.unreadCount += 1;
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

enum MessageType {
  text,
  image,
  video,
  voice,
}

class Conversation {
  final String id;
  final String username;
  final String displayName;
  final String avatar;
  String lastMessage;
  String timestamp;
  int unreadCount;
  final bool isOnline;
  final MessageType lastMessageType;

  Conversation({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
    required this.lastMessageType,
  });
}