import 'package:flutter/material.dart';

class NotificationsCenterScreen extends StatelessWidget {
  final Color primaryColor;
  final Color unreadColor;
  
  const NotificationsCenterScreen({
    Key? key,
    this.primaryColor = const Color(0xFF1976D2),
    this.unreadColor = const Color(0xFFE3F2FD),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          color: index.isEven ? unreadColor : Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor,
              child: Icon(Icons.notifications, color: Colors.white),
            ),
            title: Text('Notification ${index + 1}'),
            subtitle: Text('${index + 1} minutes ago'),
          ),
        ),
      ),
    );
  }
}
