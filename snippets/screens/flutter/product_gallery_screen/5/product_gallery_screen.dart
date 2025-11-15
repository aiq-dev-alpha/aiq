import 'package:flutter/material.dart';

class ProductGalleryConfig {
  final Color primaryColor;
  final Color accentColor;
  final double itemPadding;
  final bool showFilters;
  final GridLayout layout;

  const ProductGalleryConfig({
    this.primaryColor = const Color(0xFF6200EE),
    this.accentColor = const Color(0xFF03DAC6),
    this.itemPadding = 8.0,
    this.showFilters = true,
    this.layout = GridLayout.twoColumn,
  });
}

enum GridLayout { oneColumn, twoColumn, threeColumn }

class ProductGalleryScreen extends StatefulWidget {
  final ProductGalleryConfig config;
  final Future<List<Product>> Function()? loadProducts;

  const ProductGalleryScreen({
    Key? key,
    this.config = const ProductGalleryConfig(),
    this.loadProducts,
  }) : super(key: key);

  @override
  State<ProductGalleryScreen> createState() => _ProductGalleryScreenState();
}

class _ProductGalleryScreenState extends State<ProductGalleryScreen> {
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loader = widget.loadProducts ?? _defaultLoader;
    final data = await loader();
    setState(() {
      _products = data;
      _loading = false;
    });
  }

  Future<List<Product>> _defaultLoader() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      15,
      (i) => Product(id: '$i', name: 'Item $i', price: i * 15.0),
    );
  }

  int get _crossAxisCount {
    switch (widget.config.layout) {
      case GridLayout.oneColumn:
        return 1;
      case GridLayout.twoColumn:
        return 2;
      case GridLayout.threeColumn:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: widget.config.primaryColor,
        actions: widget.config.showFilters
            ? [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})]
            : null,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(widget.config.itemPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
                childAspectRatio: 0.8,
                crossAxisSpacing: widget.config.itemPadding,
                mainAxisSpacing: widget.config.itemPadding,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) => _ProductTile(
                product: _products[index],
                config: widget.config,
              ),
            ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  final ProductGalleryConfig config;

  const _ProductTile({
    required this.product,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: config.accentColor.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: const Center(child: Icon(Icons.shopping_bag, size: 40)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: config.primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}
