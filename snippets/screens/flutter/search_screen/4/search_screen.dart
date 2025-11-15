import 'package:flutter/material.dart';

class SearchThemeConfig {
  final Color primaryColor;
  final Color backgroundColor;
  final Color searchBarColor;
  final double searchBarRadius;

  const SearchThemeConfig({
    this.primaryColor = const Color(0xFF1976D2),
    this.backgroundColor = Colors.white,
    this.searchBarColor = const Color(0xFFF5F5F5),
    this.searchBarRadius = 24.0,
  });
}

class SearchScreen extends StatefulWidget {
  final SearchThemeConfig? theme;
  final Future<List<SearchResult>> Function(String)? onSearch;

  const SearchScreen({
    Key? key,
    this.theme,
    this.onSearch,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<SearchResult> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isSearching = true);

    final searcher = widget.onSearch ?? _defaultSearch;
    final results = await searcher(query);

    if (mounted) {
      setState(() {
        _results = results;
        _isSearching = false;
      });
    }
  }

  Future<List<SearchResult>> _defaultSearch(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      10,
      (i) => SearchResult(
        id: '$i',
        title: 'Result $i: $query',
        subtitle: 'Description for result $i',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const SearchThemeConfig();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: theme.searchBarColor,
            borderRadius: BorderRadius.circular(theme.searchBarRadius),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _results = []);
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: _performSearch,
          ),
        ),
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Start searching',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.article, color: theme.primaryColor),
                    ),
                    title: Text(_results[index].title),
                    subtitle: Text(_results[index].subtitle),
                    onTap: () {},
                  ),
                ),
    );
  }
}

class SearchResult {
  final String id;
  final String title;
  final String subtitle;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
  });
}
