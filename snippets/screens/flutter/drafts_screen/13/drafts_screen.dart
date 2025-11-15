import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Color primaryColor;
  final List<Map<String, String>> items;
  
  const Screen({
    Key? key,
    this.primaryColor = const Color(0xFF1976D2),
    this.items = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayItems = items.isEmpty
        ? List.generate(10, (i) => {'title': 'Item ${i + 1}', 'subtitle': 'Description'})
        : items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: displayItems.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundColor: primaryColor,
            child: Text('${index + 1}'),
          ),
          title: Text(displayItems[index]['title']!),
          subtitle: Text(displayItems[index]['subtitle']!),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
