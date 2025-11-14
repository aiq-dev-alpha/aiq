import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final Duration duration;
  final String author;
  final String authorAvatarUrl;
  final int views;
  final DateTime uploadDate;
  final String category;
  final bool isLive;

  VideoItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.author,
    required this.authorAvatarUrl,
    required this.views,
    required this.uploadDate,
    required this.category,
    this.isLive = false,
  });
}

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  List<VideoItem> _videos = [];
  List<VideoItem> _filteredVideos = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _isGridView = false;

  final List<String> _categories = [
    'All',
    'Trending',
    'Music',
    'Gaming',
    'Sports',
    'News',
    'Technology',
    'Education'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadVideos();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreVideos();
    }
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final videos = List.generate(30, (index) => VideoItem(
      id: 'video_$index',
      title: _generateVideoTitle(index),
      thumbnailUrl: 'https://picsum.photos/400/225?random=$index',
      duration: Duration(
        minutes: 2 + (index % 20),
        seconds: index % 60,
      ),
      author: _getAuthorName(index),
      authorAvatarUrl: 'https://i.pravatar.cc/100?img=${index % 50}',
      views: (index + 1) * 1000 + (index * 123),
      uploadDate: DateTime.now().subtract(Duration(
        days: index % 30,
        hours: index % 24,
      )),
      category: _categories[(index % (_categories.length - 1)) + 1],
      isLive: index % 15 == 0,
    ));

    setState(() {
      _videos = videos;
      _filteredVideos = videos;
      _isLoading = false;
    });
  }

  Future<void> _loadMoreVideos() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final newVideos = List.generate(15, (index) => VideoItem(
      id: 'video_${_videos.length + index}',
      title: _generateVideoTitle(_videos.length + index),
      thumbnailUrl: 'https://picsum.photos/400/225?random=${_videos.length + index}',
      duration: Duration(
        minutes: 2 + (index % 20),
        seconds: index % 60,
      ),
      author: _getAuthorName(index),
      authorAvatarUrl: 'https://i.pravatar.cc/100?img=${(index + 20) % 50}',
      views: (index + 1) * 1000 + (index * 123),
      uploadDate: DateTime.now().subtract(Duration(
        days: index % 30,
        hours: index % 24,
      )),
      category: _categories[(index % (_categories.length - 1)) + 1],
      isLive: index % 15 == 0,
    ));

    setState(() {
      _videos.addAll(newVideos);
      _filterVideos();
      _isLoadingMore = false;
    });
  }

  void _filterVideos() {
    final selectedCategory = _categories[_tabController.index];
    final searchQuery = _searchController.text.toLowerCase();

    setState(() {
      _filteredVideos = _videos.where((video) {
        final matchesCategory = selectedCategory == 'All' || video.category == selectedCategory;
        final matchesSearch = searchQuery.isEmpty ||
            video.title.toLowerCase().contains(searchQuery) ||
            video.author.toLowerCase().contains(searchQuery);

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _refreshVideos() async {
    setState(() {
      _isLoading = true;
      _videos.clear();
      _filteredVideos.clear();
    });
    await _loadVideos();
  }

  String _generateVideoTitle(int index) {
    final titles = [
      'Amazing Technology Demo',
      'Top 10 Programming Tips',
      'Live Coding Session',
      'Flutter Development Tutorial',
      'Mobile App Design Principles',
      'Advanced Animation Techniques',
      'State Management Best Practices',
      'Performance Optimization Guide',
      'UI/UX Design Trends 2024',
      'Building Scalable Applications',
    ];
    return '${titles[index % titles.length]} - Part ${(index ~/ titles.length) + 1}';
  }

  String _getAuthorName(int index) {
    final authors = [
      'TechGuru',
      'CodeMaster',
      'DevChannel',
      'AppAcademy',
      'DigitalCreator',
      'TechReviews',
    ];
    return authors[index % authors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: _categories.map((category) => Tab(text: category)).toList(),
            onTap: (index) => _filterVideos(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar (visible when searching)
          if (_searchController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Search results for "${_searchController.text}"',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      _filterVideos();
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),

          // Video List/Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refreshVideos,
                    child: _filteredVideos.isEmpty
                        ? _buildEmptyState()
                        : _isGridView
                            ? _buildGridView()
                            : _buildListView(),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUploadDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _filteredVideos.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _filteredVideos.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final video = _filteredVideos[index];
        return _VideoListCard(
          video: video,
          onTap: () => _playVideo(video),
          onLongPress: () => _showVideoOptions(video),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _filteredVideos.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _filteredVideos.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final video = _filteredVideos[index];
        return _VideoGridCard(
          video: video,
          onTap: () => _playVideo(video),
          onLongPress: () => _showVideoOptions(video),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No videos found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else or check back later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Videos'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter search terms...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            Navigator.pop(context);
            _filterVideos();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _filterVideos();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _playVideo(VideoItem video) {
    // Navigate to video player
    Navigator.pushNamed(
      context,
      '/video-player',
      arguments: video,
    );
  }

  void _showVideoOptions(VideoItem video) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Play'),
              onTap: () {
                Navigator.pop(context);
                _playVideo(video);
              },
            ),
            ListTile(
              leading: const Icon(Icons.watch_later),
              title: const Text('Watch Later'),
              onTap: () {
                Navigator.pop(context);
                _addToWatchLater(video);
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showPlaylistDialog(video);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _shareVideo(video);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                _reportVideo(video);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Video'),
        content: const Text('Upload video functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement video upload
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _addToWatchLater(VideoItem video) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${video.title}" to Watch Later'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPlaylistDialog(VideoItem video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Create New Playlist'),
              leading: const Icon(Icons.add),
              onTap: () {
                Navigator.pop(context);
                // Implement playlist creation
              },
            ),
            const Divider(),
            ...['My Favorites', 'Tech Videos', 'Tutorials'].map(
              (playlist) => ListTile(
                title: Text(playlist),
                leading: const Icon(Icons.playlist_play),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to $playlist'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareVideo(VideoItem video) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _reportVideo(VideoItem video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Video'),
        content: const Text('Please select a reason for reporting this video.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video reported successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }
}

class _VideoListCard extends StatelessWidget {
  final VideoItem video;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _VideoListCard({
    required this.video,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.play_circle_outline,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                // Duration badge
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatDuration(video.duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Live badge
                if (video.isLive)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Video Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(video.authorAvatarUrl),
                        onBackgroundImageError: (error, stackTrace) {},
                        child: const Icon(Icons.person, size: 12),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          video.author,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatViews(video.views)} views • ${_formatDate(video.uploadDate)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // More options
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onLongPress,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${twoDigits(seconds)}';
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}

class _VideoGridCard extends StatelessWidget {
  final VideoItem video;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _VideoGridCard({
    required this.video,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.play_circle_outline, size: 32),
                    ),
                  ),
                  // Duration badge
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatDuration(video.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Live badge
                  if (video.isLive)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Video Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundImage: NetworkImage(video.authorAvatarUrl),
                          onBackgroundImageError: (error, stackTrace) {},
                          child: const Icon(Icons.person, size: 10),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            video.author,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '${_formatViews(video.views)} views',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${twoDigits(seconds)}';
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }
}