import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<WishlistItem> wishlistItems = [
    WishlistItem(
      id: '1',
      name: 'Premium Cotton T-Shirt',
      price: 29.99,
      originalPrice: 39.99,
      image: 'assets/tshirt.jpg',
      inStock: true,
      rating: 4.5,
      reviews: 120,
    ),
    WishlistItem(
      id: '2',
      name: 'Wireless Headphones',
      price: 89.99,
      originalPrice: null,
      image: 'assets/headphones.jpg',
      inStock: true,
      rating: 4.8,
      reviews: 85,
    ),
    WishlistItem(
      id: '3',
      name: 'Designer Jacket',
      price: 199.99,
      originalPrice: 249.99,
      image: 'assets/jacket.jpg',
      inStock: false,
      rating: 4.2,
      reviews: 45,
    ),
    WishlistItem(
      id: '4',
      name: 'Smart Watch',
      price: 299.99,
      originalPrice: null,
      image: 'assets/watch.jpg',
      inStock: true,
      rating: 4.7,
      reviews: 200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist (${wishlistItems.length})'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (wishlistItems.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear_all') {
                  _showClearAllDialog();
                } else if (value == 'move_to_cart') {
                  _moveAllToCart();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'move_to_cart',
                  child: Text('Move all to cart'),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Text('Clear all'),
                ),
              ],
            ),
        ],
      ),
      body: wishlistItems.isEmpty ? _buildEmptyWishlist() : _buildWishlistContent(),
      bottomNavigationBar: wishlistItems.isNotEmpty ? _buildBottomActions() : null,
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey[400]),
          SizedBox(height: 24),
          Text(
            'Your wishlist is empty',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Save items you love for later',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Start Shopping',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: wishlistItems.length,
      itemBuilder: (context, index) {
        return _buildWishlistItem(wishlistItems[index], index);
      },
    );
  }

  Widget _buildWishlistItem(WishlistItem item, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Product Image
                GestureDetector(
                  onTap: () {
                    // Navigate to product detail
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(Icons.image, color: Colors.grey[400], size: 40),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),

                      // Rating
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                Icons.star,
                                color: i < item.rating.floor() ? Colors.amber : Colors.grey[300],
                                size: 16,
                              );
                            }),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${item.rating} (${item.reviews})',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Price
                      Row(
                        children: [
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                          if (item.originalPrice != null) ...[
                            SizedBox(width: 8),
                            Text(
                              '\$${item.originalPrice!.toStringAsFixed(2)}',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 8),

                      // Stock Status
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.inStock ? Colors.green[100] : Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.inStock ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            color: item.inStock ? Colors.green[800] : Colors.red[800],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: item.inStock ? () {
                                _addToCart(item);
                              } : null,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                side: BorderSide(
                                  color: item.inStock ? Colors.blue : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                item.inStock ? 'Add to Cart' : 'Notify Me',
                                style: TextStyle(
                                  color: item.inStock ? Colors.blue : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              // Navigate to product detail
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              'View',
                              style: TextStyle(color: Colors.grey[700], fontSize: 12),
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

          // Remove Button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                _showRemoveDialog(item, index);
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),

          // Sale Badge
          if (item.originalPrice != null)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    int inStockCount = wishlistItems.where((item) => item.inStock).length;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _shareWishlist();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share, size: 18, color: Colors.grey[700]),
                  SizedBox(width: 8),
                  Text(
                    'Share Wishlist',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: inStockCount > 0 ? () {
                _moveAllToCart();
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add All to Cart ($inStockCount)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(WishlistItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  void _moveAllToCart() {
    int inStockCount = wishlistItems.where((item) => item.inStock).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$inStockCount items moved to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  void _shareWishlist() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wishlist shared successfully')),
    );
  }

  void _showRemoveDialog(WishlistItem item, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove from Wishlist'),
        content: Text('Remove "${item.name}" from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                wishlistItems.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Removed from wishlist')),
              );
            },
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Wishlist'),
        content: Text('Are you sure you want to clear your entire wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                wishlistItems.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Wishlist cleared')),
              );
            },
            child: Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class WishlistItem {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final String image;
  final bool inStock;
  final double rating;
  final int reviews;

  WishlistItem({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.image,
    required this.inStock,
    required this.rating,
    required this.reviews,
  });
}