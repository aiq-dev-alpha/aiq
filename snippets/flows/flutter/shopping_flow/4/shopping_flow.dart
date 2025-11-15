import 'package:flutter/material.dart';

class ShoppingFlowTheme {
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;

  const ShoppingFlowTheme({
    this.primaryColor = const Color(0xFF2196F3),
    this.accentColor = const Color(0xFF4CAF50),
    this.backgroundColor = Colors.white,
  });
}

class ShoppingFlow {
  final ShoppingFlowTheme theme;

  const ShoppingFlow({this.theme = const ShoppingFlowTheme()});

  void startFlow(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ProductListStep(theme: theme),
      ),
    );
  }
}

class _ProductListStep extends StatelessWidget {
  final ShoppingFlowTheme theme;

  const _ProductListStep({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: theme.primaryColor,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.shopping_bag, color: theme.primaryColor),
          title: Text('Product ${index + 1}'),
          subtitle: Text('\$${(index + 1) * 10}'),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () => _navigateToCart(context),
          ),
        ),
      ),
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CartStep(theme: theme),
      ),
    );
  }
}

class _CartStep extends StatelessWidget {
  final ShoppingFlowTheme theme;

  const _CartStep({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: theme.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => ListTile(
                title: Text('Item ${index + 1}'),
                subtitle: Text('\$${(index + 1) * 15}'),
                trailing: const Icon(Icons.delete_outline),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.accentColor,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => _navigateToCheckout(context),
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCheckout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CheckoutStep(theme: theme),
      ),
    );
  }
}

class _CheckoutStep extends StatelessWidget {
  final ShoppingFlowTheme theme;

  const _CheckoutStep({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Total: \$45.00', style: TextStyle(fontSize: 18)),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.accentColor,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => _completeOrder(context),
              child: const Text('Complete Order'),
            ),
          ],
        ),
      ),
    );
  }

  void _completeOrder(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => _SuccessStep(theme: theme),
      ),
      (route) => route.isFirst,
    );
  }
}

class _SuccessStep extends StatelessWidget {
  final ShoppingFlowTheme theme;

  const _SuccessStep({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: theme.accentColor),
            const SizedBox(height: 24),
            const Text('Order Placed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
