import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ArticleContent {
  final String type; // 'text', 'image', 'quote', 'video'
  final String content;
  final String? caption;
  final String? imageUrl;

  ArticleContent({
    required this.type,
    required this.content,
    this.caption,
    this.imageUrl,
  });
}

class Article {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final String author;
  final DateTime publishDate;
  final int readTime;
  final List<String> tags;
  final List<ArticleContent> content;

  Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.author,
    required this.publishDate,
    required this.readTime,
    required this.tags,
    required this.content,
  });
}

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isBookmarked = false;
  bool _isLiked = false;
  double _readingProgress = 0.0;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateReadingProgress);
    _checkBookmarkStatus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateReadingProgress() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _readingProgress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
      });
    }
  }

  void _checkBookmarkStatus() {
    // Simulate checking bookmark status
    setState(() {
      _isBookmarked = false; // Load from storage
    });
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Article bookmarked' : 'Bookmark removed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    HapticFeedback.lightImpact();
  }

  void _shareArticle() {
    Share.share(
      '${widget.article.title}\n\nRead more at: https://example.com/article/${widget.article.id}',
      subject: widget.article.title,
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Aa', style: TextStyle(fontSize: _fontSize)),
            Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 12,
              label: _fontSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                  onPressed: _toggleBookmark,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: _shareArticle,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'article_image_${widget.article.id}',
                child: Image.network(
                  widget.article.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
              ),
            ),
          ),

          // Reading Progress Bar
          SliverToBoxAdapter(
            child: Container(
              height: 4,
              child: LinearProgressIndicator(
                value: _readingProgress,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          // Article Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Wrap(
                    spacing: 8,
                    children: widget.article.tags.map((tag) => Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 12),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    )).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    widget.article.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Author Info and Metadata
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          widget.article.author[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.article.author,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${_formatDate(widget.article.publishDate)} • ${widget.article.readTime} min read',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.text_fields),
                        onPressed: _showFontSizeDialog,
                        tooltip: 'Font Size',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Article Summary
                  Text(
                    widget.article.summary,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      height: 1.6,
                      fontSize: _fontSize + 2,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Article Content
                  ...widget.article.content.map((content) => _buildContentBlock(content)),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                        label: 'Like',
                        isActive: _isLiked,
                        onTap: _toggleLike,
                        color: Colors.red,
                      ),
                      _ActionButton(
                        icon: Icons.comment_outlined,
                        label: 'Comment',
                        onTap: () => _showComments(context),
                      ),
                      _ActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onTap: _shareArticle,
                      ),
                      _ActionButton(
                        icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        label: 'Save',
                        isActive: _isBookmarked,
                        onTap: _toggleBookmark,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Related Articles Section
                  Text(
                    'Related Articles',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) => _RelatedArticleCard(
                        title: 'Related Article ${index + 1}',
                        imageUrl: 'https://picsum.photos/200/120?random=${index + 100}',
                        readTime: 3 + (index % 5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBlock(ArticleContent content) {
    switch (content.type) {
      case 'text':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            content.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.8,
              fontSize: _fontSize,
            ),
            textAlign: TextAlign.justify,
          ),
        );

      case 'image':
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  content.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              if (content.caption != null) ...[
                const SizedBox(height: 8),
                Text(
                  content.caption!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        );

      case 'quote':
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                ),
              ),
            ),
            child: Text(
              content.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: _fontSize + 2,
                height: 1.6,
              ),
            ),
          ),
        );

      default:
        return const SizedBox();
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Comments',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: List.generate(10, (index) => _CommentCard(index: index)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive ? activeColor : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelatedArticleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int readTime;

  const _RelatedArticleCard({
    required this.title,
    required this.imageUrl,
    required this.readTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '$readTime min read',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final int index;

  const _CommentCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final authors = ['Alice Johnson', 'Bob Smith', 'Carol White', 'David Brown'];
    final author = authors[index % authors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              author[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      author,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '2h ago',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'This is a great article! I really enjoyed reading about this topic and learned a lot from it.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Sample data for testing
final sampleArticle = Article(
  id: 'sample_1',
  title: 'The Future of Artificial Intelligence: Transforming Industries and Society',
  summary: 'Explore how AI is revolutionizing various sectors and what it means for our future.',
  imageUrl: 'https://picsum.photos/400/250?random=1',
  author: 'Tech Journalist',
  publishDate: DateTime.now().subtract(const Duration(hours: 6)),
  readTime: 8,
  tags: ['Technology', 'AI', 'Future'],
  content: [
    ArticleContent(
      type: 'text',
      content: 'Artificial Intelligence (AI) has emerged as one of the most transformative technologies of our time. From healthcare to transportation, finance to entertainment, AI is reshaping industries and redefining what\'s possible.',
    ),
    ArticleContent(
      type: 'image',
      imageUrl: 'https://picsum.photos/600/300?random=2',
      caption: 'AI systems processing data in a modern datacenter',
    ),
    ArticleContent(
      type: 'text',
      content: 'The rapid advancement in machine learning algorithms, coupled with unprecedented computing power and vast datasets, has enabled AI systems to achieve human-level performance in many specialized tasks.',
    ),
    ArticleContent(
      type: 'quote',
      content: '"AI is not about replacing humans, but augmenting human capabilities to achieve things we never thought possible." - Leading AI Researcher',
    ),
    ArticleContent(
      type: 'text',
      content: 'As we look toward the future, it\'s clear that AI will continue to play an increasingly important role in our daily lives. The key is ensuring that this technology is developed and deployed responsibly, with careful consideration of its impact on society.',
    ),
  ],
);