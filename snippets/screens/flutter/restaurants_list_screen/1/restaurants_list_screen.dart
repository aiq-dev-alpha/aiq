import 'package:flutter/material.dart';

class RestaurantsListScreen extends StatefulWidget {
  const RestaurantsListScreen({super.key});

  @override
  State<RestaurantsListScreen> createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedSort = 'Rating';

  final List<Restaurant> _restaurants = [
    Restaurant(
      id: '1',
      name: 'The Golden Spoon',
      cuisine: 'Italian',
      rating: 4.8,
      reviewCount: 324,
      priceRange: PriceRange.expensive,
      deliveryTime: '25-40 min',
      deliveryFee: 3.99,
      distance: 0.8,
      imageUrl: 'https://via.placeholder.com/300x200',
      isOpen: true,
      isFeatured: true,
      address: '123 Main St, Downtown',
      phoneNumber: '+1 555-0123',
    ),
    Restaurant(
      id: '2',
      name: 'Sakura Sushi',
      cuisine: 'Japanese',
      rating: 4.6,
      reviewCount: 198,
      priceRange: PriceRange.moderate,
      deliveryTime: '30-45 min',
      deliveryFee: 2.99,
      distance: 1.2,
      imageUrl: 'https://via.placeholder.com/300x200',
      isOpen: true,
      isFeatured: false,
      address: '456 Oak Ave, Midtown',
      phoneNumber: '+1 555-0124',
    ),
    Restaurant(
      id: '3',
      name: 'Taco Libre',
      cuisine: 'Mexican',
      rating: 4.4,
      reviewCount: 256,
      priceRange: PriceRange.budget,
      deliveryTime: '15-30 min',
      deliveryFee: 1.99,
      distance: 0.5,
      imageUrl: 'https://via.placeholder.com/300x200',
      isOpen: true,
      isFeatured: true,
      address: '789 Pine St, Eastside',
      phoneNumber: '+1 555-0125',
    ),
    Restaurant(
      id: '4',
      name: 'Le Petit Bistro',
      cuisine: 'French',
      rating: 4.9,
      reviewCount: 412,
      priceRange: PriceRange.expensive,
      deliveryTime: '35-50 min',
      deliveryFee: 4.99,
      distance: 2.1,
      imageUrl: 'https://via.placeholder.com/300x200',
      isOpen: false,
      isFeatured: false,
      address: '321 Elm Dr, Westside',
      phoneNumber: '+1 555-0126',
    ),
    Restaurant(
      id: '5',
      name: 'Spice Garden',
      cuisine: 'Indian',
      rating: 4.5,
      reviewCount: 189,
      priceRange: PriceRange.moderate,
      deliveryTime: '25-40 min',
      deliveryFee: 2.49,
      distance: 1.5,
      imageUrl: 'https://via.placeholder.com/300x200',
      isOpen: true,
      isFeatured: false,
      address: '654 Maple Rd, Northside',
      phoneNumber: '+1 555-0127',
    ),
    Restaurant(
      id: '6',
      name: 'Dragon Palace',
      cuisine: 'Chinese',
      rating: 4.3,
      reviewCount: 298,
      priceRange: PriceRange.budget,
      deliveryTime: '20-35 min',
      deliveryFee: 1.49,
      distance: 1.0,
      imageUrl: 'https://via.placeholder.com/300x200',
      isOpen: true,
      isFeatured: false,
      address: '987 Cedar St, Southside',
      phoneNumber: '+1 555-0128',
    ),
  ];

  List<Restaurant> get _filteredRestaurants {
    List<Restaurant> filtered = _restaurants;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((restaurant) =>
          restaurant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          restaurant.cuisine.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Apply cuisine filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((restaurant) => restaurant.cuisine == _selectedFilter).toList();
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Distance':
        filtered.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'Delivery Time':
        filtered.sort((a, b) => a.deliveryTime.compareTo(b.deliveryTime));
        break;
      case 'Price':
        filtered.sort((a, b) => a.priceRange.index.compareTo(b.priceRange.index));
        break;
    }

    // Prioritize featured and open restaurants
    filtered.sort((a, b) {
      if (a.isFeatured && !b.isFeatured) return -1;
      if (!a.isFeatured && b.isFeatured) return 1;
      if (a.isOpen && !b.isOpen) return -1;
      if (!a.isOpen && b.isOpen) return 1;
      return 0;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final cuisines = ['All', ...{'Italian', 'Japanese', 'Mexican', 'French', 'Indian', 'Chinese'}];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => _showMapView(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search restaurants or cuisine...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cuisines.length + 1, // +1 for sort chip
              itemBuilder: (context, index) {
                if (index == cuisines.length) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ActionChip(
                      avatar: const Icon(Icons.sort, size: 18),
                      label: Text('Sort: $_selectedSort'),
                      onPressed: () => _showSortDialog(),
                    ),
                  );
                }

                final cuisine = cuisines[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cuisine),
                    selected: _selectedFilter == cuisine,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = cuisine;
                      });
                    },
                    selectedColor: Colors.orange.withOpacity(0.2),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Restaurants List
          Expanded(
            child: _filteredRestaurants.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = _filteredRestaurants[index];
                      return _buildRestaurantCard(restaurant);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No restaurants available' : 'No restaurants found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Try changing your location or check back later'
                : 'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToRestaurantDetail(restaurant),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getCuisineColor(restaurant.cuisine).withOpacity(0.8),
                        _getCuisineColor(restaurant.cuisine),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Status badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (restaurant.isFeatured)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!restaurant.isOpen)
                        Container(
                          margin: EdgeInsets.only(top: restaurant.isFeatured ? 6 : 0),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Closed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Distance and delivery fee
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${restaurant.distance.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Restaurant Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getPriceColor(restaurant.priceRange).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getPriceRangeText(restaurant.priceRange),
                          style: TextStyle(
                            color: _getPriceColor(restaurant.priceRange),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    restaurant.cuisine,
                    style: TextStyle(
                      color: _getCuisineColor(restaurant.cuisine),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${restaurant.reviewCount})',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),

                      const Spacer(),

                      Icon(
                        Icons.access_time,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.deliveryTime,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.address,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        'Delivery: \$${restaurant.deliveryFee.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: restaurant.isOpen ? () => _addToFavorites(restaurant) : null,
                          icon: const Icon(Icons.favorite_border, size: 16),
                          label: const Text('Save'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: restaurant.isOpen
                              ? () => _navigateToRestaurantDetail(restaurant)
                              : null,
                          icon: const Icon(Icons.restaurant_menu, size: 16),
                          label: Text(restaurant.isOpen ? 'View Menu' : 'Closed'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: restaurant.isOpen
                                ? _getCuisineColor(restaurant.cuisine)
                                : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
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

  Color _getCuisineColor(String cuisine) {
    switch (cuisine) {
      case 'Italian':
        return Colors.red;
      case 'Japanese':
        return Colors.pink;
      case 'Mexican':
        return Colors.orange;
      case 'French':
        return Colors.purple;
      case 'Indian':
        return Colors.deepOrange;
      case 'Chinese':
        return Colors.red.shade800;
      default:
        return Colors.blue;
    }
  }

  Color _getPriceColor(PriceRange range) {
    switch (range) {
      case PriceRange.budget:
        return Colors.green;
      case PriceRange.moderate:
        return Colors.orange;
      case PriceRange.expensive:
        return Colors.red;
    }
  }

  String _getPriceRangeText(PriceRange range) {
    switch (range) {
      case PriceRange.budget:
        return '\$';
      case PriceRange.moderate:
        return '\$\$';
      case PriceRange.expensive:
        return '\$\$\$';
    }
  }

  void _navigateToRestaurantDetail(Restaurant restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
      ),
    );
  }

  void _addToFavorites(Restaurant restaurant) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${restaurant.name} added to favorites!')),
    );
  }

  void _showMapView() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Map view would be implemented here')),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Price Range:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: PriceRange.values.map((range) {
                return FilterChip(
                  label: Text(_getPriceRangeText(range)),
                  selected: false,
                  onSelected: (selected) {
                    // Apply price filter
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Rating:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['4.0+', '4.5+', '4.8+'].map((rating) {
                return FilterChip(
                  label: Text(rating),
                  selected: false,
                  onSelected: (selected) {
                    // Apply rating filter
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort By'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Rating', 'Distance', 'Delivery Time', 'Price'].map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedSort,
              onChanged: (value) {
                setState(() {
                  _selectedSort = value!;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

enum PriceRange { budget, moderate, expensive }

class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final PriceRange priceRange;
  final String deliveryTime;
  final double deliveryFee;
  final double distance;
  final String imageUrl;
  final bool isOpen;
  final bool isFeatured;
  final String address;
  final String phoneNumber;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.distance,
    required this.imageUrl,
    required this.isOpen,
    required this.isFeatured,
    required this.address,
    required this.phoneNumber,
  });
}

// This would typically be in a separate file
class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: const Center(
        child: Text('Restaurant Detail Screen'),
      ),
    );
  }
}