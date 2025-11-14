import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Article {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final String author;
  final DateTime publishDate;
  final int readTime;
  final List<String> tags;

  Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.author,
    required this.publishDate,
    required this.readTime,
    required this.tags,
  });
}

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({Key? key}) : super(key: key);

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Technology', 'Business', 'Sports', 'Health'];

  @override
  void initState() {
    super.initState();
    _loadArticles();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreArticles();
    }
  }

  Future<void> _loadArticles() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final articles = List.generate(20, (index) => Article(
      id: 'article_$index',
      title: 'Breaking News: Technology Advances in ${2024 + index % 3}',
      summary: 'This is a comprehensive summary of the latest developments in technology and innovation that are shaping our future...',
      imageUrl: 'https://picsum.photos/400/250?random=$index',
      author: ['John Doe', 'Jane Smith', 'Tech Reporter'][index % 3],
      publishDate: DateTime.now().subtract(Duration(days: index)),
      readTime: 3 + (index % 8),
      tags: [
        ['Technology', 'Innovation'],
        ['Business', 'Finance'],
        ['Sports', 'News'],
        ['Health', 'Wellness']
      ][index % 4],
    ));

    setState(() {
      _articles = articles;
      _filteredArticles = articles;
      _isLoading = false;
    });
  }

  Future<void> _loadMoreArticles() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final newArticles = List.generate(10, (index) => Article(
      id: 'article_${_articles.length + index}',
      title: 'Additional Article ${_articles.length + index + 1}',
      summary: 'More exciting content for our readers to explore and discover...',
      imageUrl: 'https://picsum.photos/400/250?random=${_articles.length + index}',
      author: ['John Doe', 'Jane Smith', 'Tech Reporter'][index % 3],
      publishDate: DateTime.now().subtract(Duration(days: _articles.length + index)),
      readTime: 3 + (index % 8),
      tags: [
        ['Technology', 'Innovation'],
        ['Business', 'Finance'],
        ['Sports', 'News'],
        ['Health', 'Wellness']
      ][index % 4],
    ));

    setState(() {
      _articles.addAll(newArticles);
      _filterArticles();
      _isLoadingMore = false;
    });
  }

  void _filterArticles() {
    setState(() {
      _filteredArticles = _articles.where((article) {
        final matchesSearch = article.title.toLowerCase()
            .contains(_searchController.text.toLowerCase()) ||
            article.summary.toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesCategory = _selectedCategory == 'All' ||
            article.tags.contains(_selectedCategory);

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _refreshArticles() async {
    setState(() {
      _isLoading = true;
      _articles.clear();
      _filteredArticles.clear();
    });
    await _loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => Navigator.pushNamed(context, '/bookmarks'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterArticles();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              onChanged: (value) => _filterArticles(),
            ),
          ),

          // Category Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _filterArticles();
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Articles List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refreshArticles,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredArticles.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _filteredArticles.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final article = _filteredArticles[index];
                        return _ArticleCard(
                          article: article,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/article-detail',
                            arguments: article,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const _ArticleCard({
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Wrap(
                    spacing: 8,
                    children: article.tags.map((tag) => Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 12),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    )).toList(),
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Summary
                  Text(
                    article.summary,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Metadata
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          article.author[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        article.author,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${article.readTime} min read',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(article.publishDate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}