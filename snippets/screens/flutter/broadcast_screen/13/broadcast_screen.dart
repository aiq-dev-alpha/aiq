import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Color accentColor;
  final List<Map<String, String>> articles;
  
  const Screen({
    Key? key,
    this.accentColor = const Color(0xFF2196F3),
    this.articles = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = articles.isEmpty
        ? List.generate(8, (i) => {
              'title': 'Article ${i + 1}',
              'excerpt': 'This is a preview of article ${i + 1}',
              'author': 'Author ${i + 1}',
            })
        : articles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content'),
        backgroundColor: accentColor,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(Icons.article, size: 48, color: accentColor),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  items[index]['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  items[index]['excerpt']!,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Text(
                  'By ${items[index]['author']}',
                  style: TextStyle(fontSize: 12, color: accentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
