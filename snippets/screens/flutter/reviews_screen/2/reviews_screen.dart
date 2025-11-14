import 'package:flutter/material.dart';

class ReviewsScreen extends StatelessWidget {
  final String productName;

  ReviewsScreen({this.productName = 'Premium Cotton T-Shirt'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Write Review'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Rating Summary
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('4.5', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) => Icon(Icons.star, color: i < 4 ? Colors.amber : Colors.grey[300])),
                      ),
                      Text('Based on 120 reviews'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 80),
                      _buildRatingBar(4, 25),
                      _buildRatingBar(3, 10),
                      _buildRatingBar(2, 3),
                      _buildRatingBar(1, 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          // Reviews List
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => _buildReviewItem(index),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildRatingBar(int stars, int percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$stars'),
          SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(Colors.amber),
            ),
          ),
          SizedBox(width: 8),
          Text('$percentage%'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text('U${index + 1}')),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Row(children: List.generate(5, (i) => Icon(Icons.star, size: 16, color: i < 4 ? Colors.amber : Colors.grey[300]))),
                          SizedBox(width: 8),
                          Text('2 days ago', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Great quality product! Very satisfied with the purchase. Would definitely recommend to others.'),
            SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.thumb_up, size: 16),
                  label: Text('Helpful (5)'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Reply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}