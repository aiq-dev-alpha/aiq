import 'package:flutter/material.dart';

class FeedThemeConfig {
  final Color backgroundColor;
  final Color cardColor;
  final Color accentColor;
  final double itemSpacing;
  final bool showAvatars;

  const FeedThemeConfig({
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.cardColor = Colors.white,
    this.accentColor = const Color(0xFF2196F3),
    this.itemSpacing = 12.0,
    this.showAvatars = true,
  });
}

class FeedScreen extends StatelessWidget {
  final FeedThemeConfig? theme;
  final List<FeedPost>? posts;

  const FeedScreen({
    Key? key,
    this.theme,
    this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const FeedThemeConfig();
    final feedPosts = posts ?? _defaultPosts();

    return Scaffold(
      backgroundColor: effectiveTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Feed'),
        backgroundColor: effectiveTheme.accentColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.separated(
          padding: EdgeInsets.all(effectiveTheme.itemSpacing),
          itemCount: feedPosts.length,
          separatorBuilder: (_, __) => SizedBox(height: effectiveTheme.itemSpacing),
          itemBuilder: (context, index) => _FeedPostCard(
            post: feedPosts[index],
            theme: effectiveTheme,
          ),
        ),
      ),
    );
  }

  List<FeedPost> _defaultPosts() {
    return List.generate(
      10,
      (i) => FeedPost(
        id: 'post_$i',
        author: 'User ${i + 1}',
        content: 'This is post number ${i + 1}',
        timestamp: DateTime.now().subtract(Duration(hours: i)),
        likes: i * 10,
        comments: i * 5,
      ),
    );
  }
}

class _FeedPostCard extends StatelessWidget {
  final FeedPost post;
  final FeedThemeConfig theme;

  const _FeedPostCard({required this.post, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.cardColor,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (theme.showAvatars)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.accentColor,
                child: Text(post.author[0]),
              ),
              title: Text(post.author, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(_formatTime(post.timestamp)),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(post.content, style: const TextStyle(fontSize: 15)),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                _ActionButton(
                  icon: Icons.favorite_border,
                  label: post.likes.toString(),
                  color: theme.accentColor,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.comment_outlined,
                  label: post.comments.toString(),
                  color: theme.accentColor,
                ),
                const Spacer(),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: theme.accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class FeedPost {
  final String id;
  final String author;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int comments;

  FeedPost({
    required this.id,
    required this.author,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });
}
