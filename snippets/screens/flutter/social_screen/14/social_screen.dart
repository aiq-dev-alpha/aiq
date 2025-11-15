import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Color themeColor;
  
  const Screen({
    Key? key,
    this.themeColor = const Color(0xFF1976D2),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
        backgroundColor: themeColor,
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: themeColor,
                      child: Text('${index + 1}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${index + 1} hours ago',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Post content ${index + 1}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.thumb_up_outlined, size: 18, color: themeColor),
                      label: Text('${index * 5}', style: TextStyle(color: themeColor)),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.comment_outlined, size: 18, color: themeColor),
                      label: Text('${index * 2}', style: TextStyle(color: themeColor)),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.share_outlined, size: 18, color: themeColor),
                      label: Text('Share', style: TextStyle(color: themeColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
