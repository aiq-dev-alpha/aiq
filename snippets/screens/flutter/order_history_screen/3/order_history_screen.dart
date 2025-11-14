import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String selectedTab = 'All';
  final tabs = ['All', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

  final orders = [
    OrderHistory(
      id: 'ORD-2024-001234',
      date: 'March 10, 2024',
      status: 'Delivered',
      total: 171.96,
      items: 2,
      trackingNumber: 'TN123456789',
    ),
    OrderHistory(
      id: 'ORD-2024-001233',
      date: 'March 5, 2024',
      status: 'Shipped',
      total: 89.99,
      items: 1,
      trackingNumber: 'TN123456788',
    ),
    OrderHistory(
      id: 'ORD-2024-001232',
      date: 'February 28, 2024',
      status: 'Processing',
      total: 249.98,
      items: 3,
      trackingNumber: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search orders
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Filter Tabs
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: FilterChip(
                    label: Text(tabs[index]),
                    selected: selectedTab == tabs[index],
                    onSelected: (selected) {
                      setState(() => selectedTab = tabs[index]);
                    },
                  ),
                );
              },
            ),
          ),

          // Orders List
          Expanded(
            child: orders.isEmpty ? _buildEmptyState() : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 100, color: Colors.grey[400]),
          SizedBox(height: 24),
          Text(
            'No orders found',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Your order history will appear here',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(OrderHistory order) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to order detail
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Order Date: ${order.date}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.shopping_bag, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${order.items} items',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.attach_money, size: 16, color: Colors.blue),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              if (order.trackingNumber != null) ..[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping, size: 16, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Tracking: ${order.trackingNumber}',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 12),
              Row(
                children: [
                  if (order.status == 'Delivered')
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Reorder
                        },
                        child: Text('Reorder'),
                      ),
                    ),
                  if (order.status == 'Processing')
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Cancel order
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                        ),
                        child: Text('Cancel', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  if (order.status == 'Processing' || order.status == 'Delivered')
                    SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // View details
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('View Details', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'delivered':
        color = Colors.green;
        break;
      case 'shipped':
        color = Colors.blue;
        break;
      case 'processing':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class OrderHistory {
  final String id;
  final String date;
  final String status;
  final double total;
  final int items;
  final String? trackingNumber;

  OrderHistory({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
    this.trackingNumber,
  });
}