import 'package:flutter/material.dart';

enum SortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  rating,
  newest,
  oldest,
  popularity,
  alphabetical,
  reverseAlphabetical,
  distance,
  mostViewed,
  mostDownloaded,
}

class SortScreen extends StatefulWidget {
  final SortOption? currentSort;

  const SortScreen({super.key, this.currentSort});

  @override
  State<SortScreen> createState() => _SortScreenState();
}

class _SortScreenState extends State<SortScreen> {
  SortOption? _selectedSort;
  bool _ascending = true;

  final Map<SortOption, Map<String, dynamic>> _sortOptions = {
    SortOption.relevance: {
      'title': 'Relevance',
      'subtitle': 'Most relevant results first',
      'icon': Icons.star,
      'hasDirection': false,
    },
    SortOption.priceLowToHigh: {
      'title': 'Price: Low to High',
      'subtitle': 'Cheapest items first',
      'icon': Icons.arrow_upward,
      'hasDirection': false,
    },
    SortOption.priceHighToLow: {
      'title': 'Price: High to Low',
      'subtitle': 'Most expensive items first',
      'icon': Icons.arrow_downward,
      'hasDirection': false,
    },
    SortOption.rating: {
      'title': 'Rating',
      'subtitle': 'Highest rated items first',
      'icon': Icons.star_rate,
      'hasDirection': true,
    },
    SortOption.newest: {
      'title': 'Date Added',
      'subtitle': 'Most recently added',
      'icon': Icons.schedule,
      'hasDirection': true,
    },
    SortOption.popularity: {
      'title': 'Popularity',
      'subtitle': 'Most popular items first',
      'icon': Icons.trending_up,
      'hasDirection': true,
    },
    SortOption.alphabetical: {
      'title': 'Name',
      'subtitle': 'Alphabetical order',
      'icon': Icons.sort_by_alpha,
      'hasDirection': true,
    },
    SortOption.distance: {
      'title': 'Distance',
      'subtitle': 'Nearest locations first',
      'icon': Icons.location_on,
      'hasDirection': true,
    },
    SortOption.mostViewed: {
      'title': 'Most Viewed',
      'subtitle': 'Highest view count first',
      'icon': Icons.visibility,
      'hasDirection': true,
    },
    SortOption.mostDownloaded: {
      'title': 'Most Downloaded',
      'subtitle': 'Highest download count first',
      'icon': Icons.download,
      'hasDirection': true,
    },
  };

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort ?? SortOption.relevance;
  }

  void _applySort() {
    Navigator.pop(context, {
      'sortOption': _selectedSort,
      'ascending': _ascending,
    });
  }

  String _getSortTitle(SortOption option, bool ascending) {
    final optionData = _sortOptions[option]!;
    final title = optionData['title'] as String;

    if (!optionData['hasDirection']) return title;

    switch (option) {
      case SortOption.rating:
        return ascending ? 'Rating: Low to High' : 'Rating: High to Low';
      case SortOption.newest:
        return ascending ? 'Date: Oldest First' : 'Date: Newest First';
      case SortOption.popularity:
        return ascending ? 'Popularity: Low to High' : 'Popularity: High to Low';
      case SortOption.alphabetical:
        return ascending ? 'Name: A to Z' : 'Name: Z to A';
      case SortOption.distance:
        return ascending ? 'Distance: Near to Far' : 'Distance: Far to Near';
      case SortOption.mostViewed:
        return ascending ? 'Views: Low to High' : 'Views: High to Low';
      case SortOption.mostDownloaded:
        return ascending ? 'Downloads: Low to High' : 'Downloads: High to Low';
      default:
        return title;
    }
  }

  String _getSortSubtitle(SortOption option, bool ascending) {
    final optionData = _sortOptions[option]!;
    if (!optionData['hasDirection']) return optionData['subtitle'] as String;

    switch (option) {
      case SortOption.rating:
        return ascending ? 'Lowest rated first' : 'Highest rated first';
      case SortOption.newest:
        return ascending ? 'Oldest items first' : 'Newest items first';
      case SortOption.popularity:
        return ascending ? 'Least popular first' : 'Most popular first';
      case SortOption.alphabetical:
        return ascending ? 'A to Z order' : 'Z to A order';
      case SortOption.distance:
        return ascending ? 'Closest locations first' : 'Farthest locations first';
      case SortOption.mostViewed:
        return ascending ? 'Lowest views first' : 'Highest views first';
      case SortOption.mostDownloaded:
        return ascending ? 'Lowest downloads first' : 'Highest downloads first';
      default:
        return optionData['subtitle'] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sort Options'),
        actions: [
          TextButton(
            onPressed: _applySort,
            child: const Text('Apply'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Current Selection Summary
          if (_selectedSort != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Sort',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getSortTitle(_selectedSort!, _ascending),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getSortSubtitle(_selectedSort!, _ascending),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

          // Sort Options List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Quick Sort Options
                _buildSectionHeader('Quick Sort'),
                _buildSortTile(SortOption.relevance),
                _buildSortTile(SortOption.priceLowToHigh),
                _buildSortTile(SortOption.priceHighToLow),
                _buildSortTile(SortOption.rating),

                const Divider(height: 32),

                // Date & Popularity
                _buildSectionHeader('Date & Popularity'),
                _buildSortTile(SortOption.newest),
                _buildSortTile(SortOption.popularity),
                _buildSortTile(SortOption.mostViewed),
                _buildSortTile(SortOption.mostDownloaded),

                const Divider(height: 32),

                // Alphabetical & Location
                _buildSectionHeader('Other Options'),
                _buildSortTile(SortOption.alphabetical),
                _buildSortTile(SortOption.distance),

                // Sort Direction Control
                if (_selectedSort != null &&
                    _sortOptions[_selectedSort]!['hasDirection'] as bool) ...[
                  const Divider(height: 32),
                  _buildSectionHeader('Sort Direction'),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        RadioListTile<bool>(
                          title: const Text('Ascending'),
                          subtitle: Text(_getSortSubtitle(_selectedSort!, true)),
                          value: true,
                          groupValue: _ascending,
                          onChanged: (value) {
                            setState(() => _ascending = value!);
                          },
                        ),
                        const Divider(height: 1),
                        RadioListTile<bool>(
                          title: const Text('Descending'),
                          subtitle: Text(_getSortSubtitle(_selectedSort!, false)),
                          value: false,
                          groupValue: _ascending,
                          onChanged: (value) {
                            setState(() => _ascending = value!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedSort = SortOption.relevance;
                          _ascending = true;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _applySort,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Apply Sort'),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSortTile(SortOption option) {
    final optionData = _sortOptions[option]!;
    final isSelected = _selectedSort == option;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isSelected ? 2 : 0,
      color: isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.1)
          : null,
      child: RadioListTile<SortOption>(
        title: Text(
          _getSortTitle(option, _ascending),
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : null,
            color: isSelected ? Theme.of(context).primaryColor : null,
          ),
        ),
        subtitle: Text(
          _getSortSubtitle(option, _ascending),
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.7)
                : null,
          ),
        ),
        secondary: Icon(
          optionData['icon'] as IconData,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
        value: option,
        groupValue: _selectedSort,
        onChanged: (value) {
          setState(() {
            _selectedSort = value;
            // Reset to default direction when changing sort type
            if (option == SortOption.newest ||
                option == SortOption.rating ||
                option == SortOption.popularity ||
                option == SortOption.mostViewed ||
                option == SortOption.mostDownloaded) {
              _ascending = false; // Default to descending for these
            } else if (option == SortOption.alphabetical ||
                       option == SortOption.distance) {
              _ascending = true; // Default to ascending for these
            }
          });
        },
      ),
    );
  }
}