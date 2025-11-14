import 'package:flutter/material.dart';

enum CheckoutStep { cart, shipping, payment, review, confirmation }

class CheckoutFlowScreen extends StatefulWidget {
  const CheckoutFlowScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutFlowScreen> createState() => _CheckoutFlowScreenState();
}

class _CheckoutFlowScreenState extends State<CheckoutFlowScreen> {
  CheckoutStep _currentStep = CheckoutStep.cart;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final currentIndex = CheckoutStep.values.indexOf(_currentStep);
    if (currentIndex < CheckoutStep.values.length - 1) {
      setState(() {
        _currentStep = CheckoutStep.values[currentIndex + 1];
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    final currentIndex = CheckoutStep.values.indexOf(_currentStep);
    if (currentIndex > 0) {
      setState(() {
        _currentStep = CheckoutStep.values[currentIndex - 1];
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: _currentStep != CheckoutStep.cart &&
                _currentStep != CheckoutStep.confirmation
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: Column(
        children: [
          if (_currentStep != CheckoutStep.confirmation)
            _buildStepper(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _CartStep(onNext: _nextStep),
                _ShippingStep(onNext: _nextStep),
                _PaymentStep(onNext: _nextStep),
                _ReviewStep(onNext: _nextStep),
                _ConfirmationStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final steps = [
      ('Cart', CheckoutStep.cart),
      ('Shipping', CheckoutStep.shipping),
      ('Payment', CheckoutStep.payment),
      ('Review', CheckoutStep.review),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            _StepIndicator(
              label: steps[i].$1,
              isActive: _currentStep == steps[i].$2,
              isCompleted: CheckoutStep.values.indexOf(_currentStep) >
                  CheckoutStep.values.indexOf(steps[i].$2),
              stepNumber: i + 1,
            ),
            if (i < steps.length - 1)
              Expanded(
                child: Container(
                  height: 2,
                  color: CheckoutStep.values.indexOf(_currentStep) > i
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isCompleted;
  final int stepNumber;

  const _StepIndicator({
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive
                ? Theme.of(context).primaryColor
                : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _CartStep extends StatelessWidget {
  final VoidCallback onNext;

  const _CartStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                  ),
                  title: Text('Product ${index + 1}'),
                  subtitle: Text('\$${(index + 1) * 29.99}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {},
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('\$89.97', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Continue to Shipping'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShippingStep extends StatelessWidget {
  final VoidCallback onNext;

  const _ShippingStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Full Name')),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Address')),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'City')),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Postal Code')),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Continue to Payment'),
          ),
        ],
      ),
    );
  }
}

class _PaymentStep extends StatelessWidget {
  final VoidCallback onNext;

  const _PaymentStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Card Number')),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: TextField(decoration: InputDecoration(labelText: 'Expiry'))),
              const SizedBox(width: 16),
              Expanded(child: TextField(decoration: InputDecoration(labelText: 'CVV'))),
            ],
          ),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Cardholder Name')),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Review Order'),
          ),
        ],
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final VoidCallback onNext;

  const _ReviewStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('3 items - \$89.97'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 100, color: Colors.green),
          const SizedBox(height: 24),
          const Text('Order Confirmed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Order #12345', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}