import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [
    CartItem(
      id: '1',
      name: 'Premium Cotton T-Shirt',
      price: 29.99,
      quantity: 2,
      size: 'M',
      color: 'Blue',
      image: 'assets/tshirt.jpg',
    ),
    CartItem(
      id: '2',
      name: 'Wireless Headphones',
      price: 89.99,
      quantity: 1,
      size: null,
      color: 'Black',
      image: 'assets/headphones.jpg',
    ),
    CartItem(
      id: '3',
      name: 'Running Shoes',
      price: 129.99,
      quantity: 1,
      size: '9',
      color: 'White',
      image: 'assets/shoes.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double shipping = 9.99;
    double tax = subtotal * 0.08;
    double total = subtotal + shipping + tax;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart (${cartItems.length})'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: cartItems.isEmpty ? null : () {
              setState(() {
                cartItems.clear();
              });
            },
            child: Text(
              'Clear All',
              style: TextStyle(color: cartItems.isEmpty ? Colors.grey : Colors.red),
            ),
          ),
        ],
      ),
      body: cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(subtotal, shipping, tax, total),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
          SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Add some items to get started',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Continue Shopping',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(double subtotal, double shipping, double tax, double total) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItem(cartItems[index], index);
            },
          ),
        ),
        _buildOrderSummary(subtotal, shipping, tax, total),
      ],
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.image, color: Colors.grey[400], size: 40),
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
                  SizedBox(height: 4),
                  if (item.size != null || item.color != null)
                    Text(
                      [item.size, item.color].where((e) => e != null).join(' • '),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  SizedBox(height: 8),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls and Actions
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: item.quantity > 1 ? () {
                        setState(() {
                          item.quantity--;
                        });
                      } : null,
                      icon: Icon(Icons.remove_circle_outline),
                      color: item.quantity > 1 ? Colors.blue : Colors.grey,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.quantity.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          item.quantity++;
                        });
                      },
                      icon: Icon(Icons.add_circle_outline),
                      color: Colors.blue,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add to wishlist
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to wishlist')),
                        );
                      },
                      child: Icon(Icons.favorite_border, color: Colors.grey[600], size: 20),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        _showRemoveDialog(item, index);
                      },
                      child: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double shipping, double tax, double total) {
    return Container(
      padding: EdgeInsets.all(20),
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
      child: Column(
        children: [
          // Promo Code
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  // Apply promo code
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Apply', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Order Summary
          Column(
            children: [
              _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
              _buildSummaryRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
              _buildSummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
              Divider(height: 20),
              _buildSummaryRow(
                'Total',
                '\$${total.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ),
          SizedBox(height: 20),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to checkout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'PROCEED TO CHECKOUT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(CartItem item, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Item'),
        content: Text('Are you sure you want to remove "${item.name}" from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                cartItems.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item removed from cart')),
              );
            },
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String? size;
  final String? color;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.size,
    this.color,
    required this.image,
  });
}