import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Color primaryColor;
  
  const DashboardScreen({
    Key? key,
    this.primaryColor = const Color(0xFF2196F3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: primaryColor,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildCard('Users', '1,234', Icons.people),
          _buildCard('Sales', '\$5,678', Icons.attach_money),
          _buildCard('Orders', '456', Icons.shopping_cart),
          _buildCard('Revenue', '\$12,345', Icons.trending_up),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: primaryColor),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
