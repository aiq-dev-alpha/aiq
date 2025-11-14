import 'package:flutter/material.dart';

class LiveStreamScreen extends StatefulWidget {
  final String? streamerUsername;
  final bool isStreaming;

  const LiveStreamScreen({
    Key? key,
    this.streamerUsername,
    this.isStreaming = false,
  }) : super(key: key);

  @override
  _LiveStreamScreenState createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatController = ScrollController();
  late AnimationController _liveIndicatorController;

  int viewerCount = 1247;
  int likeCount = 3456;
  bool isLiked = false;
  bool isMuted = false;
  bool isStreaming = false;
  bool showChat = true;

  List<LiveMessage> messages = [
    LiveMessage(
      id: '1',
      username: 'viewer1',
      message: 'Great stream! 🔥',
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
      isHighlighted: false,
    ),
    LiveMessage(
      id: '2',
      username: 'viewer2',
      message: 'Hello everyone! 👋',
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
      isHighlighted: false,
    ),
    LiveMessage(
      id: '3',
      username: 'moderator',
      message: 'Welcome to the stream!',
      timestamp: DateTime.now().subtract(Duration(seconds: 30)),
      isHighlighted: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    isStreaming = widget.isStreaming;

    _liveIndicatorController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    if (isStreaming) {
      _liveIndicatorController.repeat();
    }

    // Simulate new messages
    _simulateMessages();

    // Auto-scroll chat to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _simulateMessages() {
    if (!isStreaming) return;

    Future.delayed(Duration(seconds: 5), () {
      if (mounted && isStreaming) {
        setState(() {
          messages.add(LiveMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            username: 'random_viewer',
            message: 'This is amazing! 😍',
            timestamp: DateTime.now(),
            isHighlighted: false,
          ));
          viewerCount += (DateTime.now().millisecond % 5);
        });
        _scrollToBottom();
        _simulateMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video stream area
          Container(
            width: double.infinity,
            height: double.infinity,
            child: _buildVideoStream(),
          ),
          // Top overlay with streamer info
          SafeArea(
            child: _buildTopOverlay(),
          ),
          // Chat overlay
          if (showChat) _buildChatOverlay(),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: _buildBottomControls(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoStream() {
    if (isStreaming) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.withOpacity(0.3),
              Colors.black,
              Colors.blue.withOpacity(0.3),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam,
                size: 120,
                color: Colors.white.withOpacity(0.5),
              ),
              SizedBox(height: 20),
              Text(
                'Live Stream',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Camera feed would appear here',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  widget.streamerUsername != null
                      ? 'https://example.com/${widget.streamerUsername}.jpg'
                      : 'https://example.com/current_user_avatar.jpg',
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.streamerUsername ?? 'You',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'LIVE ENDED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildTopOverlay() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Live indicator
              AnimatedBuilder(
                animation: _liveIndicatorController,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(
                        isStreaming
                            ? 0.8 + 0.2 * _liveIndicatorController.value
                            : 0.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 8),
              // Viewer count
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      _formatCount(viewerCount),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Spacer(),
              // Close button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          if (!isStreaming) ...[
            SizedBox(height: 16),
            // Streamer info for ended stream
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://example.com/${widget.streamerUsername ?? 'current_user'}.jpg',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.streamerUsername ?? 'You',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Stream ended • ${_formatCount(viewerCount)} viewers',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.streamerUsername != null)
                  OutlinedButton(
                    onPressed: _followStreamer,
                    child: Text('Follow', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatOverlay() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      bottom: 120,
      left: 16,
      right: MediaQuery.of(context).size.width * 0.3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Chat header
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Icon(Icons.chat, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Live Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => showChat = false),
                    child: Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            // Messages
            Expanded(
              child: ListView.builder(
                controller: _chatController,
                padding: EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildChatMessage(messages[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(LiveMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: message.isHighlighted ? Colors.yellow.withOpacity(0.2) : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.white, fontSize: 12),
          children: [
            TextSpan(
              text: '${message.username}: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: message.isHighlighted ? Colors.yellow : Colors.white,
              ),
            ),
            TextSpan(text: message.message),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // Chat input (only if streaming)
          if (isStreaming) ...[
            Expanded(
              child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white30),
                ),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Say something...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
          // Action buttons
          _buildActionButton(
            icon: showChat ? Icons.chat : Icons.chat_bubble_outline,
            onTap: () => setState(() => showChat = !showChat),
          ),
          SizedBox(width: 12),
          _buildActionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.white,
            onTap: _toggleLike,
            count: likeCount,
          ),
          SizedBox(width: 12),
          _buildActionButton(
            icon: Icons.share,
            onTap: _shareStream,
          ),
          if (!isStreaming && widget.streamerUsername == null) ...[
            SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _startLiveStream,
              icon: Icon(Icons.videocam),
              label: Text('Go Live'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
          if (isStreaming && widget.streamerUsername == null) ...[
            SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _endLiveStream,
              icon: Icon(Icons.stop),
              label: Text('End'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
    int? count,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          if (count != null) ...[
            SizedBox(height: 4),
            Text(
              _formatCount(count),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        messages.add(LiveMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          username: 'You',
          message: text,
          timestamp: DateTime.now(),
          isHighlighted: false,
        ));
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });

    if (isLiked) {
      // Show floating heart animation
      _showFloatingHeart();
    }
  }

  void _showFloatingHeart() {
    // This would show a floating heart animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❤️ Liked!'),
        duration: Duration(milliseconds: 800),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  void _shareStream() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share Live Stream',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.copy),
                title: Text('Copy Link'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Live stream link copied')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share to Story'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Shared to your story')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.send),
                title: Text('Send to Friends'),
                onTap: () {
                  Navigator.pop(context);
                  // Show friends list
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startLiveStream() {
    setState(() {
      isStreaming = true;
      viewerCount = 1;
    });
    _liveIndicatorController.repeat();
    _simulateMessages();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Live stream started! 🔴'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _endLiveStream() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('End Live Stream?'),
        content: Text('Are you sure you want to end your live stream?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isStreaming = false;
              });
              _liveIndicatorController.stop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Live stream ended'),
                  backgroundColor: Colors.grey,
                ),
              );
            },
            child: Text('End Stream', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _followStreamer() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Following ${widget.streamerUsername}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _scrollToBottom() {
    if (_chatController.hasClients) {
      _chatController.animateTo(
        _chatController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatController.dispose();
    _liveIndicatorController.dispose();
    super.dispose();
  }
}

class LiveMessage {
  final String id;
  final String username;
  final String message;
  final DateTime timestamp;
  final bool isHighlighted;

  LiveMessage({
    required this.id,
    required this.username,
    required this.message,
    required this.timestamp,
    required this.isHighlighted,
  });
}