import 'package:flutter/material.dart';

class PaymentFlow {
  final Color primaryColor;

  const PaymentFlow({this.primaryColor = const Color(0xFF6200EE)});

  void start(BuildContext context, double amount) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _PaymentMethodScreen(color: primaryColor, amount: amount),
      ),
    );
  }
}

class _PaymentMethodScreen extends StatelessWidget {
  final Color color;
  final double amount;

  const _PaymentMethodScreen({required this.color, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: color,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Amount: \$${amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Credit Card'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => _CardPayment(color: color, amount: amount)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Bank Transfer'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _CardPayment extends StatelessWidget {
  final Color color;
  final double amount;

  const _CardPayment({required this.color, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Payment'), backgroundColor: color),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
