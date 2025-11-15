import 'package:flutter/material.dart';

abstract class ProductGalleryStyler {
  Color get backgroundColor;
  Color get itemBackground;
  Color get textPrimary;
  Color get textSecondary;
  double get spacing;
  BorderRadius get cardRadius;
  int get columns;
}

class MinimalProductGalleryStyle implements ProductGalleryStyler {
  @override
  Color get backgroundColor => const Color(0xFFFAFAFA);
  @override
  Color get itemBackground => Colors.white;
  @override
  Color get textPrimary => Colors.black87;
  @override
  Color get textSecondary => Colors.black54;
  @override
  double get spacing => 12.0;
  @override
  BorderRadius get cardRadius => BorderRadius.circular(4);
  @override
  int get columns => 2;
}

class ProductGalleryScreen extends StatelessWidget {
  final ProductGalleryStyler style;
  final List<GalleryProduct> products;
  final Function(GalleryProduct)? onProductTap;

  const ProductGalleryScreen({
    Key? key,
    ProductGalleryStyler? style,
    List<GalleryProduct>? products,
    this.onProductTap,
  })  : style = style ?? const MinimalProductGalleryStyle(),
        products = products ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = products.isEmpty ? _generateDemoProducts() : products;

    return Scaffold(
      backgroundColor: style.backgroundColor,
      appBar: AppBar(
        title: const Text('Products'),
        elevation: 0,
        backgroundColor: style.backgroundColor,
        foregroundColor: style.textPrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(style.spacing),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: style.columns,
            childAspectRatio: 0.7,
            crossAxisSpacing: style.spacing,
            mainAxisSpacing: style.spacing,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildProductCard(items[index]),
        ),
      ),
    );
  }

  Widget _buildProductCard(GalleryProduct product) {
    return GestureDetector(
      onTap: () => onProductTap?.call(product),
      child: Container(
        decoration: BoxDecoration(
          color: style.itemBackground,
          borderRadius: style.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.vertical(
                    top: style.cardRadius.topLeft,
                  ),
                ),
                child: product.image != null
                    ? Image.network(product.image!, fit: BoxFit.cover)
                    : const Icon(Icons.image_outlined, size: 48),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        color: style.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: style.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<GalleryProduct> _generateDemoProducts() {
    return List.generate(
      12,
      (i) => GalleryProduct(
        id: 'p$i',
        title: 'Product ${i + 1}',
        price: (i + 1) * 12.99,
      ),
    );
  }
}

class GalleryProduct {
  final String id;
  final String title;
  final double price;
  final String? image;

  GalleryProduct({
    required this.id,
    required this.title,
    required this.price,
    this.image,
  });
}
