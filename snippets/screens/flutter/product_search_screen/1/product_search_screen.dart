import 'package:flutter/material.dart';

class ProductSearchScreen extends StatefulWidget {
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  String selectedCategory = 'All';
  double minPrice = 0;
  double maxPrice = 1000;
  String selectedSort = 'Relevance';
  List<String> selectedBrands = [];

  final categories = ['All', 'Electronics', 'Fashion', 'Home', 'Sports', 'Beauty'];
  final sortOptions = ['Relevance', 'Price: Low to High', 'Price: High to Low', 'Newest', 'Popular'];
  final brands = ['Apple', 'Samsung', 'Nike', 'Adidas', 'Sony', 'Dell'];

  List<String> recentSearches = ['wireless headphones', 't-shirt', 'running shoes'];
  List<String> suggestions = ['iPhone 15', 'MacBook Pro', 'AirPods', 'iPad', 'Apple Watch'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.black),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!isSearching) _buildSearchSuggestions(),
          if (isSearching) Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: 20),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      isSearching = false;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onChanged: (value) {
          setState(() {
            isSearching = value.isNotEmpty;
          });
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            _performSearch(value);
          }
        },
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recentSearches.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        recentSearches.clear();
                      });
                    },
                    child: Text('Clear All'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ...recentSearches.map((search) => _buildRecentSearchItem(search)).toList(),
              SizedBox(height: 24),
            ],

            Text(
              'Popular Searches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...suggestions.map((suggestion) => _buildSuggestionItem(suggestion)).toList(),

            SizedBox(height: 24),
            Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: categories.length - 1, // Exclude 'All'
              itemBuilder: (context, index) {
                return _buildCategoryCard(categories[index + 1]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(String search) {
    return ListTile(
      leading: Icon(Icons.history, color: Colors.grey[600]),
      title: Text(search),
      trailing: IconButton(
        icon: Icon(Icons.close, color: Colors.grey[600]),
        onPressed: () {
          setState(() {
            recentSearches.remove(search);
          });
        },
      ),
      onTap: () => _performSearch(search),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return ListTile(
      leading: Icon(Icons.trending_up, color: Colors.blue),
      title: Text(suggestion),
      onTap: () => _performSearch(suggestion),
    );
  }

  Widget _buildCategoryCard(String category) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedCategory = category;
            isSearching = true;
          });
        },
        child: Center(
          child: Text(
            category,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        // Active Filters
        if (_hasActiveFilters()) _buildActiveFilters(),

        // Sort Bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text('Found 24 results'),
              Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) => setState(() => selectedSort = value),
                itemBuilder: (context) => sortOptions
                    .map((option) => PopupMenuItem(value: option, child: Text(option)))
                    .toList(),
                child: Row(
                  children: [
                    Text('Sort: $selectedSort'),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Results Grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 20,
            itemBuilder: (context, index) => _buildProductCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFilters() {
    List<Widget> filters = [];

    if (selectedCategory != 'All') {
      filters.add(_buildFilterChip('Category: $selectedCategory', () {
        setState(() => selectedCategory = 'All');
      }));
    }

    if (minPrice > 0 || maxPrice < 1000) {
      filters.add(_buildFilterChip('\$${minPrice.round()} - \$${maxPrice.round()}', () {
        setState(() {
          minPrice = 0;
          maxPrice = 1000;
        });
      }));
    }

    for (String brand in selectedBrands) {
      filters.add(_buildFilterChip(brand, () {
        setState(() => selectedBrands.remove(brand));
      }));
    }

    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...filters,
          if (filters.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  selectedCategory = 'All';
                  minPrice = 0;
                  maxPrice = 1000;
                  selectedBrands.clear();
                });
              },
              child: Text('Clear All'),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: Icon(Icons.close, size: 18),
        onDeleted: onRemove,
        backgroundColor: Colors.blue[50],
        deleteIconColor: Colors.blue,
      ),
    );
  }

  Widget _buildProductCard(int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product ${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text('4.5', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '\$${(index + 1) * 10}.99',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Reset filters
                        setModalState(() {
                          selectedCategory = 'All';
                          minPrice = 0;
                          maxPrice = 1000;
                          selectedBrands.clear();
                        });
                      },
                      child: Text('Reset'),
                    ),
                    Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Text('Apply'),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Filter
                      Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: categories.map((category) {
                          return FilterChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            onSelected: (selected) {
                              setModalState(() => selectedCategory = category);
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24),

                      // Price Range
                      Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 12),
                      RangeSlider(
                        values: RangeValues(minPrice, maxPrice),
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        labels: RangeLabels('\$${minPrice.round()}', '\$${maxPrice.round()}'),
                        onChanged: (values) {
                          setModalState(() {
                            minPrice = values.start;
                            maxPrice = values.end;
                          });
                        },
                      ),
                      SizedBox(height: 24),

                      // Brand Filter
                      Text('Brand', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 12),
                      ...brands.map((brand) {
                        return CheckboxListTile(
                          value: selectedBrands.contains(brand),
                          onChanged: (value) {
                            setModalState(() {
                              if (value == true) {
                                selectedBrands.add(brand);
                              } else {
                                selectedBrands.remove(brand);
                              }
                            });
                          },
                          title: Text(brand),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    setState(() {
      _searchController.text = query;
      isSearching = true;
    });

    // Add to recent searches if not already present
    if (!recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) {
          recentSearches = recentSearches.take(5).toList();
        }
      });
    }
  }

  bool _hasActiveFilters() {
    return selectedCategory != 'All' ||
           minPrice > 0 ||
           maxPrice < 1000 ||
           selectedBrands.isNotEmpty;
  }
}