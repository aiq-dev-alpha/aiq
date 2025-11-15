import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Color primaryColor;
  final List<Map<String, dynamic>> items;
  
  const Screen({
    Key? key,
    this.primaryColor = const Color(0xFF2196F3),
    this.items = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courses = items.isEmpty
        ? List.generate(6, (i) => {
              'title': 'Course ${i + 1}',
              'progress': (i + 1) * 15,
              'lessons': (i + 1) * 10,
            })
        : items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning'),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.school, color: primaryColor, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            courses[index]['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${courses[index]['lessons']} lessons',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: courses[index]['progress'] / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  '${courses[index]['progress']}% complete',
                  style: TextStyle(fontSize: 12, color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
