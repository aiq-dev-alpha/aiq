import 'package:flutter/material.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'English';
  String _selectedRegion = 'United States';
  String _dateFormat = 'MM/DD/YYYY';
  String _timeFormat = '12-hour';
  String _numberFormat = '1,234.56';
  bool _autoDetectLanguage = false;

  final Map<String, String> _languages = {
    'English': '🇺🇸',
    'Spanish': '🇪🇸',
    'French': '🇫🇷',
    'German': '🇩🇪',
    'Italian': '🇮🇹',
    'Portuguese': '🇵🇹',
    'Russian': '🇷🇺',
    'Chinese (Simplified)': '🇨🇳',
    'Chinese (Traditional)': '🇹🇼',
    'Japanese': '🇯🇵',
    'Korean': '🇰🇷',
    'Arabic': '🇸🇦',
    'Hindi': '🇮🇳',
    'Dutch': '🇳🇱',
    'Swedish': '🇸🇪',
    'Norwegian': '🇳🇴',
    'Danish': '🇩🇰',
    'Finnish': '🇫🇮',
  };

  final Map<String, List<String>> _regions = {
    'English': ['United States', 'United Kingdom', 'Canada', 'Australia'],
    'Spanish': ['Spain', 'Mexico', 'Argentina', 'Colombia'],
    'French': ['France', 'Canada', 'Belgium', 'Switzerland'],
    'German': ['Germany', 'Austria', 'Switzerland'],
    'Italian': ['Italy', 'Switzerland'],
    'Portuguese': ['Portugal', 'Brazil'],
    'Chinese (Simplified)': ['China', 'Singapore'],
    'Chinese (Traditional)': ['Taiwan', 'Hong Kong'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language & Region'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        actions: [
          TextButton(
            onPressed: _saveLanguageSettings,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Language Selection
          _buildSectionHeader('Language'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Auto-detect Language'),
                  subtitle: const Text('Use system language settings'),
                  value: _autoDetectLanguage,
                  onChanged: (value) {
                    setState(() {
                      _autoDetectLanguage = value;
                    });
                  },
                ),
                if (!_autoDetectLanguage) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: Text(
                      _languages[_selectedLanguage] ?? '🌐',
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: const Text('App Language'),
                    subtitle: Text(_selectedLanguage),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _showLanguageSelector,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Region Selection
          _buildSectionHeader('Region & Format'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Region'),
                  subtitle: Text(_selectedRegion),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showRegionSelector,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date Format'),
                  subtitle: Text('$_dateFormat (${_formatDateExample()})'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showDateFormatSelector,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Time Format'),
                  subtitle: Text('$_timeFormat (${_formatTimeExample()})'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showTimeFormatSelector,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.numbers),
                  title: const Text('Number Format'),
                  subtitle: Text(_numberFormat),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showNumberFormatSelector,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Preview Section
          _buildSectionHeader('Preview'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Format Preview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPreviewItem(Icons.calendar_today, 'Date', _formatDateExample()),
                  _buildPreviewItem(Icons.access_time, 'Time', _formatTimeExample()),
                  _buildPreviewItem(Icons.numbers, 'Number', _numberFormat),
                  _buildPreviewItem(Icons.attach_money, 'Currency', _formatCurrencyExample()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Additional Settings
          _buildSectionHeader('Additional Settings'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Download Language Pack'),
                  subtitle: const Text('For offline translation'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showLanguagePackDialog,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.translate),
                  title: const Text('Translation Settings'),
                  subtitle: const Text('Configure auto-translation'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showTranslationSettings,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.keyboard),
                  title: const Text('Keyboard Settings'),
                  subtitle: const Text('Input method preferences'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showKeyboardSettings,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Available Languages Info
          Card(
            color: Colors.blue.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Available Languages',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We currently support ${_languages.length} languages. '
                    'If you don\'t see your preferred language, you can help us by contributing translations.',
                    style: TextStyle(
                      color: Colors.blue[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _showContributeDialog,
                    child: const Text('Contribute Translations'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPreviewItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final language = _languages.keys.elementAt(index);
              final flag = _languages[language]!;

              return RadioListTile<String>(
                title: Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Text(language),
                  ],
                ),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // Update region to first available for this language
                    if (_regions.containsKey(value)) {
                      _selectedRegion = _regions[value]!.first;
                    }
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showRegionSelector() {
    final availableRegions = _regions[_selectedLanguage] ?? ['Default'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Region'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableRegions.map((region) {
            return RadioListTile<String>(
              title: Text(region),
              value: region,
              groupValue: _selectedRegion,
              onChanged: (value) {
                setState(() {
                  _selectedRegion = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDateFormatSelector() {
    final formats = ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD', 'DD.MM.YYYY'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Date Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.map((format) {
            return RadioListTile<String>(
              title: Text(format),
              subtitle: Text(_formatDateWithFormat(format)),
              value: format,
              groupValue: _dateFormat,
              onChanged: (value) {
                setState(() {
                  _dateFormat = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showTimeFormatSelector() {
    final formats = ['12-hour', '24-hour'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.map((format) {
            return RadioListTile<String>(
              title: Text(format),
              subtitle: Text(_formatTimeWithFormat(format)),
              value: format,
              groupValue: _timeFormat,
              onChanged: (value) {
                setState(() {
                  _timeFormat = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showNumberFormatSelector() {
    final formats = ['1,234.56', '1.234,56', '1 234,56', '1234.56'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Number Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.map((format) {
            return RadioListTile<String>(
              title: Text(format),
              value: format,
              groupValue: _numberFormat,
              onChanged: (value) {
                setState(() {
                  _numberFormat = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLanguagePackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language Packs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Downloaded language packs:'),
            const SizedBox(height: 16),
            _buildLanguagePackItem('English', '45 MB', true),
            _buildLanguagePackItem('Spanish', '38 MB', false),
            _buildLanguagePackItem('French', '42 MB', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagePackItem(String language, String size, bool isDownloaded) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(size, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          if (isDownloaded)
            const Icon(Icons.check_circle, color: Colors.green)
          else
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Downloading $language language pack...')),
                );
              },
              child: const Text('Download'),
            ),
        ],
      ),
    );
  }

  void _showTranslationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Translation Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Auto-translate'),
              subtitle: const Text('Automatically translate messages'),
              value: true,
              onChanged: (value) {},
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: const Text('Show original'),
              subtitle: const Text('Show original text with translation'),
              value: false,
              onChanged: (value) {},
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showKeyboardSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening system keyboard settings...')),
    );
  }

  void _showContributeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contribute Translations'),
        content: const Text(
          'Help us make this app available in more languages! '
          'Visit our translation portal to contribute.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening translation portal...')),
              );
            },
            child: const Text('Contribute'),
          ),
        ],
      ),
    );
  }

  String _formatDateExample() {
    return _formatDateWithFormat(_dateFormat);
  }

  String _formatDateWithFormat(String format) {
    switch (format) {
      case 'MM/DD/YYYY':
        return '12/25/2023';
      case 'DD/MM/YYYY':
        return '25/12/2023';
      case 'YYYY-MM-DD':
        return '2023-12-25';
      case 'DD.MM.YYYY':
        return '25.12.2023';
      default:
        return '12/25/2023';
    }
  }

  String _formatTimeExample() {
    return _formatTimeWithFormat(_timeFormat);
  }

  String _formatTimeWithFormat(String format) {
    switch (format) {
      case '12-hour':
        return '2:30 PM';
      case '24-hour':
        return '14:30';
      default:
        return '2:30 PM';
    }
  }

  String _formatCurrencyExample() {
    switch (_selectedRegion) {
      case 'United States':
        return '\$1,234.56';
      case 'United Kingdom':
        return '£1,234.56';
      case 'Germany':
        return '1.234,56 €';
      case 'France':
        return '1 234,56 €';
      default:
        return '\$1,234.56';
    }
  }

  void _saveLanguageSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Language settings saved successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // In a real app, you would save these settings and possibly restart
    // the app or reload the current locale
  }
}