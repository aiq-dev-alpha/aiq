import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int currentStep = 0;
  String selectedPaymentMethod = 'card';
  bool saveAddress = false;
  bool sameAsBilling = true;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress Indicator
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStepIndicator(0, 'Shipping', Icons.local_shipping),
                  Expanded(child: Divider()),
                  _buildStepIndicator(1, 'Payment', Icons.payment),
                  Expanded(child: Divider()),
                  _buildStepIndicator(2, 'Review', Icons.check_circle),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: _buildCurrentStep(),
              ),
            ),

            // Order Summary
            _buildOrderSummary(),

            // Continue Button
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    bool isActive = currentStep >= step;
    bool isCurrent = currentStep == step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey[300],
            shape: BoxShape.circle,
            border: isCurrent ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey[600],
            size: 20,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.blue : Colors.grey[600],
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return _buildShippingStep();
      case 1:
        return _buildPaymentStep();
      case 2:
        return _buildReviewStep();
      default:
        return Container();
    }
  }

  Widget _buildShippingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),

        // Contact Information
        Text(
          'Contact Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter your email';
            if (!value!.contains('@')) return 'Please enter a valid email';
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter your phone number';
            return null;
          },
        ),
        SizedBox(height: 24),

        // Shipping Address
        Text(
          'Shipping Address',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  return null;
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter your address';
            return null;
          },
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  return null;
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                items: ['CA', 'NY', 'TX', 'FL', 'WA']
                    .map((state) => DropdownMenuItem(value: state, child: Text(state)))
                    .toList(),
                onChanged: (value) {},
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  return null;
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _zipController,
                decoration: InputDecoration(
                  labelText: 'ZIP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        CheckboxListTile(
          value: saveAddress,
          onChanged: (value) => setState(() => saveAddress = value!),
          title: Text('Save this address for future orders'),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),

        SizedBox(height: 24),

        // Shipping Options
        Text(
          'Shipping Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        _buildShippingOption('Standard Shipping', '5-7 business days', 9.99, true),
        _buildShippingOption('Express Shipping', '2-3 business days', 19.99, false),
        _buildShippingOption('Next Day Delivery', '1 business day', 29.99, false),
      ],
    );
  }

  Widget _buildShippingOption(String title, String duration, double price, bool selected) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: RadioListTile<String>(
        value: title,
        groupValue: selected ? title : '',
        onChanged: (value) {
          // Handle shipping method selection
        },
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(duration),
        secondary: Text(
          '\$${price.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),

        // Payment Method Selection
        Text(
          'Payment Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),

        // Payment Options
        _buildPaymentOption('card', 'Credit/Debit Card', Icons.credit_card),
        _buildPaymentOption('paypal', 'PayPal', Icons.account_balance_wallet),
        _buildPaymentOption('apple', 'Apple Pay', Icons.phone_iphone),
        _buildPaymentOption('google', 'Google Pay', Icons.android),

        if (selectedPaymentMethod == 'card') ...[
          SizedBox(height: 24),
          Text(
            'Card Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.credit_card),
              hintText: '1234 5678 9012 3456',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter card number';
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _cardHolderController,
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter cardholder name';
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  decoration: InputDecoration(
                    labelText: 'MM/YY',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.security),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],

        SizedBox(height: 24),

        // Billing Address
        Text(
          'Billing Address',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        CheckboxListTile(
          value: sameAsBilling,
          onChanged: (value) => setState(() => sameAsBilling = value!),
          title: Text('Same as shipping address'),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedPaymentMethod,
        onChanged: (val) => setState(() => selectedPaymentMethod = val!),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        secondary: Icon(icon),
      ),
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Review',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),

        // Order Items
        Text(
          'Order Items',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        _buildOrderItem('Premium Cotton T-Shirt', 'Size: M, Color: Blue', 29.99, 2),
        _buildOrderItem('Wireless Headphones', 'Color: Black', 89.99, 1),

        SizedBox(height: 24),

        // Shipping Address
        Text(
          'Shipping Address',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Doe'),
                Text('123 Main Street'),
                Text('San Francisco, CA 94102'),
                Text('(555) 123-4567'),
                Text('john.doe@email.com'),
              ],
            ),
          ),
        ),

        SizedBox(height: 24),

        // Payment Method
        Text(
          'Payment Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.credit_card),
                SizedBox(width: 12),
                Text('•••• •••• •••• 3456'),
                Spacer(),
                Text('Visa'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(String name, String details, double price, int quantity) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, color: Colors.grey[400]),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
                  Text(details, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Qty: $quantity'),
                Text(
                  '\$${(price * quantity).toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal'),
              Text('\$149.97'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping'),
              Text('\$9.99'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax'),
              Text('\$12.00'),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '\$171.96',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Back'),
              ),
            ),
          if (currentStep > 0) SizedBox(width: 16),
          Expanded(
            flex: currentStep > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _handleContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                currentStep == 2 ? 'Place Order' : 'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleContinue() {
    if (currentStep < 2) {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => currentStep++);
      }
    } else {
      // Place order
      Navigator.pushReplacementNamed(context, '/order-confirmation');
    }
  }
}