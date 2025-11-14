import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedImageIndex = 0;
  String selectedSize = 'M';
  String selectedColor = 'Red';
  int quantity = 1;
  bool isFavorite = false;

  final sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final colors = ['Red', 'Blue', 'Green', 'Black', 'White'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share product
            },
          ),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            color: isFavorite ? Colors.red : null,
            onPressed: () => setState(() => isFavorite = !isFavorite),
          ),
        ],
      ),
      body: Column(
        children: [
          // Product Images
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Image
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.image, size: 100, color: Colors.grey[400]),
                    ),
                  ),

                  // Image Thumbnails
                  Container(
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedImageIndex = index),
                          child: Container(
                            width: 80,
                            margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == 4 ? 16 : 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedImageIndex == index ? Colors.blue : Colors.grey[300]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: Center(
                              child: Icon(Icons.image, color: Colors.grey[400]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Product Info
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium Cotton T-Shirt',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  color: index < 4 ? Colors.amber : Colors.grey[300],
                                  size: 20,
                                );
                              }),
                            ),
                            SizedBox(width: 8),
                            Text('4.5 (120 reviews)', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              '\$29.99',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              '\$39.99',
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '25% OFF',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Size Selection
                        Text('Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children: sizes.map((size) {
                            return GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedSize == size ? Colors.blue : Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedSize == size ? Colors.blue[50] : Colors.white,
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    color: selectedSize == size ? Colors.blue : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 24),

                        // Color Selection
                        Text('Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children: colors.map((color) {
                            return GestureDetector(
                              onTap: () => setState(() => selectedColor = color),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedColor == color ? Colors.blue : Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedColor == color ? Colors.blue[50] : Colors.white,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: _getColorFromName(color),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      color,
                                      style: TextStyle(
                                        color: selectedColor == color ? Colors.blue : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 24),

                        // Quantity Selection
                        Row(
                          children: [
                            Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Spacer(),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                                  icon: Icon(Icons.remove_circle_outline),
                                  color: quantity > 1 ? Colors.blue : Colors.grey,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    quantity.toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => setState(() => quantity++),
                                  icon: Icon(Icons.add_circle_outline),
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Description
                        Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 12),
                        Text(
                          'This premium cotton t-shirt is made from 100% organic cotton with a comfortable fit. Perfect for casual wear and everyday comfort. Machine washable and available in multiple colors and sizes.',
                          style: TextStyle(height: 1.5, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 24),

                        // Features
                        Text('Features', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeatureItem('100% Organic Cotton'),
                            _buildFeatureItem('Machine Washable'),
                            _buildFeatureItem('Comfortable Fit'),
                            _buildFeatureItem('Sustainable Production'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add to Cart Button
          Container(
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
                  child: ElevatedButton(
                    onPressed: () {
                      // Add to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to cart!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'ADD TO CART - \$${(29.99 * quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Buy now
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'BUY NOW',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Text(feature, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }
}