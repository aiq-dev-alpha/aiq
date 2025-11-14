import 'package:flutter/material.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  String _selectedTheme = 'System';
  String _selectedAccentColor = 'Blue';
  bool _dynamicColors = false;
  bool _highContrast = false;
  double _textScale = 1.0;
  String _fontFamily = 'System';

  final List<String> _themeOptions = ['Light', 'Dark', 'System'];
  final List<Color> _accentColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];
  final List<String> _accentColorNames = [
    'Blue',
    'Red',
    'Green',
    'Orange',
    'Purple',
    'Teal',
    'Pink',
    'Indigo',
  ];

  final List<String> _fontOptions = [
    'System',
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Poppins',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        actions: [
          TextButton(
            onPressed: _saveThemeSettings,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Mode Section
          _buildSectionHeader('Theme Mode'),
          Card(
            child: Column(
              children: [
                _buildThemePreview(),
                const Divider(),
                ..._themeOptions.map((theme) {
                  return RadioListTile<String>(
                    title: Text(theme),
                    subtitle: Text(_getThemeDescription(theme)),
                    value: theme,
                    groupValue: _selectedTheme,
                    onChanged: (value) {
                      setState(() {
                        _selectedTheme = value!;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Accent Color Section
          _buildSectionHeader('Accent Color'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose your preferred accent color',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: List.generate(_accentColors.length, (index) {
                      final color = _accentColors[index];
                      final colorName = _accentColorNames[index];
                      final isSelected = _selectedAccentColor == colorName;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAccentColor = colorName;
                          });
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : null,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Switch(
                        value: _dynamicColors,
                        onChanged: (value) {
                          setState(() {
                            _dynamicColors = value;
                          });
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dynamic Colors',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Use system accent colors (Android 12+)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Accessibility Section
          _buildSectionHeader('Accessibility'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('High Contrast'),
                  subtitle: const Text('Increase contrast for better visibility'),
                  value: _highContrast,
                  onChanged: (value) {
                    setState(() {
                      _highContrast = value;
                    });
                  },
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Text Size',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adjust text size for better readability',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('A', style: TextStyle(fontSize: 12)),
                          Expanded(
                            child: Slider(
                              value: _textScale,
                              min: 0.8,
                              max: 1.5,
                              divisions: 7,
                              label: '${(_textScale * 100).round()}%',
                              onChanged: (value) {
                                setState(() {
                                  _textScale = value;
                                });
                              },
                            ),
                          ),
                          const Text('A', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Center(
                        child: Text(
                          'Sample text at ${(_textScale * 100).round()}% size',
                          style: TextStyle(
                            fontSize: 16 * _textScale,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Typography Section
          _buildSectionHeader('Typography'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Font Family'),
                  subtitle: Text(_fontFamily),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showFontFamilyDialog,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Preview Section
          _buildSectionHeader('Preview'),
          _buildFullPreview(isDark),

          const SizedBox(height: 24),

          // Reset Button
          Center(
            child: OutlinedButton.icon(
              onPressed: _resetToDefaults,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset to Defaults'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
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

  Widget _buildThemePreview() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Light Theme Preview
          _buildMiniThemePreview(
            'Light',
            Colors.white,
            Colors.black,
            _selectedTheme == 'Light',
          ),
          const SizedBox(width: 16),
          // Dark Theme Preview
          _buildMiniThemePreview(
            'Dark',
            Colors.grey[900]!,
            Colors.white,
            _selectedTheme == 'Dark',
          ),
          const SizedBox(width: 16),
          // System Theme Preview
          _buildMiniThemePreview(
            'Auto',
            Colors.grey[600]!,
            Colors.white,
            _selectedTheme == 'System',
          ),
        ],
      ),
    );
  }

  Widget _buildMiniThemePreview(
    String label,
    Color backgroundColor,
    Color textColor,
    bool isSelected,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.smartphone,
                color: textColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullPreview(bool isDark) {
    final previewTheme = ThemeData(
      brightness: _selectedTheme == 'Light'
          ? Brightness.light
          : _selectedTheme == 'Dark'
              ? Brightness.dark
              : isDark
                  ? Brightness.dark
                  : Brightness.light,
      primarySwatch: _getSelectedMaterialColor(),
      fontFamily: _fontFamily == 'System' ? null : _fontFamily,
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 16 * _textScale),
        bodyMedium: TextStyle(fontSize: 14 * _textScale),
        titleLarge: TextStyle(fontSize: 20 * _textScale),
      ),
    );

    return Card(
      child: Theme(
        data: previewTheme,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Theme Preview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: previewTheme.primaryColor,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: const Text('Sample User'),
                subtitle: const Text('This is how your theme will look'),
                trailing: Icon(
                  Icons.favorite,
                  color: previewTheme.primaryColor,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Primary Button'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Outlined Button'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeDescription(String theme) {
    switch (theme) {
      case 'Light':
        return 'Always use light theme';
      case 'Dark':
        return 'Always use dark theme';
      case 'System':
        return 'Follow system settings';
      default:
        return '';
    }
  }

  MaterialColor _getSelectedMaterialColor() {
    final index = _accentColorNames.indexOf(_selectedAccentColor);
    final color = _accentColors[index];

    // Convert Color to MaterialColor
    final Map<int, Color> swatch = {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color,
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    };

    return MaterialColor(color.value, swatch);
  }

  void _showFontFamilyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Font Family'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _fontOptions.map((font) {
            return RadioListTile<String>(
              title: Text(
                font,
                style: TextStyle(
                  fontFamily: font == 'System' ? null : font,
                ),
              ),
              value: font,
              groupValue: _fontFamily,
              onChanged: (value) {
                setState(() {
                  _fontFamily = value!;
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

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Theme Settings'),
        content: const Text('This will reset all theme settings to their default values.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedTheme = 'System';
                _selectedAccentColor = 'Blue';
                _dynamicColors = false;
                _highContrast = false;
                _textScale = 1.0;
                _fontFamily = 'System';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _saveThemeSettings() {
    // In a real app, save to SharedPreferences or state management
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Theme settings saved successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Apply theme changes
    // This would typically trigger a state update in your app's theme provider
  }
}