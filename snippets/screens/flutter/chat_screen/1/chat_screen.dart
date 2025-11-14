import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String username;

  const ChatScreen({Key? key, required this.username}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;

  List<Message> messages = [
    Message(
      id: '1',
      senderId: 'alice_wonder',
      text: 'Hey! How are you?',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      type: MessageType.text,
      isRead: true,
    ),
    Message(
      id: '2',
      senderId: 'current_user',
      text: 'I\'m good! Just working on some projects. How about you?',
      timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: -5)),
      type: MessageType.text,
      isRead: true,
    ),
    Message(
      id: '3',
      senderId: 'alice_wonder',
      imageUrl: 'https://example.com/shared_image.jpg',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      type: MessageType.image,
      isRead: true,
    ),
    Message(
      id: '4',
      senderId: 'alice_wonder',
      text: 'Check out this cool photo I took!',
      timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: -1)),
      type: MessageType.text,
      isRead: true,
    ),
    Message(
      id: '5',
      senderId: 'current_user',
      text: 'Wow, that\'s amazing! 😍',
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
      type: MessageType.text,
      isRead: true,
    ),
    Message(
      id: '6',
      senderId: 'alice_wonder',
      text: 'Thanks! Want to meet up this weekend?',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      type: MessageType.text,
      isRead: false,
    ),
  ];

  bool isOnline = true;
  String lastSeen = '2 minutes ago';
  bool isTyping = false;
  String recordingPath = '';
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Simulate typing indicator
    _simulateTyping();

    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _simulateTyping() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isTyping = true;
        });

        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              isTyping = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      titleSpacing: 0,
      title: GestureDetector(
        onTap: _navigateToProfile,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://example.com/avatar3.jpg'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    isOnline ? 'Online' : 'Last seen $lastSeen',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: _startVideoCall,
        ),
        IconButton(
          icon: Icon(Icons.call),
          onPressed: _startVoiceCall,
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            PopupMenuItem(value: 'view_profile', child: Text('View Profile')),
            PopupMenuItem(value: 'mute', child: Text('Mute')),
            PopupMenuItem(value: 'block', child: Text('Block')),
            PopupMenuItem(value: 'report', child: Text('Report')),
            PopupMenuItem(value: 'clear_chat', child: Text('Clear Chat')),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Message message) {
    bool isMe = message.senderId == 'current_user';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage('https://example.com/avatar3.jpg'),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == MessageType.image)
                    _buildImageMessage(message),
                  if (message.type == MessageType.voice)
                    _buildVoiceMessage(message),
                  if (message.type == MessageType.text && message.text != null)
                    Text(
                      message.text!,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      if (isMe) ...[
                        SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 16,
                          color: message.isRead ? Colors.blue : Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage('https://example.com/current_user_avatar.jpg'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageMessage(Message message) {
    return GestureDetector(
      onTap: () => _viewFullScreenImage(message.imageUrl!),
      child: Container(
        width: 200,
        height: 200,
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(message.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black26],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceMessage(Message message) {
    return Container(
      width: 200,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.play_arrow,
              color: message.senderId == 'current_user' ? Colors.white : Colors.black,
            ),
            onPressed: () => _playVoiceMessage(message),
          ),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: message.senderId == 'current_user'
                    ? Colors.white30
                    : Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
              child: LinearProgressIndicator(
                value: 0.3, // Sample progress
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(
                  message.senderId == 'current_user' ? Colors.white : Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '0:15',
            style: TextStyle(
              color: message.senderId == 'current_user' ? Colors.white70 : Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage('https://example.com/avatar3.jpg'),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                SizedBox(width: 4),
                _buildTypingDot(1),
                SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double value = (_animationController.value + index * 0.2) % 1.0;
        double opacity = (0.5 + 0.5 * (1.0 - (value * 2 - 1).abs())).clamp(0.0, 1.0);

        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
            onPressed: _showAttachmentOptions,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onChanged: (text) {
                // Handle typing indicator
              },
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onLongPress: _startRecording,
            onLongPressUp: _stopRecording,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _messageController.text.trim().isNotEmpty
                    ? Icons.send
                    : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Send',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                  ),
                  children: [
                    _buildAttachmentOption(
                      Icons.camera_alt,
                      'Camera',
                      Colors.red,
                      () => _sendMedia('camera'),
                    ),
                    _buildAttachmentOption(
                      Icons.photo_library,
                      'Gallery',
                      Colors.purple,
                      () => _sendMedia('gallery'),
                    ),
                    _buildAttachmentOption(
                      Icons.insert_drive_file,
                      'Document',
                      Colors.blue,
                      () => _sendMedia('document'),
                    ),
                    _buildAttachmentOption(
                      Icons.location_on,
                      'Location',
                      Colors.green,
                      () => _sendLocation(),
                    ),
                    _buildAttachmentOption(
                      Icons.person,
                      'Contact',
                      Colors.orange,
                      () => _sendContact(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.day == now.day) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'current_user',
          text: _messageController.text,
          timestamp: DateTime.now(),
          type: MessageType.text,
          isRead: false,
        ));
      });

      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _sendMedia(String type) {
    setState(() {
      messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'current_user',
        imageUrl: 'https://example.com/sent_media.jpg',
        timestamp: DateTime.now(),
        type: MessageType.image,
        isRead: false,
      ));
    });
    _scrollToBottom();
  }

  void _sendLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location sharing functionality')),
    );
  }

  void _sendContact() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contact sharing functionality')),
    );
  }

  void _startRecording() {
    setState(() {
      isRecording = true;
    });
    // Start voice recording
  }

  void _stopRecording() {
    setState(() {
      isRecording = false;
    });
    // Stop recording and send voice message
    setState(() {
      messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'current_user',
        timestamp: DateTime.now(),
        type: MessageType.voice,
        isRead: false,
      ));
    });
    _scrollToBottom();
  }

  void _startVideoCall() {
    Navigator.pushNamed(context, '/video-call', arguments: widget.username);
  }

  void _startVoiceCall() {
    Navigator.pushNamed(context, '/voice-call', arguments: widget.username);
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/user-profile', arguments: widget.username);
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'view_profile':
        _navigateToProfile();
        break;
      case 'mute':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chat muted')),
        );
        break;
      case 'block':
        _showBlockDialog();
        break;
      case 'report':
        _showReportDialog();
        break;
      case 'clear_chat':
        _showClearChatDialog();
        break;
    }
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block ${widget.username}?'),
        content: Text('Blocked contacts will not be able to send you messages.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.username} blocked')),
              );
            },
            child: Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report ${widget.username}?'),
        content: Text('This will report the user for inappropriate behavior.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User reported')),
              );
            },
            child: Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Chat?'),
        content: Text('This will delete all messages in this chat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                messages.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Chat cleared')),
              );
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _viewFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _playVoiceMessage(Message message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing voice message...')),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

enum MessageType {
  text,
  image,
  voice,
  video,
}

class Message {
  final String id;
  final String senderId;
  final String? text;
  final String? imageUrl;
  final DateTime timestamp;
  final MessageType type;
  bool isRead;

  Message({
    required this.id,
    required this.senderId,
    this.text,
    this.imageUrl,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });
}