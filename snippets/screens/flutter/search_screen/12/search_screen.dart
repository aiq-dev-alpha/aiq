import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final Color primaryColor;
  
  const SearchScreen({
    Key? key,
    this.primaryColor = const Color(0xFF1976D2),
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<String> _results = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      _results = query.isEmpty
          ? []
          : List.generate(10, (i) => 'Result $i: $query');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: _search,
        ),
        backgroundColor: widget.primaryColor,
      ),
      body: ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_results[index]),
        ),
      ),
    );
  }
}
