import 'package:flutter/material.dart';

class SearchResult {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final double? price;
  final double? rating;
  final int? reviewCount;
  final String? category;
  final List<String> tags;
  final DateTime? dateAdded;
  final String? author;
  final String? source;

  SearchResult({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.price,
    this.rating,
    this.reviewCount,
    this.category,
    this.tags = const [],
    this.dateAdded,
    this.author,
    this.source,
  });
}

class SearchResultsScreen extends StatefulWidget {
  final String? query;
  final Map<String, dynamic>? filters;

  const SearchResultsScreen({super.key, this.query, this.filters});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<SearchResult> _results = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreResults = true;
  String _currentQuery = '';
  Map<String, dynamic> _currentFilters = {};
  String _sortBy = 'relevance';
  bool _isGridView = false;

  int _totalResults = 0;
  int _currentPage = 1;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query ?? '';
    _currentFilters = widget.filters ?? {};
    _searchController.text = _currentQuery;
    _scrollController.addListener(_onScroll);
    _performSearch();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreResults();
    }
  }

  Future<void> _performSearch({bool isNewSearch = true}) async {
    if (isNewSearch) {
      setState(() {
        _results = [];
        _currentPage = 1;
        _isLoading = true;
        _hasMoreResults = true;
      });
    }

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      final newResults = _generateMockResults();
      setState(() {
        if (isNewSearch) {
          _results = newResults;
          _totalResults = 157; // Mock total
        } else {
          _results.addAll(newResults);
        }
        _isLoading = false;
        _isLoadingMore = false;
        _hasMoreResults = _results.length < _totalResults;
      });
    }
  }

  Future<void> _loadMoreResults() async {
    if (_isLoadingMore || !_hasMoreResults) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    await _performSearch(isNewSearch: false);
  }

  List<SearchResult> _generateMockResults() {
    return List.generate(20, (index) {
      final baseIndex = (_currentPage - 1) * _pageSize + index;
      return SearchResult(
        id: 'result_$baseIndex',
        title: 'Search Result ${baseIndex + 1} - $_currentQuery',
        description: 'This is a detailed description for search result ${baseIndex + 1}. It contains relevant information about $_currentQuery and provides useful context for the user.',
        imageUrl: 'https://picsum.photos/300/200?random=$baseIndex',
        price: (baseIndex % 5 == 0) ? 29.99 + (baseIndex * 2.5) : null,
        rating: 3.0 + (baseIndex % 3),
        reviewCount: 50 + (baseIndex * 12),
        category: ['Electronics', 'Books', 'Clothing', 'Home'][baseIndex % 4],
        tags: ['Popular', 'New', 'Featured'].take((baseIndex % 3) + 1).toList(),
        dateAdded: DateTime.now().subtract(Duration(days: baseIndex)),
        author: 'Author ${baseIndex % 10}',
        source: 'Source ${baseIndex % 5}',
      );
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterScreen(initialFilters: _currentFilters),
    ).then((filters) {
      if (filters != null) {
        setState(() => _currentFilters = filters);
        _performSearch();
      }
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SortScreen(currentSort: _getSortOption()),
    ).then((result) {
      if (result != null) {
        setState(() => _sortBy = result['sortOption'].toString());
        _performSearch();
      }
    });
  }

  dynamic _getSortOption() {
    // Convert string to SortOption enum
    return _sortBy; // Simplified for this example
  }

  String _highlightText(String text, String query) {
    if (query.isEmpty) return text;
    final regex = RegExp(query, caseSensitive: false);
    return text.replaceAllMapped(regex, (match) => '**${match.group(0)}**');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onSubmitted: (query) {
            setState(() => _currentQuery = query);
            _performSearch();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Summary and Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isLoading
                            ? 'Searching...'
                            : 'About $_totalResults results for "$_currentQuery"',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _showSortOptions,
                      icon: const Icon(Icons.sort, size: 16),
                      label: Text(_sortBy.toUpperCase()),
                    ),
                  ],
                ),
                if (_currentFilters.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _buildActiveFilters(),
                  ),
                ],
              ],
            ),
          ),

          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? _buildEmptyState()
                    : _isGridView
                        ? _buildGridView()
                        : _buildListView(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveFilters() {
    final filters = <Widget>[];

    _currentFilters.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        if (value is List && (value as List).isNotEmpty) {
          for (final item in value) {
            filters.add(
              Chip(
                label: Text('$key: $item'),
                onDeleted: () {
                  setState(() {
                    (value as List).remove(item);
                    if ((value as List).isEmpty) {
                      _currentFilters.remove(key);
                    }
                  });
                  _performSearch();
                },
                deleteIcon: const Icon(Icons.close, size: 16),
              ),
            );
          }
        } else {
          filters.add(
            Chip(
              label: Text('$key: $value'),
              onDeleted: () {
                setState(() => _currentFilters.remove(key));
                _performSearch();
              },
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
          );
        }
      }
    });

    return filters;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentFilters.clear();
                _currentQuery = '';
                _searchController.clear();
              });
              _performSearch();
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _results.length + (_hasMoreResults ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _results.length) {
          return _buildLoadingIndicator();
        }

        final result = _results[index];
        return _buildListItem(result);
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _results.length + (_hasMoreResults ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _results.length) {
          return _buildLoadingIndicator();
        }

        final result = _results[index];
        return _buildGridItem(result);
      },
    );
  }

  Widget _buildListItem(SearchResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (result.imageUrl != null)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    result.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    result.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    result.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Metadata
                  Row(
                    children: [
                      if (result.rating != null) ...[
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(
                          result.rating!.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (result.category != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            result.category!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (result.price != null)
                        Text(
                          '\$${result.price!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
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

  Widget _buildGridItem(SearchResult result) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[200],
              ),
              child: result.imageUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        result.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image, color: Colors.grey),
                      ),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
          ),

          // Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      if (result.rating != null) ...[
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(
                          result.rating!.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                      ],
                      if (result.price != null)
                        Text(
                          '\$${result.price!.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: _isLoadingMore
          ? const CircularProgressIndicator()
          : const SizedBox.shrink(),
    );
  }
}

// Placeholder classes for navigation
class FilterScreen extends StatelessWidget {
  final Map<String, dynamic>? initialFilters;

  const FilterScreen({super.key, this.initialFilters});

  @override
  Widget build(BuildContext context) {
    // This would be implemented in filter_screen.dart
    return Container();
  }
}

class SortScreen extends StatelessWidget {
  final dynamic currentSort;

  const SortScreen({super.key, this.currentSort});

  @override
  Widget build(BuildContext context) {
    // This would be implemented in sort_screen.dart
    return Container();
  }
}