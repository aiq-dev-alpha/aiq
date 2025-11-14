import 'package:flutter/material.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 3));
  int _guests = 2;
  int _rooms = 1;

  final List<RoomType> _roomTypes = [
    RoomType(
      id: '1',
      name: 'Standard Room',
      description: 'Comfortable room with essential amenities',
      price: 95.00,
      originalPrice: 120.00,
      size: 25,
      maxGuests: 2,
      bedType: 'Queen Bed',
      amenities: ['WiFi', 'AC', 'TV', 'Mini Fridge'],
      images: ['room1.jpg', 'room2.jpg'],
      isAvailable: true,
    ),
    RoomType(
      id: '2',
      name: 'Deluxe King Room',
      description: 'Spacious room with city view and premium amenities',
      price: 180.00,
      originalPrice: 220.00,
      size: 35,
      maxGuests: 2,
      bedType: 'King Bed',
      amenities: ['WiFi', 'AC', 'TV', 'Mini Bar', 'City View', 'Work Desk'],
      images: ['deluxe1.jpg', 'deluxe2.jpg'],
      isAvailable: true,
    ),
    RoomType(
      id: '3',
      name: 'Executive Suite',
      description: 'Luxurious suite with separate living area',
      price: 320.00,
      originalPrice: 380.00,
      size: 55,
      maxGuests: 4,
      bedType: 'King Bed + Sofa Bed',
      amenities: ['WiFi', 'AC', 'TV', 'Mini Bar', 'City View', 'Living Room', 'Kitchenette'],
      images: ['suite1.jpg', 'suite2.jpg'],
      isAvailable: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  int get _nightCount {
    return _checkOutDate.difference(_checkInDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hotel Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getHotelTypeColor(widget.hotel.hotelType).withOpacity(0.8),
                          _getHotelTypeColor(widget.hotel.hotelType),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.hotel,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  // Status overlay
                  if (!widget.hotel.isAvailable)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy, color: Colors.white, size: 48),
                            SizedBox(height: 8),
                            Text(
                              'Fully Booked',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Try different dates',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite ? 'Added to favorites' : 'Removed from favorites',
                      ),
                    ),
                  );
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'share',
                    child: ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Share Hotel'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'directions',
                    child: ListTile(
                      leading: Icon(Icons.directions),
                      title: Text('Get Directions'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'call',
                    child: ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Call Hotel'),
                      dense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Hotel Info Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name and Type
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.hotel.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getHotelTypeColor(widget.hotel.hotelType).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getHotelTypeName(widget.hotel.hotelType),
                          style: TextStyle(
                            color: _getHotelTypeColor(widget.hotel.hotelType),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.hotel.address,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Rating and Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.star,
                          iconColor: Colors.amber,
                          title: 'Rating',
                          subtitle: '${widget.hotel.rating}',
                          detail: '${widget.hotel.reviewCount} reviews',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.place,
                          iconColor: Colors.blue,
                          title: 'Distance',
                          subtitle: '${widget.hotel.distanceFromCenter.toStringAsFixed(1)} km',
                          detail: 'from center',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.local_parking,
                          iconColor: Colors.green,
                          title: 'Parking',
                          subtitle: widget.hotel.amenities.contains('Parking') ? 'Available' : 'None',
                          detail: widget.hotel.amenities.contains('Parking') ? 'Free' : '',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Booking Section
                  _buildBookingSection(),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(text: 'Rooms'),
                  Tab(text: 'Amenities'),
                  Tab(text: 'Reviews'),
                  Tab(text: 'Location'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRoomsTab(),
                _buildAmenitiesTab(),
                _buildReviewsTab(),
                _buildLocationTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? detail,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (detail != null && detail.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                detail,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book Your Stay',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Date Selection
            Row(
              children: [
                Expanded(
                  child: _buildDateSelector(
                    'Check-in',
                    _checkInDate,
                    () => _selectDate(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateSelector(
                    'Check-out',
                    _checkOutDate,
                    () => _selectDate(false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Guest Selection
            Row(
              children: [
                Expanded(
                  child: _buildCountSelector(
                    'Guests',
                    _guests,
                    (value) => setState(() => _guests = value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCountSelector(
                    'Rooms',
                    _rooms,
                    (value) => setState(() => _rooms = value),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stay Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Stay Duration:'),
                      Text('$_nightCount nights'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price per night:'),
                      Text('\$${widget.hotel.pricePerNight.toStringAsFixed(0)}'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${(widget.hotel.pricePerNight * _nightCount * _rooms).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green,
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

  Widget _buildDateSelector(String label, DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(date),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountSelector(String label, int value, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: value > 1 ? () => onChanged(value - 1) : null,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: value > 1 ? Colors.grey[300] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.remove, size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => onChanged(value + 1),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.add, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _roomTypes.length,
      itemBuilder: (context, index) {
        final room = _roomTypes[index];
        return _buildRoomCard(room);
      },
    );
  }

  Widget _buildRoomCard(RoomType room) {
    final discountPercent = room.originalPrice > room.price
        ? ((room.originalPrice - room.price) / room.originalPrice * 100).round()
        : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    room.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!room.isAvailable)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Unavailable',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              room.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),

            // Room details
            Row(
              children: [
                _buildRoomDetail(Icons.hotel_outlined, '${room.size} m²'),
                const SizedBox(width: 16),
                _buildRoomDetail(Icons.people_outline, '${room.maxGuests} guests'),
                const SizedBox(width: 16),
                _buildRoomDetail(Icons.bed_outlined, room.bedType),
              ],
            ),

            const SizedBox(height: 12),

            // Amenities
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: room.amenities.map((amenity) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    amenity,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Price and booking
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (discountPercent > 0) ...[
                      Text(
                        '\$${room.originalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '\$${room.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
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
                        ],
                      ),
                    ] else
                      Text(
                        '\$${room.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    const Text(
                      'per night',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: room.isAvailable && widget.hotel.isAvailable
                      ? () => _bookRoom(room)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: room.isAvailable && widget.hotel.isAvailable
                        ? _getHotelTypeColor(widget.hotel.hotelType)
                        : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(room.isAvailable ? 'Select Room' : 'Unavailable'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAmenitySection('General', [
          _buildAmenityItem(Icons.wifi, 'Free WiFi'),
          _buildAmenityItem(Icons.local_parking, 'Free Parking'),
          _buildAmenityItem(Icons.pets, 'Pet Friendly'),
          _buildAmenityItem(Icons.accessible, 'Wheelchair Accessible'),
        ]),
        _buildAmenitySection('Recreation', [
          _buildAmenityItem(Icons.pool, 'Swimming Pool'),
          _buildAmenityItem(Icons.fitness_center, 'Fitness Center'),
          _buildAmenityItem(Icons.spa, 'Spa Services'),
          _buildAmenityItem(Icons.sports_tennis, 'Tennis Court'),
        ]),
        _buildAmenitySection('Services', [
          _buildAmenityItem(Icons.restaurant, 'Restaurant'),
          _buildAmenityItem(Icons.local_bar, 'Bar/Lounge'),
          _buildAmenityItem(Icons.room_service, 'Room Service'),
          _buildAmenityItem(Icons.business_center, 'Business Center'),
        ]),
      ],
    );
  }

  Widget _buildAmenitySection(String title, List<Widget> amenities) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...amenities,
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String name) {
    final isAvailable = widget.hotel.amenities.contains(name.replaceAll('Free ', ''));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isAvailable ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: isAvailable ? Colors.black : Colors.grey,
              ),
            ),
          ),
          Icon(
            isAvailable ? Icons.check : Icons.close,
            color: isAvailable ? Colors.green : Colors.red,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Rating Summary
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      widget.hotel.rating.toString(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < widget.hotel.rating.floor()
                              ? Icons.star
                              : Icons.star_outline,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    Text(
                      '${widget.hotel.reviewCount} reviews',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar('Cleanliness', 4.8),
                      _buildRatingBar('Location', 4.6),
                      _buildRatingBar('Service', 4.7),
                      _buildRatingBar('Value', 4.5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Individual Reviews
        _buildReviewItem(
          'John D.',
          5,
          'Excellent hotel with great service and amenities. The room was spacious and clean.',
          '2 days ago',
        ),
        _buildReviewItem(
          'Sarah M.',
          4,
          'Good location and comfortable stay. Staff was helpful and friendly.',
          '1 week ago',
        ),
        _buildReviewItem(
          'Mike R.',
          5,
          'Outstanding experience! Would definitely recommend to anyone visiting the city.',
          '2 weeks ago',
        ),
      ],
    );
  }

  Widget _buildRatingBar(String category, double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              category,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: rating / 5.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            rating.toString(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, int rating, String review, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(name[0]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_outline,
                              color: Colors.amber,
                              size: 14,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(review),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Map placeholder
        Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Map View'),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Address and contact
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(widget.hotel.address),
                    ),
                    TextButton(
                      onPressed: () => _getDirections(),
                      child: const Text('Directions'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.green),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('+1 555-0199'),
                    ),
                    TextButton(
                      onPressed: () => _callHotel(),
                      child: const Text('Call'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Nearby attractions
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nearby Attractions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildNearbyItem('Central Park', '0.3 km', Icons.park),
                _buildNearbyItem('Shopping Mall', '0.8 km', Icons.shopping_mall),
                _buildNearbyItem('Museum of Art', '1.2 km', Icons.museum),
                _buildNearbyItem('International Airport', '25 km', Icons.flight),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyItem(String name, String distance, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(name)),
          Text(
            distance,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Event handlers
  Future<void> _selectDate(bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate.isBefore(picked)) {
            _checkOutDate = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  void _bookRoom(RoomType room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book ${room.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check-in: ${_formatDate(_checkInDate)}'),
            Text('Check-out: ${_formatDate(_checkOutDate)}'),
            Text('Guests: $_guests'),
            Text('Rooms: $_rooms'),
            const SizedBox(height: 8),
            Text(
              'Total: \$${(room.price * _nightCount * _rooms).toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${room.name} booked successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sharing hotel...')),
        );
        break;
      case 'directions':
        _getDirections();
        break;
      case 'call':
        _callHotel();
        break;
    }
  }

  void _getDirections() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening directions...')),
    );
  }

  void _callHotel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling hotel...')),
    );
  }

  // Helper methods
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

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Custom delegate for the tab bar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

// Data models
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

class RoomType {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final int size;
  final int maxGuests;
  final String bedType;
  final List<String> amenities;
  final List<String> images;
  final bool isAvailable;

  RoomType({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.size,
    required this.maxGuests,
    required this.bedType,
    required this.amenities,
    required this.images,
    required this.isAvailable,
  });
}