import 'package:flutter/material.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keywordsController = TextEditingController();
  final _exactPhraseController = TextEditingController();
  final _excludeWordsController = TextEditingController();
  final _authorController = TextEditingController();
  final _domainController = TextEditingController();

  String _fileType = 'any';
  String _timeRange = 'any';
  String _sortBy = 'relevance';
  bool _safeSearch = true;
  DateTimeRange? _customDateRange;
  RangeValues _sizeRange = const RangeValues(0, 100);

  final List<String> _selectedCategories = [];
  final List<String> _selectedLanguages = [];

  @override
  void dispose() {
    _keywordsController.dispose();
    _exactPhraseController.dispose();
    _excludeWordsController.dispose();
    _authorController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  void _performAdvancedSearch() {
    if (!_formKey.currentState!.validate()) return;

    final searchParams = {
      'keywords': _keywordsController.text,
      'exactPhrase': _exactPhraseController.text,
      'excludeWords': _excludeWordsController.text,
      'author': _authorController.text,
      'domain': _domainController.text,
      'fileType': _fileType,
      'timeRange': _timeRange,
      'customDateRange': _customDateRange,
      'sortBy': _sortBy,
      'safeSearch': _safeSearch,
      'sizeRange': _sizeRange,
      'categories': _selectedCategories,
      'languages': _selectedLanguages,
    };

    Navigator.pushNamed(
      context,
      '/search-results',
      arguments: searchParams,
    );
  }

  void _resetFilters() {
    setState(() {
      _keywordsController.clear();
      _exactPhraseController.clear();
      _excludeWordsController.clear();
      _authorController.clear();
      _domainController.clear();
      _fileType = 'any';
      _timeRange = 'any';
      _sortBy = 'relevance';
      _safeSearch = true;
      _customDateRange = null;
      _sizeRange = const RangeValues(0, 100);
      _selectedCategories.clear();
      _selectedLanguages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Search'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Keywords Section
            _buildSection(
              'Keywords',
              Column(
                children: [
                  TextFormField(
                    controller: _keywordsController,
                    decoration: const InputDecoration(
                      labelText: 'All of these words',
                      hintText: 'Enter keywords separated by spaces',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _exactPhraseController,
                    decoration: const InputDecoration(
                      labelText: 'This exact phrase',
                      hintText: 'Enter exact phrase',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _excludeWordsController,
                    decoration: const InputDecoration(
                      labelText: 'None of these words',
                      hintText: 'Words to exclude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            // Content Filters
            _buildSection(
              'Content Filters',
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _fileType,
                    decoration: const InputDecoration(
                      labelText: 'File Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'any', child: Text('Any')),
                      DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                      DropdownMenuItem(value: 'doc', child: Text('Document')),
                      DropdownMenuItem(value: 'image', child: Text('Image')),
                      DropdownMenuItem(value: 'video', child: Text('Video')),
                      DropdownMenuItem(value: 'audio', child: Text('Audio')),
                    ],
                    onChanged: (value) => setState(() => _fileType = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      labelText: 'Author',
                      hintText: 'Content author',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _domainController,
                    decoration: const InputDecoration(
                      labelText: 'Site or Domain',
                      hintText: 'e.g., example.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            // Categories
            _buildSection(
              'Categories',
              Wrap(
                spacing: 8,
                children: [
                  'Technology',
                  'Science',
                  'Business',
                  'Health',
                  'Entertainment',
                  'Sports',
                  'Politics',
                  'Education'
                ].map((category) => FilterChip(
                  label: Text(category),
                  selected: _selectedCategories.contains(category),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                )).toList(),
              ),
            ),

            // Time Range
            _buildSection(
              'Time Range',
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _timeRange,
                    decoration: const InputDecoration(
                      labelText: 'Time Range',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'any', child: Text('Any time')),
                      DropdownMenuItem(value: 'hour', child: Text('Past hour')),
                      DropdownMenuItem(value: 'day', child: Text('Past 24 hours')),
                      DropdownMenuItem(value: 'week', child: Text('Past week')),
                      DropdownMenuItem(value: 'month', child: Text('Past month')),
                      DropdownMenuItem(value: 'year', child: Text('Past year')),
                      DropdownMenuItem(value: 'custom', child: Text('Custom range')),
                    ],
                    onChanged: (value) => setState(() => _timeRange = value!),
                  ),
                  if (_timeRange == 'custom') ...[
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(_customDateRange == null
                          ? 'Select date range'
                          : '${_customDateRange!.start.toString().split(' ')[0]} - ${_customDateRange!.end.toString().split(' ')[0]}'),
                      trailing: const Icon(Icons.date_range),
                      onTap: _selectDateRange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Size Range
            _buildSection(
              'File Size (MB)',
              Column(
                children: [
                  Text('${_sizeRange.start.round()} MB - ${_sizeRange.end.round()} MB'),
                  RangeSlider(
                    values: _sizeRange,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    onChanged: (values) => setState(() => _sizeRange = values),
                  ),
                ],
              ),
            ),

            // Languages
            _buildSection(
              'Languages',
              Wrap(
                spacing: 8,
                children: [
                  'English',
                  'Spanish',
                  'French',
                  'German',
                  'Chinese',
                  'Japanese',
                  'Arabic',
                  'Portuguese'
                ].map((language) => FilterChip(
                  label: Text(language),
                  selected: _selectedLanguages.contains(language),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedLanguages.add(language);
                      } else {
                        _selectedLanguages.remove(language);
                      }
                    });
                  },
                )).toList(),
              ),
            ),

            // Sort and Safety
            _buildSection(
              'Options',
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _sortBy,
                    decoration: const InputDecoration(
                      labelText: 'Sort by',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'relevance', child: Text('Relevance')),
                      DropdownMenuItem(value: 'date', child: Text('Date')),
                      DropdownMenuItem(value: 'popularity', child: Text('Popularity')),
                      DropdownMenuItem(value: 'rating', child: Text('Rating')),
                    ],
                    onChanged: (value) => setState(() => _sortBy = value!),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Safe Search'),
                    subtitle: const Text('Filter explicit content'),
                    value: _safeSearch,
                    onChanged: (value) => setState(() => _safeSearch = value),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _performAdvancedSearch,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Search', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      lastDate: DateTime.now(),
      initialDateRange: _customDateRange,
    );
    if (picked != null) {
      setState(() => _customDateRange = picked);
    }
  }
}