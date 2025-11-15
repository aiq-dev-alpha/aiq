import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  final Color accentColor;
  
  const FeedScreen({
    Key? key,
    this.accentColor = const Color(0xFF2196F3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        backgroundColor: accentColor,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(child: Text('U${index + 1}')),
                title: Text('User ${index + 1}'),
                subtitle: Text('${index + 1} hours ago'),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Post content ${index + 1}'),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    label: Text('${index * 10}'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.comment_outlined),
                    label: Text('${index * 5}'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
