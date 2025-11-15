import 'package:flutter/material.dart';

class InvoiceTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final Color headerColor;
  final TextStyle titleStyle;

  const InvoiceTheme({
    this.primaryColor = const Color(0xFF2196F3),
    this.backgroundColor = Colors.white,
    this.headerColor = const Color(0xFFF5F5F5),
    this.titleStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  });
}

class InvoiceScreen extends StatelessWidget {
  final InvoiceTheme? theme;
  final Invoice? invoice;

  const InvoiceScreen({
    Key? key,
    this.theme,
    this.invoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const InvoiceTheme();
    final invoiceData = invoice ?? _defaultInvoice;

    return Scaffold(
      backgroundColor: effectiveTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Invoice'),
        backgroundColor: effectiveTheme.primaryColor,
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(invoiceData, effectiveTheme),
            const SizedBox(height: 24),
            _buildBillingInfo(invoiceData, effectiveTheme),
            const SizedBox(height: 24),
            _buildItemsSection(invoiceData, effectiveTheme),
            const SizedBox(height: 24),
            _buildTotalSection(invoiceData, effectiveTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Invoice invoice, InvoiceTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.headerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('INVOICE', style: theme.titleStyle),
          const SizedBox(height: 8),
          Text('Invoice #: ${invoice.number}'),
          Text('Date: ${invoice.date}'),
        ],
      ),
    );
  }

  Widget _buildBillingInfo(Invoice invoice, InvoiceTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bill To:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(invoice.billTo.name),
              Text(invoice.billTo.address),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('From:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(invoice.billFrom.name),
              Text(invoice.billFrom.address),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(Invoice invoice, InvoiceTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: theme.headerColor,
          child: const Row(
            children: [
              Expanded(flex: 3, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        ...invoice.items.map((item) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(item.description)),
                  Expanded(child: Text('${item.quantity}')),
                  Expanded(child: Text('\$${item.price.toStringAsFixed(2)}')),
                  Expanded(child: Text('\$${(item.quantity * item.price).toStringAsFixed(2)}')),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildTotalSection(Invoice invoice, InvoiceTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.headerColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:'),
              Text('\$${invoice.subtotal.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tax (10%):'),
              Text('\$${invoice.tax.toStringAsFixed(2)}'),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: theme.titleStyle.copyWith(fontSize: 20)),
              Text('\$${invoice.total.toStringAsFixed(2)}', style: theme.titleStyle.copyWith(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  static final _defaultInvoice = Invoice(
    number: 'INV-001',
    date: '2024-01-15',
    billTo: Contact(name: 'John Doe', address: '123 Main St'),
    billFrom: Contact(name: 'Company Inc', address: '456 Business Ave'),
    items: [
      InvoiceItem(description: 'Service A', quantity: 2, price: 50.0),
      InvoiceItem(description: 'Product B', quantity: 1, price: 100.0),
    ],
  );
}

class Invoice {
  final String number;
  final String date;
  final Contact billTo;
  final Contact billFrom;
  final List<InvoiceItem> items;

  Invoice({
    required this.number,
    required this.date,
    required this.billTo,
    required this.billFrom,
    required this.items,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + (item.quantity * item.price));
  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;
}

class Contact {
  final String name;
  final String address;

  Contact({required this.name, required this.address});
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double price;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
  });
}
