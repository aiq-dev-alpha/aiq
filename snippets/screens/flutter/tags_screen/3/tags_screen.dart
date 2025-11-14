import 'package:flutter/material.dart';

class Tag {
  final String id;
  final String name;
  final String? color;
  final int count;
  final String? category;
  final bool isPopular;

  Tag({
    required this.id,
    required this.name,
    this.color,
    required this.count,
    this.category,
    this.isPopular = false,
  });
}

class TagsScreen extends StatefulWidget {
  final List<String>? selectedTags;

  const TagsScreen({super.key, this.selectedTags});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<Tag> _allTags = [];
  List<Tag> _filteredTags = [];
  Set<String> _selectedTags = {};
  String _selectedCategory = 'all';
  String _sortBy = 'popularity';
  bool _isLoading = true;

  final List<String> _categories = [
    'all',
    'technology',
    'design',
    'business',
    'development',
    'marketing',
    'science',
    'education',
    'health',
    'lifestyle',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedTags = Set<String>.from(widget.selectedTags ?? []);
    _searchController.addListener(_filterTags);
    _loadTags();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTags() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    final mockTags = _generateMockTags();

    setState(() {
      _allTags = mockTags;
      _filteredTags = mockTags;
      _isLoading = false;
    });
  }

  List<Tag> _generateMockTags() {
    final tagData = [
      {'name': 'Flutter', 'category': 'technology', 'count': 2450, 'color': '#0175C2'},
      {'name': 'Dart', 'category': 'technology', 'count': 1820, 'color': '#0175C2'},
      {'name': 'React', 'category': 'technology', 'count': 3200, 'color': '#61DAFB'},
      {'name': 'JavaScript', 'category': 'technology', 'count': 4150, 'color': '#F7DF1E'},
      {'name': 'Python', 'category': 'technology', 'count': 3850, 'color': '#3776AB'},
      {'name': 'UI Design', 'category': 'design', 'count': 2100, 'color': '#FF6B6B'},
      {'name': 'UX Research', 'category': 'design', 'count': 1550, 'color': '#FF6B6B'},
      {'name': 'Figma', 'category': 'design', 'count': 1890, 'color': '#F24E1E'},
      {'name': 'Adobe XD', 'category': 'design', 'count': 920, 'color': '#FF61F6'},
      {'name': 'Prototyping', 'category': 'design', 'count': 1340, 'color': '#FF6B6B'},
      {'name': 'Startup', 'category': 'business', 'count': 2800, 'color': '#4ECDC4'},
      {'name': 'Entrepreneurship', 'category': 'business', 'count': 1950, 'color': '#4ECDC4'},
      {'name': 'Marketing', 'category': 'business', 'count': 2350, 'color': '#4ECDC4'},
      {'name': 'SEO', 'category': 'marketing', 'count': 1780, 'color': '#45B7D1'},
      {'name': 'Content Marketing', 'category': 'marketing', 'count': 1420, 'color': '#45B7D1'},
      {'name': 'Social Media', 'category': 'marketing', 'count': 2680, 'color': '#45B7D1'},
      {'name': 'Machine Learning', 'category': 'science', 'count': 3100, 'color': '#96CEB4'},
      {'name': 'Data Science', 'category': 'science', 'count': 2750, 'color': '#96CEB4'},
      {'name': 'AI', 'category': 'science', 'count': 3450, 'color': '#96CEB4'},
      {'name': 'Blockchain', 'category': 'technology', 'count': 1650, 'color': '#FECA57'},
      {'name': 'Cryptocurrency', 'category': 'technology', 'count': 1890, 'color': '#FECA57'},
      {'name': 'Web Development', 'category': 'development', 'count': 3800, 'color': '#FF9FF3'},
      {'name': 'Mobile Development', 'category': 'development', 'count': 2650, 'color': '#FF9FF3'},
      {'name': 'DevOps', 'category': 'development', 'count': 1950, 'color': '#FF9FF3'},
      {'name': 'Cloud Computing', 'category': 'technology', 'count': 2450, 'color': '#54A0FF'},
      {'name': 'AWS', 'category': 'technology', 'count': 1780, 'color': '#FF9500'},
      {'name': 'Docker', 'category': 'development', 'count': 1650, 'color': '#0db7ed'},
      {'name': 'Kubernetes', 'category': 'development', 'count': 1420, 'color': '#326ce5'},
      {'name': 'Photography', 'category': 'lifestyle', 'count': 1890, 'color': '#FD79A8'},
      {'name': 'Travel', 'category': 'lifestyle', 'count': 2340, 'color': '#FDCB6E'},
    ];

    return tagData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return Tag(
        id: 'tag_$index',
        name: data['name'] as String,
        category: data['category'] as String,
        count: data['count'] as int,
        color: data['color'] as String?,
        isPopular: (data['count'] as int) > 2000,
      );
    }).toList();
  }

  void _filterTags() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTags = _allTags.where((tag) {
        final matchesSearch = tag.name.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'all' ||
                               tag.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();

      _sortTags();
    });
  }

  void _sortTags() {
    switch (_sortBy) {
      case 'alphabetical':
        _filteredTags.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'popularity':
        _filteredTags.sort((a, b) => b.count.compareTo(a.count));
        break;
      case 'recent':
        // In a real app, you'd sort by creation/update time
        _filteredTags.sort((a, b) => b.count.compareTo(a.count));
        break;
    }
  }

  void _toggleTag(String tagId) {
    setState(() {
      if (_selectedTags.contains(tagId)) {
        _selectedTags.remove(tagId);
      } else {
        _selectedTags.add(tagId);
      }
    });
  }

  void _applyTags() {
    final selectedTagNames = _allTags
        .where((tag) => _selectedTags.contains(tag.id))
        .map((tag) => tag.name)
        .toList();

    Navigator.pop(context, selectedTagNames);
  }

  Color _getTagColor(String? colorHex) {
    if (colorHex == null) return Colors.blue;
    final hex = colorHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tags (${_selectedTags.length} selected)'),
        actions: [
          if (_selectedTags.isNotEmpty)
            TextButton(
              onPressed: _applyTags,
              child: const Text('Apply'),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Browse', icon: Icon(Icons.explore)),
            Tab(text: 'Popular', icon: Icon(Icons.trending_up)),
            Tab(text: 'My Tags', icon: Icon(Icons.bookmark)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tags...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterTags();
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

          // Filters and Sort
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Category Filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category == 'all'
                            ? 'All Categories'
                            : category.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                        _filterTags();
                      });
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Sort Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sortBy,
                    decoration: const InputDecoration(
                      labelText: 'Sort by',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'popularity',
                        child: Text('Most Popular'),
                      ),
                      DropdownMenuItem(
                        value: 'alphabetical',
                        child: Text('A-Z'),
                      ),
                      DropdownMenuItem(
                        value: 'recent',
                        child: Text('Recently Added'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                        _sortTags();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBrowseTab(),
                _buildPopularTab(),
                _buildMyTagsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedTags.isNotEmpty
          ? Container(
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
                          setState(() => _selectedTags.clear());
                        },
                        child: const Text('Clear All'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _applyTags,
                        child: Text('Apply ${_selectedTags.length} Tags'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBrowseTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredTags.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No tags found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredTags.length,
      itemBuilder: (context, index) {
        final tag = _filteredTags[index];
        return _buildTagCard(tag);
      },
    );
  }

  Widget _buildPopularTab() {
    final popularTags = _allTags.where((tag) => tag.isPopular).toList();
    popularTags.sort((a, b) => b.count.compareTo(a.count));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: popularTags.length,
      itemBuilder: (context, index) {
        final tag = popularTags[index];
        return _buildTagListItem(tag, index + 1);
      },
    );
  }

  Widget _buildMyTagsTab() {
    final myTags = _allTags.where((tag) => _selectedTags.contains(tag.id)).toList();

    if (myTags.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmarks, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No tags selected',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Browse tags and add them to your collection',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _tabController.animateTo(0),
              child: const Text('Browse Tags'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: myTags.map((tag) => _buildSelectedTagChip(tag)).toList(),
      ),
    );
  }

  Widget _buildTagCard(Tag tag) {
    final isSelected = _selectedTags.contains(tag.id);
    final tagColor = _getTagColor(tag.color);

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? tagColor.withOpacity(0.1) : null,
      child: InkWell(
        onTap: () => _toggleTag(tag.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: tagColor, width: 2)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: tagColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tag.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? tagColor : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected) Icon(Icons.check, color: tagColor, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${tag.count} items',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? tagColor.withOpacity(0.7)
                        : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagListItem(Tag tag, int rank) {
    final isSelected = _selectedTags.contains(tag.id);
    final tagColor = _getTagColor(tag.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tagColor.withOpacity(0.2),
          child: Text(
            '$rank',
            style: TextStyle(
              color: tagColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          tag.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? tagColor : null,
          ),
        ),
        subtitle: Text(
          '${tag.count} items • ${tag.category?.toUpperCase()}',
          style: TextStyle(
            color: isSelected
                ? tagColor.withOpacity(0.7)
                : Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tag.isPopular)
              Icon(Icons.trending_up, color: Colors.orange[600], size: 20),
            const SizedBox(width: 8),
            Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleTag(tag.id),
              activeColor: tagColor,
            ),
          ],
        ),
        onTap: () => _toggleTag(tag.id),
        selected: isSelected,
      ),
    );
  }

  Widget _buildSelectedTagChip(Tag tag) {
    final tagColor = _getTagColor(tag.color);

    return Chip(
      label: Text(
        tag.name,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: tagColor,
      deleteIcon: const Icon(Icons.close, color: Colors.white, size: 18),
      onDeleted: () => _toggleTag(tag.id),
      avatar: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.3),
        child: Text(
          tag.count > 1000
              ? '${(tag.count / 1000).toStringAsFixed(0)}k'
              : tag.count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}