import 'package:flutter/material.dart';

class HotelsListScreen extends StatefulWidget {
  const HotelsListScreen({super.key});

  @override
  State<HotelsListScreen> createState() => _HotelsListScreenState();
}

class _HotelsListScreenState extends State<HotelsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = 'Price';
  RangeValues _priceRange = const RangeValues(50, 300);
  double _minRating = 3.0;

  final List<Hotel> _hotels = [
    Hotel(
      id: '1',
      name: 'Grand Plaza Hotel',
      address: '123 Downtown Ave, City Center',
      rating: 4.8,
      reviewCount: 1247,
      pricePerNight: 180.00,
      originalPrice: 220.00,
      imageUrl: 'https://via.placeholder.com/300x200',
      amenities: ['WiFi', 'Pool', 'Gym', 'Spa', 'Restaurant', 'Parking'],
      distanceFromCenter: 0.5,
      hotelType: HotelType.luxury,
      isAvailable: true,
      isFeatured: true,
      hasFreeCancellation: true,
      breakfastIncluded: true,
      roomType: 'Deluxe King Room',
    ),
    Hotel(
      id: '2',
      name: 'City Comfort Inn',
      address: '456 Main St, Business District',
      rating: 4.2,
      reviewCount: 893,
      pricePerNight: 95.00,
      originalPrice: 120.00,
      imageUrl: 'https://via.placeholder.com/300x200',
      amenities: ['WiFi', 'Breakfast', 'Business Center', 'Parking'],
      distanceFromCenter: 1.2,
      hotelType: HotelType.business,
      isAvailable: true,
      isFeatured: false,
      hasFreeCancellation: true,
      breakfastIncluded: true,
      roomType: 'Standard Double Room',
    ),
    Hotel(
      id: '3',
      name: 'Sunset Beach Resort',
      address: '789 Ocean Drive, Beachfront',
      rating: 4.6,
      reviewCount: 654,
      pricePerNight: 250.00,
      originalPrice: 300.00,
      imageUrl: 'https://via.placeholder.com/300x200',
      amenities: ['WiFi', 'Pool', 'Beach Access', 'Restaurant', 'Bar', 'Spa'],
      distanceFromCenter: 5.8,
      hotelType: HotelType.resort,
      isAvailable: true,
      isFeatured: true,
      hasFreeCancellation: false,
      breakfastIncluded: false,
      roomType: 'Ocean View Suite',
    ),
    Hotel(
      id: '4',
      name: 'Budget Stay Motel',
      address: '321 Highway Rd, Airport Area',
      rating: 3.8,
      reviewCount: 234,
      pricePerNight: 65.00,
      originalPrice: 75.00,
      imageUrl: 'https://via.placeholder.com/300x200',
      amenities: ['WiFi', 'Parking', '24h Reception'],
      distanceFromCenter: 8.2,
      hotelType: HotelType.budget,
      isAvailable: true,
      isFeatured: false,
      hasFreeCancellation: true,
      breakfastIncluded: false,
      roomType: 'Standard Room',
    ),
    Hotel(
      id: '5',
      name: 'Historic Boutique Hotel',
      address: '654 Heritage Lane, Old Town',
      rating: 4.7,
      reviewCount: 456,
      pricePerNight: 320.00,
      originalPrice: 350.00,
      imageUrl: 'https://via.placeholder.com/300x200',
      amenities: ['WiFi', 'Restaurant', 'Concierge', 'Valet Parking', 'Library'],
      distanceFromCenter: 2.1,
      hotelType: HotelType.boutique,
      isAvailable: false,
      isFeatured: true,
      hasFreeCancellation: true,
      breakfastIncluded: true,
      roomType: 'Heritage Suite',
    ),
  ];

  List<Hotel> get _filteredHotels {
    List<Hotel> filtered = _hotels;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((hotel) =>
          hotel.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hotel.address.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Apply price filter
    filtered = filtered.where((hotel) =>
        hotel.pricePerNight >= _priceRange.start &&
        hotel.pricePerNight <= _priceRange.end
    ).toList();

    // Apply rating filter
    filtered = filtered.where((hotel) => hotel.rating >= _minRating).toList();

    // Apply sorting
    switch (_selectedSort) {
      case 'Price':
        filtered.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Distance':
        filtered.sort((a, b) => a.distanceFromCenter.compareTo(b.distanceFromCenter));
        break;
    }

    // Prioritize available and featured hotels
    filtered.sort((a, b) {
      if (a.isFeatured && !b.isFeatured) return -1;
      if (!a.isFeatured && b.isFeatured) return 1;
      if (a.isAvailable && !b.isAvailable) return -1;
      if (!a.isAvailable && b.isAvailable) return 1;
      return 0;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => _showMapView(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(),
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
                hintText: 'Search hotels...',
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

          // Quick Filters
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ActionChip(
                  avatar: const Icon(Icons.sort, size: 18),
                  label: Text('Sort: $_selectedSort'),
                  onPressed: () => _showSortDialog(),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  avatar: const Icon(Icons.attach_money, size: 18),
                  label: Text('\$${_priceRange.start.round()}-\$${_priceRange.end.round()}'),
                  selected: _priceRange.start != 50 || _priceRange.end != 300,
                  onSelected: (selected) => _showFilterSheet(),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  avatar: const Icon(Icons.star, size: 18),
                  label: Text('${_minRating.toStringAsFixed(1)}+ Rating'),
                  selected: _minRating != 3.0,
                  onSelected: (selected) => _showFilterSheet(),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Available Only'),
                  selected: false,
                  onSelected: (selected) {
                    // Apply availability filter
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredHotels.length} hotels found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _clearFilters(),
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear Filters'),
                ),
              ],
            ),
          ),

          // Hotels List
          Expanded(
            child: _filteredHotels.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = _filteredHotels[index];
                      return _buildHotelCard(hotel);
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
            Icons.hotel,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hotels found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search criteria or filters',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    final discountPercent = hotel.originalPrice > hotel.pricePerNight
        ? ((hotel.originalPrice - hotel.pricePerNight) / hotel.originalPrice * 100).round()
        : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToHotelDetail(hotel),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getHotelTypeColor(hotel.hotelType).withOpacity(0.8),
                        _getHotelTypeColor(hotel.hotelType),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.hotel,
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
                      if (hotel.isFeatured)
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
                      if (!hotel.isAvailable)
                        Container(
                          margin: EdgeInsets.only(top: hotel.isFeatured ? 6 : 0),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Fully Booked',
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

                // Discount badge
                if (discountPercent > 0)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$discountPercent% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Hotel Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hotel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getHotelTypeColor(hotel.hotelType).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getHotelTypeName(hotel.hotelType),
                          style: TextStyle(
                            color: _getHotelTypeColor(hotel.hotelType),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.address,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${hotel.distanceFromCenter.toStringAsFixed(1)} km from center',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        hotel.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' (${hotel.reviewCount} reviews)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    hotel.roomType,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Amenities
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: hotel.amenities.take(4).map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          amenity,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    }).toList()
                      ..add(
                        if (hotel.amenities.length > 4)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '+${hotel.amenities.length - 4} more',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                      ),
                  ),

                  const SizedBox(height: 12),

                  // Booking info
                  Row(
                    children: [
                      if (hotel.hasFreeCancellation)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 14),
                              const SizedBox(width: 4),
                              const Text(
                                'Free cancellation',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (hotel.breakfastIncluded)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.restaurant, color: Colors.orange, size: 14),
                            const SizedBox(width: 4),
                            const Text(
                              'Breakfast included',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price and booking
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hotel.originalPrice > hotel.pricePerNight)
                            Text(
                              '\$${hotel.originalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${hotel.pricePerNight.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const Text(
                                ' / night',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: hotel.isAvailable
                            ? () => _navigateToHotelDetail(hotel)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hotel.isAvailable
                              ? _getHotelTypeColor(hotel.hotelType)
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text(hotel.isAvailable ? 'Book Now' : 'Fully Booked'),
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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Filter Hotels',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Done'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Price Range
              const Text(
                'Price Range (per night)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              RangeSlider(
                values: _priceRange,
                min: 50,
                max: 500,
                divisions: 18,
                labels: RangeLabels(
                  '\$${_priceRange.start.round()}',
                  '\$${_priceRange.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  setModalState(() {
                    _priceRange = values;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Minimum Rating
              const Text(
                'Minimum Rating',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _minRating,
                min: 1.0,
                max: 5.0,
                divisions: 8,
                label: '${_minRating.toStringAsFixed(1)} stars',
                onChanged: (double value) {
                  setModalState(() {
                    _minRating = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Hotel Types
              const Text(
                'Hotel Type',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: HotelType.values.map((type) {
                  return FilterChip(
                    label: Text(_getHotelTypeName(type)),
                    selected: false,
                    onSelected: (selected) {
                      // Apply hotel type filter
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Amenities
              const Text(
                'Amenities',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['WiFi', 'Pool', 'Gym', 'Spa', 'Restaurant', 'Bar', 'Parking', 'Business Center', 'Pet Friendly', 'Airport Shuttle']
                        .map((amenity) {
                      return FilterChip(
                        label: Text(amenity),
                        selected: false,
                        onSelected: (selected) {
                          // Apply amenity filter
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Apply button
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
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
          children: ['Price', 'Rating', 'Distance'].map((option) {
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

  void _clearFilters() {
    setState(() {
      _priceRange = const RangeValues(50, 300);
      _minRating = 3.0;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _navigateToHotelDetail(Hotel hotel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HotelDetailScreen(hotel: hotel),
      ),
    );
  }

  void _showMapView() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Map view would be implemented here')),
    );
  }

  Color _getHotelTypeColor(HotelType type) {
    switch (type) {
      case HotelType.luxury:
        return Colors.purple;
      case HotelType.business:
        return Colors.blue;
      case HotelType.budget:
        return Colors.green;
      case HotelType.resort:
        return Colors.orange;
      case HotelType.boutique:
        return Colors.pink;
    }
  }

  String _getHotelTypeName(HotelType type) {
    switch (type) {
      case HotelType.luxury:
        return 'Luxury';
      case HotelType.business:
        return 'Business';
      case HotelType.budget:
        return 'Budget';
      case HotelType.resort:
        return 'Resort';
      case HotelType.boutique:
        return 'Boutique';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

enum HotelType { luxury, business, budget, resort, boutique }

class Hotel {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final double originalPrice;
  final String imageUrl;
  final List<String> amenities;
  final double distanceFromCenter;
  final HotelType hotelType;
  final bool isAvailable;
  final bool isFeatured;
  final bool hasFreeCancellation;
  final bool breakfastIncluded;
  final String roomType;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.originalPrice,
    required this.imageUrl,
    required this.amenities,
    required this.distanceFromCenter,
    required this.hotelType,
    required this.isAvailable,
    required this.isFeatured,
    required this.hasFreeCancellation,
    required this.breakfastIncluded,
    required this.roomType,
  });
}

// This would typically be in a separate file
class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name),
      ),
      body: const Center(
        child: Text('Hotel Detail Screen'),
      ),
    );
  }
}