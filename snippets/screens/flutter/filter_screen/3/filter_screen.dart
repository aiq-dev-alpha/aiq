import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;

  const FilterScreen({super.key, this.initialFilters});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedTags = {};
  final Set<String> _selectedFileTypes = {};
  RangeValues _priceRange = const RangeValues(0, 1000);
  RangeValues _ratingRange = const RangeValues(0, 5);
  String _sortBy = 'relevance';
  bool _inStock = false;
  bool _freeShipping = false;
  bool _onSale = false;
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<String> _availableCategories = [
    'Electronics',
    'Clothing',
    'Books',
    'Home & Garden',
    'Sports',
    'Beauty',
    'Automotive',
    'Toys',
  ];

  final List<String> _availableTags = [
    'Popular',
    'Trending',
    'New',
    'Featured',
    'Best Seller',
    'Limited Edition',
    'Premium',
    'Eco-Friendly',
  ];

  final List<String> _availableFileTypes = [
    'PDF',
    'DOC',
    'XLS',
    'PPT',
    'IMG',
    'VID',
    'AUD',
    'ZIP',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialFilters();
  }

  void _loadInitialFilters() {
    if (widget.initialFilters != null) {
      final filters = widget.initialFilters!;
      setState(() {
        _selectedCategories.addAll(
          List<String>.from(filters['categories'] ?? []),
        );
        _selectedTags.addAll(
          List<String>.from(filters['tags'] ?? []),
        );
        _selectedFileTypes.addAll(
          List<String>.from(filters['fileTypes'] ?? []),
        );
        _priceRange = RangeValues(
          filters['priceMin']?.toDouble() ?? 0,
          filters['priceMax']?.toDouble() ?? 1000,
        );
        _ratingRange = RangeValues(
          filters['ratingMin']?.toDouble() ?? 0,
          filters['ratingMax']?.toDouble() ?? 5,
        );
        _sortBy = filters['sortBy'] ?? 'relevance';
        _inStock = filters['inStock'] ?? false;
        _freeShipping = filters['freeShipping'] ?? false;
        _onSale = filters['onSale'] ?? false;
        _fromDate = filters['fromDate'];
        _toDate = filters['toDate'];
      });
    }
  }

  void _applyFilters() {
    final filters = {
      'categories': _selectedCategories.toList(),
      'tags': _selectedTags.toList(),
      'fileTypes': _selectedFileTypes.toList(),
      'priceMin': _priceRange.start,
      'priceMax': _priceRange.end,
      'ratingMin': _ratingRange.start,
      'ratingMax': _ratingRange.end,
      'sortBy': _sortBy,
      'inStock': _inStock,
      'freeShipping': _freeShipping,
      'onSale': _onSale,
      'fromDate': _fromDate,
      'toDate': _toDate,
    };

    Navigator.pop(context, filters);
  }

  void _resetFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedTags.clear();
      _selectedFileTypes.clear();
      _priceRange = const RangeValues(0, 1000);
      _ratingRange = const RangeValues(0, 5);
      _sortBy = 'relevance';
      _inStock = false;
      _freeShipping = false;
      _onSale = false;
      _fromDate = null;
      _toDate = null;
    });
  }

  int get _activeFiltersCount {
    int count = 0;
    count += _selectedCategories.length;
    count += _selectedTags.length;
    count += _selectedFileTypes.length;
    if (_priceRange.start > 0 || _priceRange.end < 1000) count++;
    if (_ratingRange.start > 0 || _ratingRange.end < 5) count++;
    if (_sortBy != 'relevance') count++;
    if (_inStock) count++;
    if (_freeShipping) count++;
    if (_onSale) count++;
    if (_fromDate != null || _toDate != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_activeFiltersCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _activeFiltersCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    TextButton(
                      onPressed: _resetFilters,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),

              // Filter Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Categories
                    _buildFilterSection(
                      'Categories',
                      Wrap(
                        spacing: 8,
                        children: _availableCategories
                            .map((category) => FilterChip(
                                  label: Text(category),
                                  selected:
                                      _selectedCategories.contains(category),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedCategories.add(category);
                                      } else {
                                        _selectedCategories.remove(category);
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),

                    // Tags
                    _buildFilterSection(
                      'Tags',
                      Wrap(
                        spacing: 8,
                        children: _availableTags
                            .map((tag) => FilterChip(
                                  label: Text(tag),
                                  selected: _selectedTags.contains(tag),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedTags.add(tag);
                                      } else {
                                        _selectedTags.remove(tag);
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),

                    // File Types
                    _buildFilterSection(
                      'File Types',
                      Wrap(
                        spacing: 8,
                        children: _availableFileTypes
                            .map((type) => FilterChip(
                                  label: Text(type),
                                  selected: _selectedFileTypes.contains(type),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedFileTypes.add(type);
                                      } else {
                                        _selectedFileTypes.remove(type);
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),

                    // Price Range
                    _buildFilterSection(
                      'Price Range (\$${_priceRange.start.round()} - \$${_priceRange.end.round()})',
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        onChanged: (values) {
                          setState(() => _priceRange = values);
                        },
                      ),
                    ),

                    // Rating Range
                    _buildFilterSection(
                      'Minimum Rating (${_ratingRange.start.toStringAsFixed(1)} stars)',
                      Slider(
                        value: _ratingRange.start,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            _ratingRange = RangeValues(value, _ratingRange.end);
                          });
                        },
                      ),
                    ),

                    // Sort By
                    _buildFilterSection(
                      'Sort By',
                      DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'relevance',
                            child: Text('Relevance'),
                          ),
                          DropdownMenuItem(
                            value: 'price_low',
                            child: Text('Price: Low to High'),
                          ),
                          DropdownMenuItem(
                            value: 'price_high',
                            child: Text('Price: High to Low'),
                          ),
                          DropdownMenuItem(
                            value: 'rating',
                            child: Text('Highest Rated'),
                          ),
                          DropdownMenuItem(
                            value: 'newest',
                            child: Text('Newest'),
                          ),
                          DropdownMenuItem(
                            value: 'popularity',
                            child: Text('Most Popular'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _sortBy = value!);
                        },
                      ),
                    ),

                    // Boolean Filters
                    _buildFilterSection(
                      'Options',
                      Column(
                        children: [
                          SwitchListTile(
                            title: const Text('In Stock Only'),
                            value: _inStock,
                            onChanged: (value) {
                              setState(() => _inStock = value);
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Free Shipping'),
                            value: _freeShipping,
                            onChanged: (value) {
                              setState(() => _freeShipping = value);
                            },
                          ),
                          SwitchListTile(
                            title: const Text('On Sale'),
                            value: _onSale,
                            onChanged: (value) {
                              setState(() => _onSale = value);
                            },
                          ),
                        ],
                      ),
                    ),

                    // Date Range
                    _buildFilterSection(
                      'Date Range',
                      Column(
                        children: [
                          ListTile(
                            title: Text(
                              _fromDate == null
                                  ? 'From Date'
                                  : 'From: ${_fromDate!.toString().split(' ')[0]}',
                            ),
                            trailing: const Icon(Icons.date_range),
                            onTap: () => _selectDate(true),
                          ),
                          ListTile(
                            title: Text(
                              _toDate == null
                                  ? 'To Date'
                                  : 'To: ${_toDate!.toString().split(' ')[0]}',
                            ),
                            trailing: const Icon(Icons.date_range),
                            onTap: () => _selectDate(false),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Space for apply button
                  ],
                ),
              ),

              // Apply Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _activeFiltersCount > 0
                            ? 'Apply $_activeFiltersCount Filters'
                            : 'Apply Filters',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Future<void> _selectDate(bool isFromDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }
}