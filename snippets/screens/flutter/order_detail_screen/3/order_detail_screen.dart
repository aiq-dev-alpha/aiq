import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId = 'ORD-2024-001234';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share order details
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order Status Timeline
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Status',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildStatusTimeline(),
                  ],
                ),
              ),
            ),

            // Order Information
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildInfoRow('Order Number', orderId),
                    _buildInfoRow('Order Date', 'March 10, 2024'),
                    _buildInfoRow('Expected Delivery', 'March 15, 2024'),
                    _buildInfoRow('Tracking Number', 'TN123456789'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Items Ordered
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Items Ordered',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildOrderItem('Premium Cotton T-Shirt', 'Size: M, Color: Blue', 29.99, 2),
                    Divider(height: 24),
                    _buildOrderItem('Wireless Headphones', 'Color: Black', 89.99, 1),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Shipping Address
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_shipping, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Shipping Address',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('John Doe'),
                    Text('123 Main Street'),
                    Text('San Francisco, CA 94102'),
                    Text('United States'),
                    SizedBox(height: 8),
                    Text('Phone: (555) 123-4567'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Order Summary
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildSummaryRow('Subtotal', '\$149.97'),
                    _buildSummaryRow('Shipping', '\$9.99'),
                    _buildSummaryRow('Tax', '\$12.00'),
                    Divider(height: 20),
                    _buildSummaryRow('Total', '\$171.96', isTotal: true),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Action Buttons
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Track shipment
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'TRACK SHIPMENT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Contact support
                          },
                          child: Text('Contact Support'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Reorder items
                          },
                          child: Text('Reorder'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline() {
    final statuses = [
      TimelineStatus('Order Placed', 'March 10, 2024 10:30 AM', true),
      TimelineStatus('Order Confirmed', 'March 10, 2024 11:00 AM', true),
      TimelineStatus('Processing', 'March 10, 2024 02:15 PM', true),
      TimelineStatus('Shipped', 'March 12, 2024 09:00 AM', true),
      TimelineStatus('Out for Delivery', 'March 15, 2024 08:00 AM', false),
      TimelineStatus('Delivered', '', false),
    ];

    return Column(
      children: statuses.asMap().entries.map((entry) {
        int index = entry.key;
        TimelineStatus status = entry.value;
        bool isLast = index == statuses.length - 1;

        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: status.isCompleted ? Colors.green : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: status.isCompleted
                      ? Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 30,
                      color: status.isCompleted ? Colors.green : Colors.grey[300],
                    ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: status.isCompleted ? Colors.black : Colors.grey[600],
                        ),
                      ),
                      if (status.time.isNotEmpty)
                        Text(
                          status.time,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String details, double price, int quantity) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.image, color: Colors.grey[400]),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
              Text(details, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
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
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineStatus {
  final String title;
  final String time;
  final bool isCompleted;

  TimelineStatus(this.title, this.time, this.isCompleted);
}