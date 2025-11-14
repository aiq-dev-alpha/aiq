import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BookmarkType { article, video, audio, image, pdf, website }

class BookmarkItem {
  final String id;
  final String title;
  final String description;
  final String url;
  final String thumbnailUrl;
  final BookmarkType type;
  final DateTime createdAt;
  final DateTime lastAccessed;
  final List<String> tags;
  final String? author;
  final Duration? duration; // for video/audio
  final int? pages; // for PDF
  final bool isOfflineAvailable;

  BookmarkItem({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.thumbnailUrl,
    required this.type,
    required this.createdAt,
    required this.lastAccessed,
    required this.tags,
    this.author,
    this.duration,
    this.pages,
    this.isOfflineAvailable = false,
  });
}

class BookmarkFolder {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<BookmarkItem> bookmarks;

  BookmarkFolder({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.bookmarks,
  });
}

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<BookmarkItem> _allBookmarks = [];
  List<BookmarkItem> _filteredBookmarks = [];
  List<BookmarkFolder> _folders = [];
  bool _isLoading = true;
  bool _isSelectionMode = false;
  bool _isGridView = false;
  final Set<String> _selectedItems = {};
  String _selectedFilter = 'All';
  String _sortBy = 'Recent';

  final List<String> _filters = ['All', 'Articles', 'Videos', 'Audio', 'Images', 'PDFs', 'Websites'];
  final List<String> _sortOptions = ['Recent', 'Alphabetical', 'Type', 'Date Added'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookmarks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    // Generate sample bookmarks
    final bookmarks = List.generate(30, (index) {
      final types = BookmarkType.values;
      final type = types[index % types.length];

      return BookmarkItem(
        id: 'bookmark_$index',
        title: _generateTitle(type, index),
        description: _generateDescription(type),
        url: 'https://example.com/content/$index',
        thumbnailUrl: 'https://picsum.photos/200/200?random=$index',
        type: type,
        createdAt: DateTime.now().subtract(Duration(days: index)),
        lastAccessed: DateTime.now().subtract(Duration(hours: index * 2)),
        tags: _generateTags(type),
        author: _generateAuthor(index),
        duration: type == BookmarkType.video || type == BookmarkType.audio
            ? Duration(minutes: 5 + (index % 30))
            : null,
        pages: type == BookmarkType.pdf ? 10 + (index % 50) : null,
        isOfflineAvailable: index % 4 == 0,
      );
    });

    // Generate sample folders
    final folders = [
      BookmarkFolder(
        id: 'folder_1',
        name: 'Work',
        icon: Icons.work,
        color: Colors.blue,
        bookmarks: bookmarks.take(8).toList(),
      ),
      BookmarkFolder(
        id: 'folder_2',
        name: 'Learning',
        icon: Icons.school,
        color: Colors.green,
        bookmarks: bookmarks.skip(8).take(6).toList(),
      ),
      BookmarkFolder(
        id: 'folder_3',
        name: 'Entertainment',
        icon: Icons.movie,
        color: Colors.purple,
        bookmarks: bookmarks.skip(14).take(5).toList(),
      ),
      BookmarkFolder(
        id: 'folder_4',
        name: 'News',
        icon: Icons.newspaper,
        color: Colors.red,
        bookmarks: bookmarks.skip(19).take(4).toList(),
      ),
    ];

    setState(() {
      _allBookmarks = bookmarks;
      _filteredBookmarks = bookmarks;
      _folders = folders;
      _isLoading = false;
    });
  }

  void _filterAndSortBookmarks() {
    setState(() {
      // Apply search filter
      var filtered = _allBookmarks.where((bookmark) {
        final matchesSearch = _searchController.text.isEmpty ||
            bookmark.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            bookmark.description.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            bookmark.tags.any((tag) => tag.toLowerCase().contains(_searchController.text.toLowerCase()));

        // Apply type filter
        final matchesFilter = _selectedFilter == 'All' ||
            (_selectedFilter == 'Articles' && bookmark.type == BookmarkType.article) ||
            (_selectedFilter == 'Videos' && bookmark.type == BookmarkType.video) ||
            (_selectedFilter == 'Audio' && bookmark.type == BookmarkType.audio) ||
            (_selectedFilter == 'Images' && bookmark.type == BookmarkType.image) ||
            (_selectedFilter == 'PDFs' && bookmark.type == BookmarkType.pdf) ||
            (_selectedFilter == 'Websites' && bookmark.type == BookmarkType.website);

        return matchesSearch && matchesFilter;
      }).toList();

      // Apply sorting
      switch (_sortBy) {
        case 'Recent':
          filtered.sort((a, b) => b.lastAccessed.compareTo(a.lastAccessed));
          break;
        case 'Alphabetical':
          filtered.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Type':
          filtered.sort((a, b) => a.type.name.compareTo(b.type.name));
          break;
        case 'Date Added':
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }

      _filteredBookmarks = filtered;
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

  void _openBookmark(BookmarkItem bookmark) {
    // Update last accessed time
    bookmark.lastAccessed.add(Duration.zero);

    // Navigate to appropriate viewer
    switch (bookmark.type) {
      case BookmarkType.article:
        Navigator.pushNamed(context, '/article-detail', arguments: bookmark);
        break;
      case BookmarkType.video:
        Navigator.pushNamed(context, '/video-player', arguments: bookmark);
        break;
      case BookmarkType.audio:
        Navigator.pushNamed(context, '/audio-player', arguments: bookmark);
        break;
      case BookmarkType.image:
        Navigator.pushNamed(context, '/image-viewer', arguments: bookmark);
        break;
      case BookmarkType.pdf:
        Navigator.pushNamed(context, '/pdf-viewer', arguments: bookmark);
        break;
      case BookmarkType.website:
        // Open web browser
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedItems.length} selected')
            : const Text('Bookmarks'),
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
                    icon: const Icon(Icons.folder),
                    onPressed: _moveToFolder,
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _shareSelected,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteSelected,
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
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'select') {
                      _toggleSelectionMode();
                    } else if (value == 'sort') {
                      _showSortDialog();
                    } else if (value == 'sync') {
                      _syncBookmarks();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'select',
                      child: ListTile(
                        leading: Icon(Icons.select_all),
                        title: Text('Select'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'sort',
                      child: ListTile(
                        leading: Icon(Icons.sort),
                        title: Text('Sort'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'sync',
                      child: ListTile(
                        leading: Icon(Icons.sync),
                        title: Text('Sync'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Bookmarks', icon: Icon(Icons.bookmark)),
            Tab(text: 'Folders', icon: Icon(Icons.folder)),
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
                        _filterAndSortBookmarks();
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
                _buildBookmarksTab(),
                _buildFoldersTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookmarkDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBookmarksTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredBookmarks.isEmpty) {
      return _buildEmptyState();
    }

    return _isGridView ? _buildBookmarkGrid() : _buildBookmarkList();
  }

  Widget _buildBookmarkList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _filteredBookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = _filteredBookmarks[index];
        final isSelected = _selectedItems.contains(bookmark.id);

        return _BookmarkListItem(
          bookmark: bookmark,
          isSelected: isSelected,
          isSelectionMode: _isSelectionMode,
          onTap: _isSelectionMode
              ? () => _toggleItemSelection(bookmark.id)
              : () => _openBookmark(bookmark),
          onLongPress: () {
            if (!_isSelectionMode) {
              _toggleSelectionMode();
            }
            _toggleItemSelection(bookmark.id);
          },
          onOptionsPressed: () => _showBookmarkOptions(bookmark),
        );
      },
    );
  }

  Widget _buildBookmarkGrid() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredBookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = _filteredBookmarks[index];
        final isSelected = _selectedItems.contains(bookmark.id);

        return _BookmarkGridItem(
          bookmark: bookmark,
          isSelected: isSelected,
          isSelectionMode: _isSelectionMode,
          onTap: _isSelectionMode
              ? () => _toggleItemSelection(bookmark.id)
              : () => _openBookmark(bookmark),
          onLongPress: () {
            if (!_isSelectionMode) {
              _toggleSelectionMode();
            }
            _toggleItemSelection(bookmark.id);
          },
        );
      },
    );
  }

  Widget _buildFoldersTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _folders.length,
      itemBuilder: (context, index) {
        final folder = _folders[index];
        return _FolderCard(
          folder: folder,
          onTap: () => _openFolder(folder),
          onOptionsPressed: () => _showFolderOptions(folder),
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
            Icons.bookmark_border,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No bookmarks found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start saving your favorite content',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddBookmarkDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Bookmark'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Bookmarks'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by title, description, or tags...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            Navigator.pop(context);
            _filterAndSortBookmarks();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              Navigator.pop(context);
              _filterAndSortBookmarks();
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _filterAndSortBookmarks();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Bookmarks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _sortOptions
              .map((option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                      Navigator.pop(context);
                      _filterAndSortBookmarks();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showAddBookmarkDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddBookmarkDialog(),
    );
  }

  void _showBookmarkOptions(BookmarkItem bookmark) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Open'),
              onTap: () {
                Navigator.pop(context);
                _openBookmark(bookmark);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editBookmark(bookmark);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Move to Folder'),
              onTap: () {
                Navigator.pop(context);
                _showMoveToFolderDialog([bookmark.id]);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _shareBookmark(bookmark);
              },
            ),
            ListTile(
              leading: Icon(
                bookmark.isOfflineAvailable ? Icons.cloud_off : Icons.cloud_download,
              ),
              title: Text(bookmark.isOfflineAvailable ? 'Remove Offline' : 'Save Offline'),
              onTap: () {
                Navigator.pop(context);
                _toggleOfflineAvailability(bookmark);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteBookmark(bookmark);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFolderOptions(BookmarkFolder folder) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                _renameFolder(folder);
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Change Color'),
              onTap: () {
                Navigator.pop(context);
                _changeFolderColor(folder);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteFolder(folder);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openFolder(BookmarkFolder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderDetailScreen(folder: folder),
      ),
    );
  }

  void _moveToFolder() {
    _showMoveToFolderDialog(_selectedItems.toList());
  }

  void _showMoveToFolderDialog(List<String> bookmarkIds) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move to Folder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Create New Folder'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ..._folders.map((folder) => ListTile(
              leading: Icon(folder.icon, color: folder.color),
              title: Text(folder.name),
              onTap: () {
                Navigator.pop(context);
                // Move bookmarks to folder
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Moved to ${folder.name}')),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  void _shareSelected() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${_selectedItems.length} bookmarks')),
    );
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bookmarks'),
        content: Text('Are you sure you want to delete ${_selectedItems.length} bookmark(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allBookmarks.removeWhere((b) => _selectedItems.contains(b.id));
                _filteredBookmarks.removeWhere((b) => _selectedItems.contains(b.id));
                _selectedItems.clear();
                _isSelectionMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmarks deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _syncBookmarks() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Syncing bookmarks...')),
    );
  }

  void _editBookmark(BookmarkItem bookmark) {
    // Show edit dialog
  }

  void _shareBookmark(BookmarkItem bookmark) {
    // Share bookmark
  }

  void _toggleOfflineAvailability(BookmarkItem bookmark) {
    // Toggle offline availability
  }

  void _deleteBookmark(BookmarkItem bookmark) {
    // Delete bookmark
  }

  void _renameFolder(BookmarkFolder folder) {
    // Rename folder
  }

  void _changeFolderColor(BookmarkFolder folder) {
    // Change folder color
  }

  void _deleteFolder(BookmarkFolder folder) {
    // Delete folder
  }

  String _generateTitle(BookmarkType type, int index) {
    switch (type) {
      case BookmarkType.article:
        return 'Interesting Article ${index + 1}';
      case BookmarkType.video:
        return 'Must Watch Video ${index + 1}';
      case BookmarkType.audio:
        return 'Great Podcast ${index + 1}';
      case BookmarkType.image:
        return 'Beautiful Image ${index + 1}';
      case BookmarkType.pdf:
        return 'Important Document ${index + 1}';
      case BookmarkType.website:
        return 'Useful Website ${index + 1}';
    }
  }

  String _generateDescription(BookmarkType type) {
    switch (type) {
      case BookmarkType.article:
        return 'A fascinating article about technology and innovation';
      case BookmarkType.video:
        return 'An informative video covering important topics';
      case BookmarkType.audio:
        return 'An engaging podcast episode with expert insights';
      case BookmarkType.image:
        return 'A stunning photograph worth saving';
      case BookmarkType.pdf:
        return 'An important document for future reference';
      case BookmarkType.website:
        return 'A useful website with valuable resources';
    }
  }

  List<String> _generateTags(BookmarkType type) {
    switch (type) {
      case BookmarkType.article:
        return ['tech', 'news', 'innovation'];
      case BookmarkType.video:
        return ['tutorial', 'educational', 'entertainment'];
      case BookmarkType.audio:
        return ['podcast', 'interview', 'music'];
      case BookmarkType.image:
        return ['photography', 'art', 'inspiration'];
      case BookmarkType.pdf:
        return ['document', 'reference', 'work'];
      case BookmarkType.website:
        return ['resource', 'tool', 'utility'];
    }
  }

  String _generateAuthor(int index) {
    final authors = ['John Doe', 'Jane Smith', 'Tech Blogger', 'Content Creator', 'Expert Writer'];
    return authors[index % authors.length];
  }
}

// Additional widget classes would be defined here...
class _BookmarkListItem extends StatelessWidget {
  final BookmarkItem bookmark;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onOptionsPressed;

  const _BookmarkListItem({
    required this.bookmark,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                bookmark.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  _getTypeIcon(bookmark.type),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          if (bookmark.isOfflineAvailable)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.offline_pin,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          if (isSelectionMode)
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                size: 20,
              ),
            ),
        ],
      ),
      title: Text(
        bookmark.title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bookmark.author != null) ...[
            Text(
              'by ${bookmark.author}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
          ],
          Text(
            bookmark.description,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                _getTypeIcon(bookmark.type),
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                _formatTypeText(bookmark.type, bookmark),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _formatDate(bookmark.lastAccessed),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: isSelectionMode
          ? null
          : IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onOptionsPressed,
            ),
      onTap: onTap,
      onLongPress: onLongPress,
      selected: isSelected,
    );
  }

  IconData _getTypeIcon(BookmarkType type) {
    switch (type) {
      case BookmarkType.article:
        return Icons.article;
      case BookmarkType.video:
        return Icons.play_circle;
      case BookmarkType.audio:
        return Icons.audio_file;
      case BookmarkType.image:
        return Icons.image;
      case BookmarkType.pdf:
        return Icons.picture_as_pdf;
      case BookmarkType.website:
        return Icons.web;
    }
  }

  String _formatTypeText(BookmarkType type, BookmarkItem bookmark) {
    switch (type) {
      case BookmarkType.article:
        return 'Article';
      case BookmarkType.video:
        return bookmark.duration != null ? _formatDuration(bookmark.duration!) : 'Video';
      case BookmarkType.audio:
        return bookmark.duration != null ? _formatDuration(bookmark.duration!) : 'Audio';
      case BookmarkType.image:
        return 'Image';
      case BookmarkType.pdf:
        return bookmark.pages != null ? '${bookmark.pages} pages' : 'PDF';
      case BookmarkType.website:
        return 'Website';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _BookmarkGridItem extends StatelessWidget {
  final BookmarkItem bookmark;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _BookmarkGridItem({
    required this.bookmark,
    required this.isSelected,
    required this.isSelectionMode,
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
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    bookmark.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Icon(
                        _getTypeIcon(bookmark.type),
                        size: 32,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (bookmark.isOfflineAvailable)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.offline_pin,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  if (isSelectionMode)
                    Container(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                          : Colors.black.withOpacity(0.2),
                      child: Center(
                        child: Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? Colors.white : Colors.white70,
                          size: 32,
                        ),
                      ),
                    ),
                ],
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
                      bookmark.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (bookmark.author != null)
                      Text(
                        'by ${bookmark.author}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          _getTypeIcon(bookmark.type),
                          size: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatTypeText(bookmark.type, bookmark),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  IconData _getTypeIcon(BookmarkType type) {
    switch (type) {
      case BookmarkType.article:
        return Icons.article;
      case BookmarkType.video:
        return Icons.play_circle;
      case BookmarkType.audio:
        return Icons.audio_file;
      case BookmarkType.image:
        return Icons.image;
      case BookmarkType.pdf:
        return Icons.picture_as_pdf;
      case BookmarkType.website:
        return Icons.web;
    }
  }

  String _formatTypeText(BookmarkType type, BookmarkItem bookmark) {
    switch (type) {
      case BookmarkType.article:
        return 'Article';
      case BookmarkType.video:
        return bookmark.duration != null ? _formatDuration(bookmark.duration!) : 'Video';
      case BookmarkType.audio:
        return bookmark.duration != null ? _formatDuration(bookmark.duration!) : 'Audio';
      case BookmarkType.image:
        return 'Image';
      case BookmarkType.pdf:
        return bookmark.pages != null ? '${bookmark.pages} pages' : 'PDF';
      case BookmarkType.website:
        return 'Website';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    return '${minutes}m';
  }
}

class _FolderCard extends StatelessWidget {
  final BookmarkFolder folder;
  final VoidCallback onTap;
  final VoidCallback onOptionsPressed;

  const _FolderCard({
    required this.folder,
    required this.onTap,
    required this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: folder.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  folder.icon,
                  color: folder.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folder.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${folder.bookmarks.length} bookmarks',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: onOptionsPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddBookmarkDialog extends StatelessWidget {
  const AddBookmarkDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Bookmark'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'URL',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Title (optional)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class FolderDetailScreen extends StatelessWidget {
  final BookmarkFolder folder;

  const FolderDetailScreen({Key? key, required this.folder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
        backgroundColor: folder.color,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: folder.bookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = folder.bookmarks[index];
          return _BookmarkListItem(
            bookmark: bookmark,
            isSelected: false,
            isSelectionMode: false,
            onTap: () {},
            onLongPress: () {},
            onOptionsPressed: () {},
          );
        },
      ),
    );
  }
}