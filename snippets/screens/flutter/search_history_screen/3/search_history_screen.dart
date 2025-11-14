import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchHistoryItem {
  final String id;
  final String query;
  final DateTime timestamp;
  final int resultCount;
  final String? category;
  final List<String> filters;

  SearchHistoryItem({
    required this.id,
    required this.query,
    required this.timestamp,
    this.resultCount = 0,
    this.category,
    this.filters = const [],
  });
}

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({super.key});

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  List<SearchHistoryItem> _searchHistory = [];
  List<SearchHistoryItem> _filteredHistory = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _selectedTimeFilter = 'all';
  bool _isSelectionMode = false;
  final Set<String> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchController.addListener(_filterHistory);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSearchHistory() async {
    setState(() => _isLoading = true);

    // Simulate loading from local storage/database
    await Future.delayed(const Duration(milliseconds: 500));

    final mockHistory = _generateMockHistory();

    setState(() {
      _searchHistory = mockHistory;
      _filteredHistory = mockHistory;
      _isLoading = false;
    });
  }

  List<SearchHistoryItem> _generateMockHistory() {
    final queries = [
      'Flutter tutorials',
      'Dart programming',
      'Mobile app development',
      'UI/UX design',
      'State management',
      'API integration',
      'Database design',
      'Authentication',
      'Push notifications',
      'App deployment',
      'Performance optimization',
      'Widget testing',
      'Clean architecture',
      'Responsive design',
      'Dark mode implementation',
    ];

    final categories = ['Development', 'Design', 'Architecture', 'Testing'];

    return List.generate(25, (index) {
      final daysAgo = index * 2 + (index % 3);
      return SearchHistoryItem(
        id: 'search_$index',
        query: queries[index % queries.length],
        timestamp: DateTime.now().subtract(Duration(days: daysAgo)),
        resultCount: 50 + (index * 15),
        category: categories[index % categories.length],
        filters: index % 3 == 0
            ? ['Electronics', 'Popular']
            : index % 4 == 0
                ? ['Recent', 'Trending']
                : [],
      );
    });
  }

  void _filterHistory() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHistory = _searchHistory.where((item) {
        final matchesSearch = item.query.toLowerCase().contains(query);
        final matchesTimeFilter = _matchesTimeFilter(item);
        return matchesSearch && matchesTimeFilter;
      }).toList();
    });
  }

  bool _matchesTimeFilter(SearchHistoryItem item) {
    final now = DateTime.now();
    switch (_selectedTimeFilter) {
      case 'today':
        return item.timestamp.isAfter(DateTime(now.year, now.month, now.day));
      case 'week':
        return item.timestamp.isAfter(now.subtract(const Duration(days: 7)));
      case 'month':
        return item.timestamp.isAfter(now.subtract(const Duration(days: 30)));
      default:
        return true;
    }
  }

  void _performSearch(String query) {
    Navigator.pushNamed(
      context,
      '/search-results',
      arguments: {'query': query},
    );
  }

  void _deleteHistoryItem(String id) {
    setState(() {
      _searchHistory.removeWhere((item) => item.id == id);
      _filteredHistory.removeWhere((item) => item.id == id);
    });
    // In a real app, you would also remove from persistent storage
    _showSnackBar('Search removed from history');
  }

  void _deleteSelectedItems() {
    setState(() {
      _searchHistory.removeWhere((item) => _selectedItems.contains(item.id));
      _filteredHistory.removeWhere((item) => _selectedItems.contains(item.id));
      _selectedItems.clear();
      _isSelectionMode = false;
    });
    _showSnackBar('${_selectedItems.length} items removed');
  }

  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Search History'),
        content: const Text('Are you sure you want to clear all search history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _searchHistory.clear();
                _filteredHistory.clear();
              });
              Navigator.pop(context);
              _showSnackBar('Search history cleared');
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(String id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
      } else {
        _selectedItems.add(id);
      }
    });
  }

  String _getRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedItems.length} selected')
            : const Text('Search History'),
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleSelectionMode,
              )
            : null,
        actions: [
          if (_isSelectionMode) ...[
            if (_selectedItems.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteSelectedItems,
              ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: _toggleSelectionMode,
              tooltip: 'Select items',
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'clear_all':
                    _clearAllHistory();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all, size: 20),
                      SizedBox(width: 8),
                      Text('Clear All History'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search in history...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterHistory();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),

          // Time Filter Chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTimeFilterChip('All time', 'all'),
                _buildTimeFilterChip('Today', 'today'),
                _buildTimeFilterChip('This week', 'week'),
                _buildTimeFilterChip('This month', 'month'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredHistory.isEmpty
                    ? _buildEmptyState()
                    : _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilterChip(String label, String value) {
    final isSelected = _selectedTimeFilter == value;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedTimeFilter = value;
            _filterHistory();
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'No matching searches found'
                : 'No search history',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'Try different keywords'
                : 'Your recent searches will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    // Group by date
    final groupedHistory = <String, List<SearchHistoryItem>>{};
    for (final item in _filteredHistory) {
      final now = DateTime.now();
      final itemDate = item.timestamp;
      String groupKey;

      if (itemDate.isAfter(DateTime(now.year, now.month, now.day))) {
        groupKey = 'Today';
      } else if (itemDate.isAfter(DateTime(now.year, now.month, now.day - 1))) {
        groupKey = 'Yesterday';
      } else if (itemDate.isAfter(now.subtract(const Duration(days: 7)))) {
        groupKey = 'This week';
      } else if (itemDate.isAfter(now.subtract(const Duration(days: 30)))) {
        groupKey = 'This month';
      } else {
        groupKey = 'Older';
      }

      groupedHistory.putIfAbsent(groupKey, () => []).add(item);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedHistory.length * 2, // Headers + items
      itemBuilder: (context, index) {
        final groupKeys = groupedHistory.keys.toList();
        final groupIndex = index ~/ 2;

        if (index % 2 == 0) {
          // Group header
          if (groupIndex >= groupKeys.length) return const SizedBox.shrink();
          final groupKey = groupKeys[groupIndex];
          return _buildGroupHeader(groupKey);
        } else {
          // Group items
          if (groupIndex >= groupKeys.length) return const SizedBox.shrink();
          final groupKey = groupKeys[groupIndex];
          final items = groupedHistory[groupKey]!;
          return Column(
            children: items.map((item) => _buildHistoryItem(item)).toList(),
          );
        }
      },
    );
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(SearchHistoryItem item) {
    final isSelected = _selectedItems.contains(item.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _isSelectionMode
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleItemSelection(item.id),
              )
            : CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.history,
                  color: Theme.of(context).primaryColor,
                ),
              ),
        title: Text(
          item.query,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getRelativeTime(item.timestamp)),
            if (item.category != null || item.filters.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: [
                  if (item.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.category!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ...item.filters.map((filter) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      filter,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )),
                ],
              ),
            ],
          ],
        ),
        trailing: _isSelectionMode
            ? null
            : PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'copy':
                      Clipboard.setData(ClipboardData(text: item.query));
                      _showSnackBar('Query copied to clipboard');
                      break;
                    case 'delete':
                      _deleteHistoryItem(item.id);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy',
                    child: Row(
                      children: [
                        Icon(Icons.copy, size: 20),
                        SizedBox(width: 8),
                        Text('Copy'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
        onTap: _isSelectionMode
            ? () => _toggleItemSelection(item.id)
            : () => _performSearch(item.query),
        selected: isSelected,
      ),
    );
  }
}