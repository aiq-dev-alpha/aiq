import 'package:flutter/material.dart';

class ProductGalleryTheme {
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final double gridSpacing;
  final int crossAxisCount;
  final double cardRadius;

  const ProductGalleryTheme({
    this.backgroundColor = Colors.white,
    this.cardColor = const Color(0xFFF5F5F5),
    this.textColor = Colors.black87,
    this.gridSpacing = 16.0,
    this.crossAxisCount = 2,
    this.cardRadius = 12.0,
  });
}

class ProductGalleryScreen extends StatelessWidget {
  final ProductGalleryTheme? theme;
  final List<ProductItem>? items;

  const ProductGalleryScreen({
    Key? key,
    this.theme,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const ProductGalleryTheme();
    final products = items ?? _defaultProducts;

    return Scaffold(
      backgroundColor: effectiveTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Products'),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(effectiveTheme.gridSpacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: effectiveTheme.crossAxisCount,
          childAspectRatio: 0.75,
          crossAxisSpacing: effectiveTheme.gridSpacing,
          mainAxisSpacing: effectiveTheme.gridSpacing,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => _ProductCard(
          product: products[index],
          theme: effectiveTheme,
        ),
      ),
    );
  }

  static final _defaultProducts = List.generate(
    20,
    (i) => ProductItem(
      id: 'product_$i',
      name: 'Product ${i + 1}',
      price: (i + 1) * 10.0,
      imageUrl: '',
    ),
  );
}

class _ProductCard extends StatelessWidget {
  final ProductItem product;
  final ProductGalleryTheme theme;

  const _ProductCard({
    required this.product,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(theme.cardRadius),
                ),
              ),
              child: const Center(child: Icon(Icons.image, size: 48)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    color: theme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: theme.textColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}
