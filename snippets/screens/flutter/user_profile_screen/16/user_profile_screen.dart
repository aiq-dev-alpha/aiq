import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final Color primaryColor;
  final String userName;
  
  const UserProfileScreen({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    this.userName = 'John Doe',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          CircleAvatar(
            radius: 60,
            backgroundColor: primaryColor,
            child: const Icon(Icons.person, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text('$userName@example.com'),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: const Text('+1234567890'),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Location'),
            subtitle: const Text('New York, USA'),
          ),
        ],
      ),
    );
  }
}
