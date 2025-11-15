import 'package:flutter/material.dart';

class PaymentFlowTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final Color successColor;

  const PaymentFlowTheme({
    this.primaryColor = const Color(0xFF6200EE),
    this.backgroundColor = Colors.white,
    this.successColor = const Color(0xFF4CAF50),
  });
}

class PaymentFlow {
  final PaymentFlowTheme theme;

  const PaymentFlow({this.theme = const PaymentFlowTheme()});

  void start(
    BuildContext context, {
    required double amount,
    Function(PaymentResult)? onComplete,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _PaymentMethodSelection(
          theme: theme,
          amount: amount,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class _PaymentMethodSelection extends StatelessWidget {
  final PaymentFlowTheme theme;
  final double amount;
  final Function(PaymentResult)? onComplete;

  const _PaymentMethodSelection({
    required this.theme,
    required this.amount,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        backgroundColor: theme.primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Amount: \$${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _PaymentOption(
            icon: Icons.credit_card,
            title: 'Credit Card',
            theme: theme,
            onTap: () => _navigateToCardPayment(context),
          ),
          const SizedBox(height: 12),
          _PaymentOption(
            icon: Icons.account_balance,
            title: 'Bank Transfer',
            theme: theme,
            onTap: () => _navigateToBankTransfer(context),
          ),
          const SizedBox(height: 12),
          _PaymentOption(
            icon: Icons.wallet,
            title: 'Digital Wallet',
            theme: theme,
            onTap: () => _navigateToWallet(context),
          ),
        ],
      ),
    );
  }

  void _navigateToCardPayment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CardPaymentScreen(
          theme: theme,
          amount: amount,
          onComplete: onComplete,
        ),
      ),
    );
  }

  void _navigateToBankTransfer(BuildContext context) {}
  void _navigateToWallet(BuildContext context) {}
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final PaymentFlowTheme theme;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _CardPaymentScreen extends StatefulWidget {
  final PaymentFlowTheme theme;
  final double amount;
  final Function(PaymentResult)? onComplete;

  const _CardPaymentScreen({
    required this.theme,
    required this.amount,
    this.onComplete,
  });

  @override
  State<_CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<_CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => _PaymentSuccessScreen(
            theme: widget.theme,
            amount: widget.amount,
          ),
        ),
      );
      widget.onComplete?.call(PaymentResult(success: true, amount: widget.amount));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Card Payment'),
        backgroundColor: widget.theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Amount: \$${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v?.length == 16 ? null : 'Invalid card number',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'MM/YY',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (v) => v?.contains('/') == true ? null : 'Invalid expiry',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (v) => v?.length == 3 ? null : 'Invalid CVV',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.theme.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _processPayment,
                child: const Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentSuccessScreen extends StatelessWidget {
  final PaymentFlowTheme theme;
  final double amount;

  const _PaymentSuccessScreen({
    required this.theme,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: theme.successColor),
            const SizedBox(height: 24),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentResult {
  final bool success;
  final double amount;

  PaymentResult({required this.success, required this.amount});
}
