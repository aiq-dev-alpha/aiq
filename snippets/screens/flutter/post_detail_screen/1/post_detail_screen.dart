import 'package:flutter/material.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [
    Comment(
      id: '1',
      username: 'alice_wonder',
      avatar: 'https://example.com/avatar3.jpg',
      text: 'Amazing shot! 📸',
      timeAgo: '1h',
      likes: 5,
    ),
    Comment(
      id: '2',
      username: 'bob_builder',
      avatar: 'https://example.com/avatar4.jpg',
      text: 'Love the colors in this photo',
      timeAgo: '30m',
      likes: 2,
    ),
    Comment(
      id: '3',
      username: 'charlie_brown',
      avatar: 'https://example.com/avatar5.jpg',
      text: 'Where was this taken?',
      timeAgo: '15m',
      likes: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _sharePost,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original Post
                  _buildPostHeader(),
                  _buildPostImage(),
                  _buildPostActions(),
                  _buildPostDetails(),
                  Divider(thickness: 1),
                  // Comments Section
                  _buildCommentsSection(),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.post.userAvatar),
      ),
      title: Text(
        widget.post.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(widget.post.timeAgo),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(child: Text('Report'), value: 'report'),
          PopupMenuItem(child: Text('Block User'), value: 'block'),
          PopupMenuItem(child: Text('Copy Link'), value: 'copy'),
        ],
        onSelected: (value) {
          _handleMenuAction(value);
        },
      ),
    );
  }

  Widget _buildPostImage() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Image.network(
        widget.post.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(Icons.image, size: 50, color: Colors.grey),
          );
        },
      ),
    );
  }

  Widget _buildPostActions() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
              color: widget.post.isLiked ? Colors.red : null,
            ),
            onPressed: _toggleLike,
          ),
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: () {
              // Scroll to comment input
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _sharePost,
          ),
          Spacer(),
          Icon(Icons.bookmark_border),
        ],
      ),
    );
  }

  Widget _buildPostDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.post.likes} likes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: widget.post.username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' ${widget.post.caption}'),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Comments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return _buildCommentItem(comments[index]);
          },
        ),
      ],
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(comment.avatar),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: comment.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${comment.text}'),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      comment.timeAgo,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _likeComment(comment),
                      child: Text(
                        '${comment.likes} likes',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _replyToComment(comment),
                      child: Text(
                        'Reply',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, size: 16),
            onPressed: () => _likeComment(comment),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://example.com/current_user_avatar.jpg'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: _postComment,
          ),
        ],
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      widget.post.isLiked = !widget.post.isLiked;
      widget.post.likes += widget.post.isLiked ? 1 : -1;
    });
  }

  void _sharePost() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post shared!')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'report':
        _showReportDialog();
        break;
      case 'block':
        _showBlockDialog();
        break;
      case 'copy':
        _copyPostLink();
        break;
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Post'),
        content: Text('Why are you reporting this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post reported')),
              );
            },
            child: Text('Report'),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block User'),
        content: Text('Are you sure you want to block ${widget.post.username}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User blocked')),
              );
            },
            child: Text('Block'),
          ),
        ],
      ),
    );
  }

  void _copyPostLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post link copied to clipboard')),
    );
  }

  void _likeComment(Comment comment) {
    setState(() {
      comment.likes += 1;
    });
  }

  void _replyToComment(Comment comment) {
    _commentController.text = '@${comment.username} ';
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _postComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        comments.insert(0, Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          username: 'current_user',
          avatar: 'https://example.com/current_user_avatar.jpg',
          text: _commentController.text.trim(),
          timeAgo: 'now',
          likes: 0,
        ));
      });
      _commentController.clear();
    }
  }
}

class Comment {
  final String id;
  final String username;
  final String avatar;
  final String text;
  final String timeAgo;
  int likes;

  Comment({
    required this.id,
    required this.username,
    required this.avatar,
    required this.text,
    required this.timeAgo,
    required this.likes,
  });
}

// Reusing Post class from feed_screen.dart
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