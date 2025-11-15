import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Color primaryColor;
  final List<Map<String, dynamic>> items;
  
  const Screen({
    Key? key,
    this.primaryColor = const Color(0xFF4CAF50),
    this.items = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayItems = items.isEmpty 
        ? List.generate(5, (i) => {'title': 'Item ${i + 1}', 'amount': '\$${(i + 1) * 10}'})
        : items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen'),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: primaryColor,
            child: const Column(
              children: [
                Text(
                  '\$1,234.56',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Total Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayItems.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(displayItems[index]['title']),
                trailing: Text(
                  displayItems[index]['amount'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
