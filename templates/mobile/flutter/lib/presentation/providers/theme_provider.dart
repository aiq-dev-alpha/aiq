import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/storage/local_storage.dart';
import '../../core/di/service_locator.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  late LocalStorage _localStorage;

  ThemeProvider() {
    _localStorage = sl<LocalStorage>();
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  bool get isLightMode => !isDarkMode;

  Future<void> _loadTheme() async {
    try {
      final savedTheme = await _localStorage.getString(AppConstants.themeKey);
      if (savedTheme != null) {
        _themeMode = _parseThemeMode(savedTheme);
        notifyListeners();
      }
    } catch (e) {
      // Handle error silently, use default theme
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;

    _themeMode = themeMode;
    notifyListeners();

    try {
      await _localStorage.saveString(
        AppConstants.themeKey,
        _themeMode.toString(),
      );
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await setThemeMode(newTheme);
  }

  ThemeMode _parseThemeMode(String themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }
}