import 'package:flutter/material.dart';

class MessagingScreenTheme {
  final Color backgroundColor;
  final Color messageBubbleColor;
  final Color sentMessageColor;
  final Color textColor;
  final Color inputBackground;

  const MessagingScreenTheme({
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.messageBubbleColor = const Color(0xFFFFFFFF),
    this.sentMessageColor = const Color(0xFF3B82F6),
    this.textColor = const Color(0xFF111827),
    this.inputBackground = const Color(0xFFFFFFFF),
  });
}

class Message {
  final String id;
  final String text;
  final bool isSent;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.text,
    required this.isSent,
    required this.timestamp,
  });
}

class MessagingScreen extends StatefulWidget {
  final MessagingScreenTheme? theme;

  const MessagingScreen({Key? key, this.theme}) : super(key: key);

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [
    Message(
      id: '1',
      text: 'Hey, how are you?',
      isSent: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Message(
      id: '2',
      text: 'I\'m good, thanks! How about you?',
      isSent: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
    ),
  ];

  MessagingScreenTheme get _theme => widget.theme ?? const MessagingScreenTheme();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(
        id: DateTime.now().toString(),
        text: _controller.text.trim(),
        isSent: true,
        timestamp: DateTime.now(),
      ));
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: _theme.sentMessageColor,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jane Smith', style: TextStyle(fontSize: 16)),
                Text('Active now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(
                  message: message,
                  theme: _theme,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _theme.inputBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: _theme.backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: _theme.sentMessageColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final MessagingScreenTheme theme;

  const _MessageBubble({
    required this.message,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isSent ? theme.sentMessageColor : theme.messageBubbleColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isSent ? Colors.white : theme.textColor,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
