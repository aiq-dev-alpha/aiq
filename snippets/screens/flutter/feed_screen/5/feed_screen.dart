import 'package:flutter/material.dart';

abstract class FeedStyler {
  Color get backgroundColor;
  Color get postBackground;
  Widget buildPost(Post post);
  Widget buildHeader(String author, DateTime time);
  Widget buildActions(int likes, int comments, int shares);
}

class CardBasedFeedStyle implements FeedStyler {
  @override
  Color get backgroundColor => const Color(0xFFFAFAFA);

  @override
  Color get postBackground => Colors.white;

  @override
  Widget buildPost(Post post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: postBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(post.author, post.createdAt),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(post.content, style: const TextStyle(fontSize: 15)),
          ),
          buildActions(post.likesCount, post.commentsCount, post.sharesCount),
        ],
      ),
    );
  }

  @override
  Widget buildHeader(String author, DateTime time) {
    return ListTile(
      leading: CircleAvatar(child: Text(author[0])),
      title: Text(author, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(_timeAgo(time), style: const TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget buildActions(int likes, int comments, int shares) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAction(Icons.favorite_border, likes),
          _buildAction(Icons.mode_comment_outlined, comments),
          _buildAction(Icons.share_outlined, shares),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(count.toString(), style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class FeedScreen extends StatelessWidget {
  final FeedStyler styler;
  final List<Post> posts;

  const FeedScreen({
    Key? key,
    FeedStyler? styler,
    List<Post>? posts,
  })  : styler = styler ?? const CardBasedFeedStyle(),
        posts = posts ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedPosts = posts.isEmpty ? _generatePosts() : posts;

    return Scaffold(
      backgroundColor: styler.backgroundColor,
      appBar: AppBar(
        title: const Text('Feed'),
        elevation: 0,
        backgroundColor: styler.backgroundColor,
        foregroundColor: Colors.black87,
      ),
      body: ListView.builder(
        itemCount: feedPosts.length,
        itemBuilder: (context, index) => styler.buildPost(feedPosts[index]),
      ),
    );
  }

  List<Post> _generatePosts() {
    return List.generate(
      15,
      (i) => Post(
        id: '$i',
        author: 'User ${i + 1}',
        content: 'Post content ${i + 1}',
        createdAt: DateTime.now().subtract(Duration(hours: i)),
        likesCount: i * 12,
        commentsCount: i * 3,
        sharesCount: i,
      ),
    );
  }
}

class Post {
  final String id;
  final String author;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;

  Post({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
  });
}
