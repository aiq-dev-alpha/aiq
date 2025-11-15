import 'package:flutter/material.dart';

class ShoppingFlow {
  final Color primaryColor;

  const ShoppingFlow({this.primaryColor = const Color(0xFF2196F3)});

  void start(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _ProductList(color: primaryColor)),
    );
  }
}

class _ProductList extends StatelessWidget {
  final Color color;

  const _ProductList({required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products'), backgroundColor: color),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) => ListTile(
          title: Text('Product ${i + 1}'),
          subtitle: Text('\$${(i + 1) * 10}'),
          trailing: ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => _CartScreen(color: color)),
            ),
            child: const Text('Add to Cart'),
          ),
        ),
      ),
    );
  }
}

class _CartScreen extends StatelessWidget {
  final Color color;

  const _CartScreen({required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), backgroundColor: color),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, i) => ListTile(
                title: Text('Item ${i + 1}'),
                trailing: Text('\$${(i + 1) * 15}'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => _CheckoutScreen(color: color)),
              ),
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutScreen extends StatelessWidget {
  final Color color;

  const _CheckoutScreen({required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), backgroundColor: color),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: const Text('Complete Order'),
        ),
      ),
    );
  }
}
