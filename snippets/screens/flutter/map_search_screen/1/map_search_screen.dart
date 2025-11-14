import 'package:flutter/material.dart';

class LocationResult {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? category;
  final double? rating;
  final int? reviewCount;
  final String? phoneNumber;
  final String? website;
  final List<String> hours;
  final double distance;
  final String? priceLevel;

  LocationResult({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.category,
    this.rating,
    this.reviewCount,
    this.phoneNumber,
    this.website,
    this.hours = const [],
    required this.distance,
    this.priceLevel,
  });
}

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();

  List<LocationResult> _searchResults = [];
  LocationResult? _selectedLocation;
  bool _isLoading = false;
  bool _showList = false;
  double _currentRadius = 5.0; // km
  String _selectedCategory = 'all';
  String _sortBy = 'distance';
  bool _isMapReady = false;

  // Mock current location
  final double _currentLat = 37.7749;
  final double _currentLng = -122.4194;

  final List<String> _categories = [
    'all',
    'restaurants',
    'shopping',
    'gas_stations',
    'hospitals',
    'banks',
    'hotels',
    'parks',
    'schools',
    'entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    // Simulate map initialization
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isMapReady = true);
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    // Simulate API call to search nearby places
    await Future.delayed(const Duration(milliseconds: 800));

    final results = _generateMockResults(query);

    setState(() {
      _searchResults = results;
      _isLoading = false;
      if (results.isNotEmpty && !_showList) {
        _selectedLocation = results.first;
      }
    });
  }

  List<LocationResult> _generateMockResults(String query) {
    final mockPlaces = [
      {
        'name': '$query at Union Square',
        'address': '123 Union Square, San Francisco, CA',
        'category': 'restaurant',
        'rating': 4.5,
        'reviewCount': 324,
        'distance': 0.8,
        'phone': '+1 (415) 123-4567',
        'priceLevel': '\$\$',
      },
      {
        'name': '$query Downtown',
        'address': '456 Market Street, San Francisco, CA',
        'category': 'shopping',
        'rating': 4.2,
        'reviewCount': 156,
        'distance': 1.2,
        'phone': '+1 (415) 234-5678',
        'priceLevel': '\$\$\$',
      },
      {
        'name': '$query Mission District',
        'address': '789 Mission Street, San Francisco, CA',
        'category': 'restaurant',
        'rating': 4.7,
        'reviewCount': 245,
        'distance': 2.1,
        'phone': '+1 (415) 345-6789',
        'priceLevel': '\$',
      },
      {
        'name': '$query Financial District',
        'address': '321 Montgomery Street, San Francisco, CA',
        'category': 'bank',
        'rating': 3.9,
        'reviewCount': 89,
        'distance': 0.6,
        'phone': '+1 (415) 456-7890',
        'priceLevel': null,
      },
      {
        'name': '$query Chinatown',
        'address': '654 Grant Avenue, San Francisco, CA',
        'category': 'restaurant',
        'rating': 4.4,
        'reviewCount': 198,
        'distance': 1.8,
        'phone': '+1 (415) 567-8901',
        'priceLevel': '\$\$',
      },
    ];

    return mockPlaces.asMap().entries.map((entry) {
      final index = entry.key;
      final place = entry.value;
      return LocationResult(
        id: 'location_$index',
        name: place['name'] as String,
        address: place['address'] as String,
        latitude: _currentLat + (index * 0.01),
        longitude: _currentLng + (index * 0.01),
        category: place['category'] as String?,
        rating: place['rating'] as double?,
        reviewCount: place['reviewCount'] as int?,
        distance: place['distance'] as double,
        phoneNumber: place['phone'] as String?,
        priceLevel: place['priceLevel'] as String?,
        hours: [
          'Mon-Fri: 9:00 AM - 9:00 PM',
          'Sat-Sun: 10:00 AM - 8:00 PM',
        ],
      );
    }).toList();
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildFilterSheet(),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'restaurants':
        return 'Restaurants';
      case 'gas_stations':
        return 'Gas Stations';
      case 'shopping':
        return 'Shopping';
      case 'hospitals':
        return 'Hospitals';
      case 'banks':
        return 'Banks';
      case 'hotels':
        return 'Hotels';
      case 'parks':
        return 'Parks';
      case 'schools':
        return 'Schools';
      case 'entertainment':
        return 'Entertainment';
      default:
        return 'All Categories';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'gas_station':
        return Icons.local_gas_station;
      case 'hospital':
        return Icons.local_hospital;
      case 'bank':
        return Icons.account_balance;
      case 'hotel':
        return Icons.hotel;
      case 'park':
        return Icons.park;
      case 'school':
        return Icons.school;
      case 'entertainment':
        return Icons.movie;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map Container
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[200],
              child: _isMapReady
                  ? _buildMapPlaceholder()
                  : const Center(child: CircularProgressIndicator()),
            ),

            // Search Header
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildSearchHeader(),
            ),

            // Quick Category Filters
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: _buildQuickFilters(),
            ),

            // Results Toggle Button
            if (_searchResults.isNotEmpty)
              Positioned(
                top: 140,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () => setState(() => _showList = !_showList),
                  child: Icon(_showList ? Icons.map : Icons.list),
                ),
              ),

            // Bottom Sheet / Results List
            if (_searchResults.isNotEmpty)
              _showList ? _buildResultsList() : _buildBottomCards(),

            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerOnUserLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search for places...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _performSearch(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _performSearch,
            ),
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: _showFilters,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildQuickFilterChip('All', 'all'),
          _buildQuickFilterChip('Restaurants', 'restaurants'),
          _buildQuickFilterChip('Shopping', 'shopping'),
          _buildQuickFilterChip('Gas', 'gas_stations'),
          _buildQuickFilterChip('Hotels', 'hotels'),
          _buildQuickFilterChip('Parks', 'parks'),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(String label, String category) {
    final isSelected = _selectedCategory == category;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedCategory = category);
          if (_searchController.text.isNotEmpty) {
            _performSearch();
          }
        },
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue[100]!,
            Colors.blue[50]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Mock map grid lines
          ...List.generate(10, (i) => Positioned(
            left: 0,
            right: 0,
            top: i * (MediaQuery.of(context).size.height / 10),
            child: Container(
              height: 1,
              color: Colors.blue[200]?.withOpacity(0.5),
            ),
          )),
          ...List.generate(10, (i) => Positioned(
            top: 0,
            bottom: 0,
            left: i * (MediaQuery.of(context).size.width / 10),
            child: Container(
              width: 1,
              color: Colors.blue[200]?.withOpacity(0.5),
            ),
          )),

          // Current location marker
          const Positioned(
            top: 200,
            left: 180,
            child: Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 24,
            ),
          ),

          // Result markers
          ..._searchResults.asMap().entries.map((entry) {
            final index = entry.key;
            final result = entry.value;
            final isSelected = _selectedLocation?.id == result.id;
            return Positioned(
              top: 150 + (index * 80.0),
              left: 150 + (index * 60.0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedLocation = result),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red : Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getCategoryIcon(result.category ?? ''),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomCards() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 200,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _searchResults.length,
          onPageChanged: (index) {
            setState(() => _selectedLocation = _searchResults[index]);
          },
          itemBuilder: (context, index) {
            final result = _searchResults[index];
            return Container(
              margin: const EdgeInsets.all(16),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getCategoryIcon(result.category ?? ''),
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              result.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.address,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (result.rating != null) ...[
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(result.rating!.toStringAsFixed(1)),
                            Text(' (${result.reviewCount})'),
                            const SizedBox(width: 16),
                          ],
                          Icon(Icons.directions_walk, size: 16),
                          Text(' ${result.distance} km'),
                          if (result.priceLevel != null) ...[
                            const SizedBox(width: 16),
                            Text(
                              result.priceLevel!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () => _callLocation(result),
                            icon: const Icon(Icons.phone, size: 16),
                            label: const Text('Call'),
                          ),
                          TextButton.icon(
                            onPressed: () => _getDirections(result),
                            icon: const Icon(Icons.directions, size: 16),
                            label: const Text('Directions'),
                          ),
                          TextButton.icon(
                            onPressed: () => _shareLocation(result),
                            icon: const Icon(Icons.share, size: 16),
                            label: const Text('Share'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
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
                      Text(
                        '${_searchResults.length} results',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _showFilters,
                        icon: const Icon(Icons.sort, size: 16),
                        label: Text(_sortBy.toUpperCase()),
                      ),
                    ],
                  ),
                ),

                // Results List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return _buildResultListItem(result);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultListItem(LocationResult result) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            _getCategoryIcon(result.category ?? ''),
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          result.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.address),
            const SizedBox(height: 4),
            Row(
              children: [
                if (result.rating != null) ...[
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  Text(' ${result.rating} (${result.reviewCount})'),
                  const SizedBox(width: 8),
                ],
                Text('${result.distance} km away'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'directions':
                _getDirections(result);
                break;
              case 'call':
                _callLocation(result);
                break;
              case 'share':
                _shareLocation(result);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'directions',
              child: Row(
                children: [
                  Icon(Icons.directions, size: 20),
                  SizedBox(width: 8),
                  Text('Directions'),
                ],
              ),
            ),
            if (result.phoneNumber != null)
              const PopupMenuItem(
                value: 'call',
                child: Row(
                  children: [
                    Icon(Icons.phone, size: 20),
                    SizedBox(width: 8),
                    Text('Call'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20),
                  SizedBox(width: 8),
                  Text('Share'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            _selectedLocation = result;
            _showList = false;
          });
        },
      ),
    );
  }

  Widget _buildFilterSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Filter & Sort',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Search Radius
          Text('Search Radius: ${_currentRadius.toInt()} km'),
          Slider(
            value: _currentRadius,
            min: 1,
            max: 50,
            divisions: 49,
            onChanged: (value) => setState(() => _currentRadius = value),
          ),

          // Category Filter
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(_getCategoryDisplayName(category)),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedCategory = value!),
          ),

          const SizedBox(height: 16),

          // Sort Options
          DropdownButtonFormField<String>(
            value: _sortBy,
            decoration: const InputDecoration(
              labelText: 'Sort by',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'distance', child: Text('Distance')),
              DropdownMenuItem(value: 'rating', child: Text('Rating')),
              DropdownMenuItem(value: 'name', child: Text('Name')),
              DropdownMenuItem(value: 'reviews', child: Text('Most Reviewed')),
            ],
            onChanged: (value) => setState(() => _sortBy = value!),
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSearch();
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  void _centerOnUserLocation() {
    // Simulate centering on user location
    setState(() {
      _selectedLocation = null;
    });
  }

  void _callLocation(LocationResult result) {
    if (result.phoneNumber != null) {
      // Launch phone dialer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calling ${result.phoneNumber}...')),
      );
    }
  }

  void _getDirections(LocationResult result) {
    // Launch maps app for directions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Getting directions to ${result.name}...')),
    );
  }

  void _shareLocation(LocationResult result) {
    // Share location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${result.name}...')),
    );
  }
}