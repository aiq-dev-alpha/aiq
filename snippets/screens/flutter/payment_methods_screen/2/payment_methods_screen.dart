import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: '1',
      type: 'Visa',
      lastFour: '3456',
      isDefault: true,
      expiryDate: '12/25',
      holderName: 'John Doe',
    ),
    PaymentMethod(
      id: '2',
      type: 'Mastercard',
      lastFour: '7890',
      isDefault: false,
      expiryDate: '08/26',
      holderName: 'John Doe',
    ),
    PaymentMethod(
      id: '3',
      type: 'PayPal',
      lastFour: '',
      isDefault: false,
      expiryDate: '',
      holderName: 'john.doe@email.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Methods'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                return _buildPaymentMethodCard(paymentMethods[index]);
              },
            ),
          ),
          _buildAddPaymentButton(),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _getPaymentIcon(method.type),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            method.type,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (method.isDefault) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(
                                  color: Colors.blue[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4),
                      if (method.lastFour.isNotEmpty)
                        Text('•••• •••• •••• ${method.lastFour}'),
                      if (method.lastFour.isEmpty)
                        Text(method.holderName),
                      if (method.expiryDate.isNotEmpty)
                        Text(
                          'Expires ${method.expiryDate}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value, method),
                  itemBuilder: (context) => [
                    if (!method.isDefault)
                      PopupMenuItem(value: 'default', child: Text('Set as Default')),
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPaymentIcon(String type) {
    IconData icon;
    Color color;

    switch (type.toLowerCase()) {
      case 'visa':
        icon = Icons.credit_card;
        color = Colors.blue;
        break;
      case 'mastercard':
        icon = Icons.credit_card;
        color = Colors.red;
        break;
      case 'paypal':
        icon = Icons.account_balance_wallet;
        color = Colors.indigo;
        break;
      default:
        icon = Icons.payment;
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildAddPaymentButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _showAddPaymentDialog();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'ADD PAYMENT METHOD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action, PaymentMethod method) {
    switch (action) {
      case 'default':
        setState(() {
          for (var m in paymentMethods) {
            m.isDefault = false;
          }
          method.isDefault = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Set as default payment method')),
        );
        break;
      case 'edit':
        _showEditPaymentDialog(method);
        break;
      case 'delete':
        _showDeleteConfirmation(method);
        break;
    }
  }

  void _showAddPaymentDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Credit/Debit Card'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                _showCardForm();
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('PayPal'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                // Handle PayPal setup
              },
            ),
            ListTile(
              leading: Icon(Icons.phone_iphone),
              title: Text('Apple Pay'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pop(context);
                // Handle Apple Pay setup
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCardForm() {
    final _formKey = GlobalKey<FormState>();
    final _cardNumberController = TextEditingController();
    final _expiryController = TextEditingController();
    final _cvvController = TextEditingController();
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Credit Card'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: '1234 5678 9012 3456',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Cardholder Name'),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        decoration: InputDecoration(labelText: 'MM/YY'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: InputDecoration(labelText: 'CVV'),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (value) => value?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                // Add payment method
                setState(() {
                  paymentMethods.add(PaymentMethod(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: 'Visa', // Detect card type
                    lastFour: _cardNumberController.text.substring(_cardNumberController.text.length - 4),
                    isDefault: false,
                    expiryDate: _expiryController.text,
                    holderName: _nameController.text,
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment method added successfully')),
                );
              }
            },
            child: Text('Add Card'),
          ),
        ],
      ),
    );
  }

  void _showEditPaymentDialog(PaymentMethod method) {
    // Implementation for editing payment method
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit payment method functionality')),
    );
  }

  void _showDeleteConfirmation(PaymentMethod method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Payment Method'),
        content: Text('Are you sure you want to delete this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                paymentMethods.remove(method);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment method deleted')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class PaymentMethod {
  final String id;
  final String type;
  final String lastFour;
  bool isDefault;
  final String expiryDate;
  final String holderName;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFour,
    required this.isDefault,
    required this.expiryDate,
    required this.holderName,
  });
}