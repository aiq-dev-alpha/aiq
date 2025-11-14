import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  List<CartItem> _cartItems = [];

  final List<MenuCategory> _menuCategories = [
    MenuCategory(
      id: '1',
      name: 'Appetizers',
      items: [
        MenuItem(
          id: '1',
          name: 'Bruschetta Trio',
          description: 'Three varieties of our house-made bruschetta with fresh basil',
          price: 12.99,
          imageUrl: 'https://via.placeholder.com/150x150',
          isPopular: true,
          isVegetarian: true,
        ),
        MenuItem(
          id: '2',
          name: 'Calamari Fritti',
          description: 'Crispy fried squid rings with spicy marinara sauce',
          price: 14.99,
          imageUrl: 'https://via.placeholder.com/150x150',
          isPopular: false,
          isVegetarian: false,
        ),
      ],
    ),
    MenuCategory(
      id: '2',
      name: 'Main Courses',
      items: [
        MenuItem(
          id: '3',
          name: 'Margherita Pizza',
          description: 'Fresh mozzarella, tomato sauce, basil, extra virgin olive oil',
          price: 16.99,
          imageUrl: 'https://via.placeholder.com/150x150',
          isPopular: true,
          isVegetarian: true,
        ),
        MenuItem(
          id: '4',
          name: 'Spaghetti Carbonara',
          description: 'Classic Roman pasta with pancetta, eggs, and Pecorino Romano',
          price: 18.99,
          imageUrl: 'https://via.placeholder.com/150x150',
          isPopular: true,
          isVegetarian: false,
        ),
        MenuItem(
          id: '5',
          name: 'Osso Buco',
          description: 'Slow-braised veal shanks with risotto Milanese',
          price: 28.99,
          imageUrl: 'https://via.placeholder.com/150x150',
          isPopular: false,
          isVegetarian: false,
        ),
      ],
    ),
    MenuCategory(
      id: '3',
      name: 'Desserts',
      items: [
        MenuItem(
          id: '6',
          name: 'Tiramisu',
          description: 'Classic Italian dessert with mascarpone and espresso',
          price: 8.99,
          imageUrl: 'https://via.placeholder.com/150x150',
          isPopular: true,
          isVegetarian: true,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  double get _cartTotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.menuItem.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Restaurant Header
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
                          _getCuisineColor(widget.restaurant.cuisine).withOpacity(0.8),
                          _getCuisineColor(widget.restaurant.cuisine),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  // Status overlay
                  if (!widget.restaurant.isOpen)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, color: Colors.white, size: 48),
                            SizedBox(height: 8),
                            Text(
                              'Currently Closed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Opens at 11:00 AM',
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
                      title: Text('Share Restaurant'),
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
                      title: Text('Call Restaurant'),
                      dense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Restaurant Info
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.restaurant.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriceColor(widget.restaurant.priceRange).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getPriceRangeText(widget.restaurant.priceRange),
                          style: TextStyle(
                            color: _getPriceColor(widget.restaurant.priceRange),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.restaurant.cuisine,
                    style: TextStyle(
                      color: _getCuisineColor(widget.restaurant.cuisine),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
                          subtitle: '${widget.restaurant.rating} (${widget.restaurant.reviewCount})',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.access_time,
                          iconColor: Colors.green,
                          title: 'Delivery',
                          subtitle: widget.restaurant.deliveryTime,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.delivery_dining,
                          iconColor: Colors.blue,
                          title: 'Fee',
                          subtitle: '\$${widget.restaurant.deliveryFee}',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.restaurant.address,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _getDirections(),
                        child: const Text('Directions'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Phone
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.restaurant.phoneNumber,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _callRestaurant(),
                        child: const Text('Call'),
                      ),
                    ],
                  ),
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
                  Tab(text: 'Menu'),
                  Tab(text: 'Reviews'),
                  Tab(text: 'Photos'),
                  Tab(text: 'Info'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMenuTab(),
                _buildReviewsTab(),
                _buildPhotosTab(),
                _buildInfoTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _cartItems.isNotEmpty
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_cartItems.length} items',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '\$${_cartTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: widget.restaurant.isOpen ? () => _viewCart() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getCuisineColor(widget.restaurant.cuisine),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('View Cart'),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
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
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _menuCategories.length,
      itemBuilder: (context, index) {
        final category = _menuCategories[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...category.items.map((item) => _buildMenuItem(item)).toList(),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.fastfood, size: 32, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (item.isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Popular',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (item.isVegetarian)
                        Container(
                          margin: EdgeInsets.only(left: item.isPopular ? 4 : 0),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Vegetarian',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: widget.restaurant.isOpen
                            ? () => _addToCart(item)
                            : null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Add to Cart'),
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

  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildReviewItem(
          'Sarah M.',
          5,
          'Amazing food and great service! The pasta was perfectly cooked.',
          '2 days ago',
        ),
        _buildReviewItem(
          'Mike R.',
          4,
          'Good portions and tasty dishes. Delivery was quick.',
          '1 week ago',
        ),
        _buildReviewItem(
          'Lisa K.',
          5,
          'Best Italian restaurant in the area. Highly recommend!',
          '2 weeks ago',
        ),
      ],
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
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
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

  Widget _buildPhotosTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.photo, size: 48, color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hours',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildHourItem('Monday', '11:00 AM - 10:00 PM'),
                _buildHourItem('Tuesday', '11:00 AM - 10:00 PM'),
                _buildHourItem('Wednesday', '11:00 AM - 10:00 PM'),
                _buildHourItem('Thursday', '11:00 AM - 11:00 PM'),
                _buildHourItem('Friday', '11:00 AM - 11:00 PM'),
                _buildHourItem('Saturday', '10:00 AM - 11:00 PM'),
                _buildHourItem('Sunday', '10:00 AM - 10:00 PM'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Authentic Italian cuisine made with the freshest ingredients. Family owned and operated since 1995.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Features',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                _buildFeatureItem(Icons.delivery_dining, 'Delivery'),
                _buildFeatureItem(Icons.takeout_dining, 'Takeout'),
                _buildFeatureItem(Icons.credit_card, 'Card Payment'),
                _buildFeatureItem(Icons.accessible, 'Wheelchair Accessible'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHourItem(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day),
          Text(
            hours,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Text(feature),
        ],
      ),
    );
  }

  void _addToCart(MenuItem item) {
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.menuItem.id == item.id);

    setState(() {
      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItem(menuItem: item, quantity: 1));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} added to cart')),
    );
  }

  void _viewCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cart view would be implemented here')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sharing restaurant...')),
        );
        break;
      case 'directions':
        _getDirections();
        break;
      case 'call':
        _callRestaurant();
        break;
    }
  }

  void _getDirections() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening directions...')),
    );
  }

  void _callRestaurant() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling ${widget.restaurant.phoneNumber}...')),
    );
  }

  // Helper methods
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

class MenuCategory {
  final String id;
  final String name;
  final List<MenuItem> items;

  MenuCategory({
    required this.id,
    required this.name,
    required this.items,
  });
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isPopular;
  final bool isVegetarian;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isPopular,
    required this.isVegetarian,
  });
}

class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({
    required this.menuItem,
    required this.quantity,
  });
}