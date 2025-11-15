import 'package:flutter/material.dart';

class ChatThemeConfig {
  final Color myMessageColor;
  final Color otherMessageColor;
  final Color backgroundColor;
  final Color inputBarColor;
  final double messageBorderRadius;

  const ChatThemeConfig({
    this.myMessageColor = const Color(0xFF6200EE),
    this.otherMessageColor = const Color(0xFFE0E0E0),
    this.backgroundColor = Colors.white,
    this.inputBarColor = const Color(0xFFF5F5F5),
    this.messageBorderRadius = 18.0,
  });
}

class ChatScreen extends StatefulWidget {
  final ChatThemeConfig? theme;
  final List<ChatMessage>? messages;

  const ChatScreen({
    Key? key,
    this.theme,
    this.messages,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = widget.messages ?? _defaultMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: '${_messages.length}',
        text: _messageController.text,
        isMine: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  List<ChatMessage> _defaultMessages() {
    return [
      ChatMessage(
        id: '1',
        text: 'Hello!',
        isMine: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: '2',
        text: 'Hi there!',
        isMine: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      ),
      ChatMessage(
        id: '3',
        text: 'How are you?',
        isMine: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const ChatThemeConfig();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 12),
            const Text('Chat'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _MessageBubble(
                message: _messages[index],
                theme: theme,
              ),
            ),
          ),
          _buildInputBar(theme),
        ],
      ),
    );
  }

  Widget _buildInputBar(ChatThemeConfig theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.inputBarColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: theme.myMessageColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatThemeConfig theme;

  const _MessageBubble({required this.message, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: message.isMine ? theme.myMessageColor : theme.otherMessageColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(theme.messageBorderRadius),
            topRight: Radius.circular(theme.messageBorderRadius),
            bottomLeft: Radius.circular(message.isMine ? theme.messageBorderRadius : 4),
            bottomRight: Radius.circular(message.isMine ? 4 : theme.messageBorderRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMine ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: message.isMine ? Colors.white70 : Colors.black54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String id;
  final String text;
  final bool isMine;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMine,
    required this.timestamp,
  });
}
