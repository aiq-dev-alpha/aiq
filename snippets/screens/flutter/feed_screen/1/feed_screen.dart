import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Post> posts = [
    Post(
      id: '1',
      username: 'john_doe',
      userAvatar: 'https://example.com/avatar1.jpg',
      imageUrl: 'https://example.com/post1.jpg',
      caption: 'Beautiful sunset at the beach! 🌅',
      likes: 156,
      comments: 23,
      timeAgo: '2h',
      isLiked: false,
    ),
    Post(
      id: '2',
      username: 'jane_smith',
      userAvatar: 'https://example.com/avatar2.jpg',
      imageUrl: 'https://example.com/post2.jpg',
      caption: 'Morning coffee and coding session ☕️💻',
      likes: 89,
      comments: 12,
      timeAgo: '4h',
      isLiked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SocialApp', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => Navigator.pushNamed(context, '/messages'),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(
              post: posts[index],
              onLike: () => _toggleLike(index),
              onComment: () => _navigateToComments(posts[index]),
              onShare: () => _sharePost(posts[index]),
              onUserTap: () => _navigateToProfile(posts[index].username),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-post'),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<void> _refreshFeed() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Add new posts or refresh existing ones
    });
  }

  void _toggleLike(int index) {
    setState(() {
      posts[index].isLiked = !posts[index].isLiked;
      posts[index].likes += posts[index].isLiked ? 1 : -1;
    });
  }

  void _navigateToComments(Post post) {
    Navigator.pushNamed(context, '/post-detail', arguments: post);
  }

  void _sharePost(Post post) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share functionality would be implemented here')),
    );
  }

  void _navigateToProfile(String username) {
    Navigator.pushNamed(context, '/user-profile', arguments: username);
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onUserTap;

  const PostCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: GestureDetector(
              onTap: onUserTap,
              child: CircleAvatar(
                backgroundImage: NetworkImage(post.userAvatar),
              ),
            ),
            title: GestureDetector(
              onTap: onUserTap,
              child: Text(
                post.username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Text(post.timeAgo),
            trailing: Icon(Icons.more_vert),
          ),
          // Image
          AspectRatio(
            aspectRatio: 1.0,
            child: Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
          // Actions
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : null,
                  ),
                  onPressed: onLike,
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: onComment,
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: onShare,
                ),
                Spacer(),
                Icon(Icons.bookmark_border),
              ],
            ),
          ),
          // Likes and caption
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${post.likes} likes', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: post.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${post.caption}'),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                GestureDetector(
                  onTap: onComment,
                  child: Text(
                    'View all ${post.comments} comments',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Post {
  final String id;
  final String username;
  final String userAvatar;
  final String imageUrl;
  final String caption;
  int likes;
  final int comments;
  final String timeAgo;
  bool isLiked;

  Post({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    required this.isLiked,
  });
}