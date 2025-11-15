import 'package:flutter/material.dart';

class ProductGalleryScreen extends StatelessWidget {
  final Color primaryColor;
  final int gridColumns;
  
  const ProductGalleryScreen({
    Key? key,
    this.primaryColor = const Color(0xFF2196F3),
    this.gridColumns = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: primaryColor,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridColumns,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 20,
        itemBuilder: (context, index) => Card(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.shopping_bag, size: 48),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text('Product ${index + 1}'),
                    Text('\$${(index + 1) * 10}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
