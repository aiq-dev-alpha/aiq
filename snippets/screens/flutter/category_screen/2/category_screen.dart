import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  CategoryScreen({this.categoryName = 'Electronics'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Subcategory Filter
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All', 'Phones', 'Laptops', 'Headphones', 'Cameras']
                  .map((sub) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: FilterChip(label: Text(sub), selected: sub == 'All', onSelected: (v) {}),
                      ))
                  .toList(),
            ),
          ),
          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 20,
              itemBuilder: (context, index) => Card(
                elevation: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text('Product ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('\$${(index + 1) * 15}.99', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}