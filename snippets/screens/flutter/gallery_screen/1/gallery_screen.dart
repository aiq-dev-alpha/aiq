import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoItem {
  final String id;
  final String url;
  final String thumbnailUrl;
  final String title;
  final String description;
  final DateTime dateTaken;
  final String location;
  final List<String> tags;
  final bool isVideo;
  final Duration? videoDuration;

  PhotoItem({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.dateTaken,
    required this.location,
    required this.tags,
    this.isVideo = false,
    this.videoDuration,
  });
}

class Album {
  final String id;
  final String name;
  final String coverUrl;
  final List<PhotoItem> photos;
  final DateTime createdAt;

  Album({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.photos,
    required this.createdAt,
  });
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<PhotoItem> _allPhotos = [];
  List<PhotoItem> _filteredPhotos = [];
  List<Album> _albums = [];
  bool _isLoading = true;
  bool _isGridView = true;
  bool _isSelectionMode = false;
  final Set<String> _selectedItems = {};
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Photos', 'Videos', 'Recent', 'Favorites'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadContent();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreContent();
    }
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    // Generate sample photos
    final photos = List.generate(50, (index) => PhotoItem(
      id: 'photo_$index',
      url: 'https://picsum.photos/800/600?random=$index',
      thumbnailUrl: 'https://picsum.photos/200/200?random=$index',
      title: 'Photo ${index + 1}',
      description: 'Beautiful photo captured on a wonderful day',
      dateTaken: DateTime.now().subtract(Duration(days: index)),
      location: ['New York', 'Paris', 'Tokyo', 'London', 'Sydney'][index % 5],
      tags: [
        ['nature', 'landscape'],
        ['portrait', 'people'],
        ['urban', 'architecture'],
        ['sunset', 'golden hour'],
        ['travel', 'adventure']
      ][index % 5],
      isVideo: index % 7 == 0,
      videoDuration: index % 7 == 0 ? Duration(seconds: 30 + (index % 120)) : null,
    ));

    // Generate sample albums
    final albums = List.generate(8, (index) => Album(
      id: 'album_$index',
      name: ['Vacation 2024', 'Family Photos', 'Nature Collection', 'Urban Life',
             'Portraits', 'Travel Memories', 'Sunset Collection', 'Daily Life'][index],
      coverUrl: 'https://picsum.photos/300/300?random=${index + 100}',
      photos: photos.skip(index * 6).take(6 + (index % 4)).toList(),
      createdAt: DateTime.now().subtract(Duration(days: index * 7)),
    ));

    setState(() {
      _allPhotos = photos;
      _filteredPhotos = photos;
      _albums = albums;
      _isLoading = false;
    });
  }

  Future<void> _loadMoreContent() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final morePhotos = List.generate(20, (index) => PhotoItem(
      id: 'photo_${_allPhotos.length + index}',
      url: 'https://picsum.photos/800/600?random=${_allPhotos.length + index}',
      thumbnailUrl: 'https://picsum.photos/200/200?random=${_allPhotos.length + index}',
      title: 'Photo ${_allPhotos.length + index + 1}',
      description: 'Another beautiful captured moment',
      dateTaken: DateTime.now().subtract(Duration(days: _allPhotos.length + index)),
      location: ['New York', 'Paris', 'Tokyo', 'London', 'Sydney'][index % 5],
      tags: [
        ['nature', 'landscape'],
        ['portrait', 'people'],
        ['urban', 'architecture']
      ][index % 3],
      isVideo: index % 8 == 0,
      videoDuration: index % 8 == 0 ? Duration(seconds: 45 + (index % 90)) : null,
    ));

    setState(() {
      _allPhotos.addAll(morePhotos);
      _filterPhotos();
    });
  }

  void _filterPhotos() {
    setState(() {
      _filteredPhotos = _allPhotos.where((photo) {
        // Apply search filter
        final matchesSearch = _searchController.text.isEmpty ||
            photo.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            photo.tags.any((tag) => tag.toLowerCase().contains(_searchController.text.toLowerCase()));

        // Apply type filter
        final matchesFilter = _selectedFilter == 'All' ||
            (_selectedFilter == 'Photos' && !photo.isVideo) ||
            (_selectedFilter == 'Videos' && photo.isVideo) ||
            (_selectedFilter == 'Recent' && photo.dateTaken.isAfter(DateTime.now().subtract(const Duration(days: 7)))) ||
            (_selectedFilter == 'Favorites'); // Would check favorites in real app

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(String itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  void _openPhotoViewer(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewScreen(
          photos: _filteredPhotos,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  void _openAlbum(Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlbumDetailScreen(album: album),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedItems.length} selected')
            : const Text('Gallery'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleSelectionMode,
              )
            : null,
        actions: _isSelectionMode
            ? [
                if (_selectedItems.isNotEmpty) ...[
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _shareSelectedItems,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteSelectedItems,
                  ),
                ],
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _showSearchDialog,
                ),
                IconButton(
                  icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: () {
                    setState(() {
                      _isGridView = !_isGridView;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: _toggleSelectionMode,
                ),
              ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Photos', icon: Icon(Icons.photo)),
            Tab(text: 'Albums', icon: Icon(Icons.photo_album)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          if (_tabController.index == 0)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                        _filterPhotos();
                      },
                    ),
                  );
                },
              ),
            ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPhotosTab(),
                _buildAlbumsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContentDialog,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildPhotosTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredPhotos.isEmpty) {
      return _buildEmptyState();
    }

    return _isGridView ? _buildPhotoGrid() : _buildPhotoList();
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: _filteredPhotos.length,
      itemBuilder: (context, index) {
        final photo = _filteredPhotos[index];
        final isSelected = _selectedItems.contains(photo.id);

        return GestureDetector(
          onTap: _isSelectionMode
              ? () => _toggleItemSelection(photo.id)
              : () => _openPhotoViewer(index),
          onLongPress: () {
            if (!_isSelectionMode) {
              _toggleSelectionMode();
            }
            _toggleItemSelection(photo.id);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                photo.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Icon(Icons.broken_image),
                ),
              ),
              // Video indicator
              if (photo.isVideo)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white, size: 12),
                        if (photo.videoDuration != null) ...[
                          const SizedBox(width: 2),
                          Text(
                            _formatDuration(photo.videoDuration!),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              // Selection overlay
              if (_isSelectionMode)
                Container(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                      : Colors.black.withOpacity(0.2),
                  child: Center(
                    child: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Colors.white : Colors.white70,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _filteredPhotos.length,
      itemBuilder: (context, index) {
        final photo = _filteredPhotos[index];
        final isSelected = _selectedItems.contains(photo.id);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    photo.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              if (photo.isVideo)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white.withOpacity(0.9),
                    size: 16,
                  ),
                ),
              if (_isSelectionMode)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    size: 20,
                  ),
                ),
            ],
          ),
          title: Text(
            photo.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_formatDate(photo.dateTaken)} • ${photo.location}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (photo.tags.isNotEmpty)
                Text(
                  photo.tags.join(', '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
          onTap: _isSelectionMode
              ? () => _toggleItemSelection(photo.id)
              : () => _openPhotoViewer(index),
          onLongPress: () {
            if (!_isSelectionMode) {
              _toggleSelectionMode();
            }
            _toggleItemSelection(photo.id);
          },
          selected: isSelected,
        );
      },
    );
  }

  Widget _buildAlbumsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final album = _albums[index];
        return _AlbumCard(
          album: album,
          onTap: () => _openAlbum(album),
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
            Icons.photo_library_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No photos found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Photos'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by title or tags...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            Navigator.pop(context);
            _filterPhotos();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              Navigator.pop(context);
              _filterPhotos();
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _filterPhotos();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showAddContentDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () {
                Navigator.pop(context);
                _recordVideo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _chooseFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareSelectedItems() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${_selectedItems.length} items')),
    );
  }

  void _deleteSelectedItems() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Items'),
        content: Text('Are you sure you want to delete ${_selectedItems.length} selected item(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allPhotos.removeWhere((photo) => _selectedItems.contains(photo.id));
                _filteredPhotos.removeWhere((photo) => _selectedItems.contains(photo.id));
                _selectedItems.clear();
                _isSelectionMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Items deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _takePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera functionality would be implemented here')),
    );
  }

  void _recordVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video recording functionality would be implemented here')),
    );
  }

  void _chooseFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery picker functionality would be implemented here')),
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${twoDigits(seconds)}';
  }
}

class _AlbumCard extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;

  const _AlbumCard({
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    album.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.photo_album, size: 32),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${album.photos.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${album.photos.length} items',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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

// Photo Viewer Screen
class PhotoViewScreen extends StatefulWidget {
  final List<PhotoItem> photos;
  final int initialIndex;

  const PhotoViewScreen({
    Key? key,
    required this.photos,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: widget.photos.length,
            builder: (context, index) {
              final photo = widget.photos[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(photo.url),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(tag: photo.id),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          GestureDetector(
            onTap: _toggleControls,
            behavior: HitTestBehavior.translucent,
            child: Container(),
          ),
          if (_showControls) ...[
            // Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        '${_currentIndex + 1} of ${widget.photos.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () => _showPhotoOptions(widget.photos[_currentIndex]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.photos[_currentIndex].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.photos[_currentIndex].description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.photos[_currentIndex].description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.photos[_currentIndex].location,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(widget.photos[_currentIndex].dateTaken),
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPhotoOptions(PhotoItem photo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title: const Text('Share', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.download, color: Colors.white),
                title: const Text('Save to Device', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text('Edit', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: const Text('Photo Info', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Album Detail Screen
class AlbumDetailScreen extends StatelessWidget {
  final Album album;

  const AlbumDetailScreen({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: album.photos.length,
        itemBuilder: (context, index) {
          final photo = album.photos[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewScreen(
                  photos: album.photos,
                  initialIndex: index,
                ),
              ),
            ),
            child: Image.network(
              photo.thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const Icon(Icons.broken_image),
              ),
            ),
          );
        },
      ),
    );
  }
}