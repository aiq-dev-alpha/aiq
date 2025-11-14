import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;

  const UserProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFollowing = false;
  bool isCurrentUser = false;

  final UserProfile userProfile = UserProfile(
    username: 'john_doe',
    displayName: 'John Doe',
    bio: 'Photographer 📸 | Travel enthusiast ✈️ | Coffee lover ☕️\nCapturing moments around the world',
    avatar: 'https://example.com/avatar1.jpg',
    postsCount: 127,
    followersCount: 1524,
    followingCount: 892,
    isVerified: true,
    website: 'www.johndoe.photography',
  );

  final List<Post> userPosts = [
    Post(
      id: '1',
      imageUrl: 'https://example.com/post1.jpg',
      caption: 'Beautiful sunset',
      likes: 156,
      comments: 23,
    ),
    Post(
      id: '2',
      imageUrl: 'https://example.com/post2.jpg',
      caption: 'Morning coffee',
      likes: 89,
      comments: 12,
    ),
    Post(
      id: '3',
      imageUrl: 'https://example.com/post3.jpg',
      caption: 'City lights',
      likes: 234,
      comments: 45,
    ),
    Post(
      id: '4',
      imageUrl: 'https://example.com/post4.jpg',
      caption: 'Mountain view',
      likes: 312,
      comments: 67,
    ),
    Post(
      id: '5',
      imageUrl: 'https://example.com/post5.jpg',
      caption: 'Beach day',
      likes: 198,
      comments: 34,
    ),
    Post(
      id: '6',
      imageUrl: 'https://example.com/post6.jpg',
      caption: 'Street art',
      likes: 156,
      comments: 28,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isCurrentUser = widget.username == 'current_user';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              userProfile.username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (userProfile.isVerified)
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.verified, color: Colors.blue, size: 20),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          if (isCurrentUser) ...[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: _showOptionsMenu,
            ),
          ] else ...[
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: _showUserOptionsMenu,
            ),
          ],
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  _buildActionButtons(),
                  _buildBio(),
                  _buildHighlights(),
                  _buildTabBar(),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPostsGrid(),
            _buildReelsGrid(),
            _buildTaggedGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile picture
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(userProfile.avatar),
          ),
          SizedBox(width: 20),
          // Stats
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Posts', userProfile.postsCount),
                _buildStatColumn('Followers', userProfile.followersCount),
                _buildStatColumn('Following', userProfile.followingCount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return GestureDetector(
      onTap: () {
        if (label == 'Followers') {
          Navigator.pushNamed(context, '/followers', arguments: widget.username);
        } else if (label == 'Following') {
          Navigator.pushNamed(context, '/following', arguments: widget.username);
        }
      },
      child: Column(
        children: [
          Text(
            _formatCount(count),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (isCurrentUser) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _editProfile,
                child: Text('Edit Profile'),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: _shareProfile,
                child: Text('Share Profile'),
              ),
            ),
          ] else ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _toggleFollow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFollowing ? Colors.grey[300] : Theme.of(context).primaryColor,
                  foregroundColor: isFollowing ? Colors.black : Colors.white,
                ),
                child: Text(isFollowing ? 'Following' : 'Follow'),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: _sendMessage,
                child: Text('Message'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBio() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userProfile.displayName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(userProfile.bio),
          if (userProfile.website.isNotEmpty) ...[
            SizedBox(height: 4),
            GestureDetector(
              onTap: _openWebsite,
              child: Text(
                userProfile.website,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHighlights() {
    final highlights = [
      HighlightStory(id: '1', title: 'Travel', cover: 'https://example.com/highlight1.jpg'),
      HighlightStory(id: '2', title: 'Food', cover: 'https://example.com/highlight2.jpg'),
      HighlightStory(id: '3', title: 'Work', cover: 'https://example.com/highlight3.jpg'),
    ];

    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: highlights.length + (isCurrentUser ? 1 : 0),
        itemBuilder: (context, index) {
          if (isCurrentUser && index == 0) {
            return _buildAddHighlight();
          }
          final highlightIndex = isCurrentUser ? index - 1 : index;
          return _buildHighlightItem(highlights[highlightIndex]);
        },
      ),
    );
  }

  Widget _buildAddHighlight() {
    return Padding(
      padding: EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: _addHighlight,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Icon(Icons.add, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              'New',
              style: TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightItem(HighlightStory highlight) {
    return Padding(
      padding: EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _viewHighlight(highlight),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: ClipOval(
                child: Image.network(
                  highlight.cover,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              highlight.title,
              style: TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.black,
      tabs: [
        Tab(icon: Icon(Icons.grid_on)),
        Tab(icon: Icon(Icons.video_library)),
        Tab(icon: Icon(Icons.person_pin)),
      ],
    );
  }

  Widget _buildPostsGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(2),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _viewPost(userPosts[index]),
          child: Image.network(
            userPosts[index].imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Icon(Icons.image, color: Colors.grey),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReelsGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(2),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: 6, // Sample reels
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: Icon(Icons.play_arrow, size: 30, color: Colors.white),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Row(
                children: [
                  Icon(Icons.play_arrow, color: Colors.white, size: 16),
                  Text(
                    '${(index + 1) * 1000}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaggedGrid() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_pin, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No Photos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            'Photos of you will appear here',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings
                },
              ),
              ListTile(
                leading: Icon(Icons.archive),
                title: Text('Archive'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to archive
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Your Activity'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to activity
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code),
                title: Text('QR Code'),
                onTap: () {
                  Navigator.pop(context);
                  // Show QR code
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUserOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.report),
                title: Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _reportUser();
                },
              ),
              ListTile(
                leading: Icon(Icons.block),
                title: Text('Block'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser();
                },
              ),
              ListTile(
                leading: Icon(Icons.copy),
                title: Text('Copy Profile URL'),
                onTap: () {
                  Navigator.pop(context);
                  _copyProfileUrl();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editProfile() {
    Navigator.pushNamed(context, '/edit-profile');
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile shared')),
    );
  }

  void _toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  void _sendMessage() {
    Navigator.pushNamed(context, '/chat', arguments: widget.username);
  }

  void _openWebsite() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${userProfile.website}')),
    );
  }

  void _addHighlight() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add highlight functionality')),
    );
  }

  void _viewHighlight(HighlightStory highlight) {
    Navigator.pushNamed(context, '/stories', arguments: highlight);
  }

  void _viewPost(Post post) {
    Navigator.pushNamed(context, '/post-detail', arguments: post);
  }

  void _reportUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User reported')),
    );
  }

  void _blockUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User blocked')),
    );
  }

  void _copyProfileUrl() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile URL copied to clipboard')),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class UserProfile {
  final String username;
  final String displayName;
  final String bio;
  final String avatar;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final bool isVerified;
  final String website;

  UserProfile({
    required this.username,
    required this.displayName,
    required this.bio,
    required this.avatar,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.isVerified,
    required this.website,
  });
}

class Post {
  final String id;
  final String imageUrl;
  final String caption;
  final int likes;
  final int comments;

  Post({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
  });
}

class HighlightStory {
  final String id;
  final String title;
  final String cover;

  HighlightStory({
    required this.id,
    required this.title,
    required this.cover,
  });
}