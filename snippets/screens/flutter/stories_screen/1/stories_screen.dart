import 'package:flutter/material.dart';

class StoriesScreen extends StatefulWidget {
  final String? username;

  const StoriesScreen({Key? key, this.username}) : super(key: key);

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  PageController _pageController = PageController();

  int currentStoryIndex = 0;
  int currentUserIndex = 0;
  bool isPaused = false;

  final List<StoryUser> storyUsers = [
    StoryUser(
      username: 'alice_wonder',
      displayName: 'Alice Wonder',
      avatar: 'https://example.com/avatar3.jpg',
      stories: [
        Story(
          id: '1',
          mediaUrl: 'https://example.com/story1.jpg',
          type: StoryType.image,
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          caption: 'Beautiful morning! ☀️',
          views: 156,
        ),
        Story(
          id: '2',
          mediaUrl: 'https://example.com/story2.mp4',
          type: StoryType.video,
          timestamp: DateTime.now().subtract(Duration(hours: 1)),
          views: 203,
          duration: Duration(seconds: 15),
        ),
        Story(
          id: '3',
          mediaUrl: 'https://example.com/story3.jpg',
          type: StoryType.image,
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
          caption: 'Coffee time! ☕',
          views: 89,
        ),
      ],
    ),
    StoryUser(
      username: 'bob_builder',
      displayName: 'Bob Builder',
      avatar: 'https://example.com/avatar4.jpg',
      stories: [
        Story(
          id: '4',
          mediaUrl: 'https://example.com/story4.jpg',
          type: StoryType.image,
          timestamp: DateTime.now().subtract(Duration(hours: 3)),
          caption: 'New project! 🏗️',
          views: 234,
        ),
        Story(
          id: '5',
          mediaUrl: 'https://example.com/story5.mp4',
          type: StoryType.video,
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          views: 167,
          duration: Duration(seconds: 12),
        ),
      ],
    ),
    StoryUser(
      username: 'charlie_brown',
      displayName: 'Charlie Brown',
      avatar: 'https://example.com/avatar5.jpg',
      stories: [
        Story(
          id: '6',
          mediaUrl: 'https://example.com/story6.jpg',
          type: StoryType.image,
          timestamp: DateTime.now().subtract(Duration(hours: 4)),
          caption: 'Weekend vibes! 🎉',
          views: 342,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(seconds: 5), // Default duration for image stories
      vsync: this,
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    // Find user if username is provided
    if (widget.username != null) {
      final userIndex = storyUsers.indexWhere((user) => user.username == widget.username);
      if (userIndex != -1) {
        currentUserIndex = userIndex;
      }
    }

    _startStoryTimer();
  }

  void _startStoryTimer() {
    if (!isPaused) {
      final currentStory = storyUsers[currentUserIndex].stories[currentStoryIndex];

      if (currentStory.type == StoryType.video && currentStory.duration != null) {
        _progressController.duration = currentStory.duration;
      } else {
        _progressController.duration = Duration(seconds: 5);
      }

      _progressController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = storyUsers[currentUserIndex];
    final currentStory = currentUser.stories[currentStoryIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        onLongPressStart: (_) => _pauseStory(),
        onLongPressEnd: (_) => _resumeStory(),
        child: Stack(
          children: [
            // Story content
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentUserIndex = index;
                  currentStoryIndex = 0;
                });
                _startStoryTimer();
              },
              itemCount: storyUsers.length,
              itemBuilder: (context, userIndex) {
                return _buildStoryContent(storyUsers[userIndex].stories[currentStoryIndex]);
              },
            ),
            // Progress bars
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: List.generate(
                    currentUser.stories.length,
                    (index) => Expanded(
                      child: Container(
                        height: 3,
                        margin: EdgeInsets.symmetric(horizontal: 1),
                        child: LinearProgressIndicator(
                          value: index < currentStoryIndex
                              ? 1.0
                              : index == currentStoryIndex
                                  ? _progressController.value
                                  : 0.0,
                          backgroundColor: Colors.white30,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // User info header
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(currentUser.avatar),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentUser.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formatTimestamp(currentStory.timestamp),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(isPaused ? Icons.play_arrow : Icons.pause, color: Colors.white),
                      onPressed: isPaused ? _resumeStory : _pauseStory,
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      color: Colors.white,
                      onSelected: _handleStoryAction,
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'mute', child: Text('Mute')),
                        PopupMenuItem(value: 'report', child: Text('Report')),
                        PopupMenuItem(value: 'share', child: Text('Share')),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
            // Story caption
            if (currentStory.caption != null)
              Positioned(
                bottom: 100,
                left: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    currentStory.caption!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            // Bottom actions
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: _buildBottomActions(currentStory),
              ),
            ),
            // Video play button (if paused)
            if (currentStory.type == StoryType.video && isPaused)
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent(Story story) {
    if (story.type == StoryType.video) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
                  story.mediaUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
                          SizedBox(height: 16),
                          Text('Video Story', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 64,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.network(
          story.mediaUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 64, color: Colors.white),
                  SizedBox(height: 16),
                  Text('Image Story', style: TextStyle(color: Colors.white)),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildBottomActions(Story story) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // Reply input
          Expanded(
            child: Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Reply to ${storyUsers[currentUserIndex].username}...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (text) => _sendReply(text),
                    ),
                  ),
                  Icon(Icons.emoji_emotions_outlined, color: Colors.white70),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          // Like button
          GestureDetector(
            onTap: () => _likeStory(story),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12),
          // Share button
          GestureDetector(
            onTap: () => _shareStory(story),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStory() {
    final currentUser = storyUsers[currentUserIndex];

    if (currentStoryIndex < currentUser.stories.length - 1) {
      setState(() {
        currentStoryIndex++;
      });
      _startStoryTimer();
    } else {
      // Move to next user
      if (currentUserIndex < storyUsers.length - 1) {
        setState(() {
          currentUserIndex++;
          currentStoryIndex = 0;
        });
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // End of stories
        Navigator.pop(context);
      }
    }
  }

  void _previousStory() {
    if (currentStoryIndex > 0) {
      setState(() {
        currentStoryIndex--;
      });
      _startStoryTimer();
    } else {
      // Move to previous user
      if (currentUserIndex > 0) {
        setState(() {
          currentUserIndex--;
          currentStoryIndex = storyUsers[currentUserIndex].stories.length - 1;
        });
        _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _pauseStory() {
    setState(() {
      isPaused = true;
    });
    _progressController.stop();
  }

  void _resumeStory() {
    setState(() {
      isPaused = false;
    });
    _progressController.forward();
  }

  void _sendReply(String text) {
    if (text.trim().isNotEmpty) {
      // Send reply to story owner
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reply sent to ${storyUsers[currentUserIndex].username}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _likeStory(Story story) {
    // Like the story
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked ${storyUsers[currentUserIndex].username}\'s story'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _shareStory(Story story) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text('Send to friends'),
                onTap: () {
                  Navigator.pop(context);
                  _showShareToFriends();
                },
              ),
              ListTile(
                leading: Icon(Icons.add_to_photos),
                title: Text('Add to story'),
                onTap: () {
                  Navigator.pop(context);
                  _addToMyStory(story);
                },
              ),
              ListTile(
                leading: Icon(Icons.copy),
                title: Text('Copy link'),
                onTap: () {
                  Navigator.pop(context);
                  _copyStoryLink(story);
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showShareToFriends() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Send to',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search friends...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Sample friends
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage('https://example.com/friend$index.jpg'),
                      ),
                      title: Text('Friend $index'),
                      subtitle: Text('@friend_$index'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Story shared with Friend $index')),
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
  }

  void _addToMyStory(Story story) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to your story')),
    );
  }

  void _copyStoryLink(Story story) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Story link copied to clipboard')),
    );
  }

  void _handleStoryAction(String action) {
    switch (action) {
      case 'mute':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${storyUsers[currentUserIndex].username} muted')),
        );
        break;
      case 'report':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Story reported')),
        );
        break;
      case 'share':
        _shareStory(storyUsers[currentUserIndex].stories[currentStoryIndex]);
        break;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}

enum StoryType {
  image,
  video,
}

class Story {
  final String id;
  final String mediaUrl;
  final StoryType type;
  final DateTime timestamp;
  final String? caption;
  final int views;
  final Duration? duration;

  Story({
    required this.id,
    required this.mediaUrl,
    required this.type,
    required this.timestamp,
    this.caption,
    required this.views,
    this.duration,
  });
}

class StoryUser {
  final String username;
  final String displayName;
  final String avatar;
  final List<Story> stories;

  StoryUser({
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.stories,
  });
}