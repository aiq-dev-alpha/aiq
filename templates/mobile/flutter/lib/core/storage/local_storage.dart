import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../constants/app_constants.dart';

abstract class LocalStorage {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> saveDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> saveObject(String key, Map<String, dynamic> object);
  Future<Map<String, dynamic>?> getObject(String key);
  Future<void> saveList(String key, List<String> list);
  Future<List<String>?> getList(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

class SharedPreferencesStorage implements LocalStorage {
  SharedPreferences? _preferences;

  Future<SharedPreferences> get preferences async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  @override
  Future<void> saveString(String key, String value) async {
    final prefs = await preferences;
    await prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await preferences;
    return prefs.getString(key);
  }

  @override
  Future<void> saveInt(String key, int value) async {
    final prefs = await preferences;
    await prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final prefs = await preferences;
    return prefs.getInt(key);
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    final prefs = await preferences;
    await prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final prefs = await preferences;
    return prefs.getBool(key);
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    final prefs = await preferences;
    await prefs.setDouble(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    final prefs = await preferences;
    return prefs.getDouble(key);
  }

  @override
  Future<void> saveObject(String key, Map<String, dynamic> object) async {
    final prefs = await preferences;
    await prefs.setString(key, jsonEncode(object));
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    final prefs = await preferences;
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Future<void> saveList(String key, List<String> list) async {
    final prefs = await preferences;
    await prefs.setStringList(key, list);
  }

  @override
  Future<List<String>?> getList(String key) async {
    final prefs = await preferences;
    return prefs.getStringList(key);
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await preferences;
    await prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    final prefs = await preferences;
    await prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final prefs = await preferences;
    return prefs.containsKey(key);
  }
}

class HiveStorage implements LocalStorage {
  Box? _box;

  Future<Box> get box async {
    _box ??= await Hive.openBox(AppConstants.settingsBox);
    return _box!;
  }

  @override
  Future<void> saveString(String key, String value) async {
    final hiveBox = await box;
    await hiveBox.put(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final hiveBox = await box;
    return hiveBox.get(key) as String?;
  }

  @override
  Future<void> saveInt(String key, int value) async {
    final hiveBox = await box;
    await hiveBox.put(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final hiveBox = await box;
    return hiveBox.get(key) as int?;
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    final hiveBox = await box;
    await hiveBox.put(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final hiveBox = await box;
    return hiveBox.get(key) as bool?;
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    final hiveBox = await box;
    await hiveBox.put(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    final hiveBox = await box;
    return hiveBox.get(key) as double?;
  }

  @override
  Future<void> saveObject(String key, Map<String, dynamic> object) async {
    final hiveBox = await box;
    await hiveBox.put(key, object);
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    final hiveBox = await box;
    final result = hiveBox.get(key);
    if (result is Map) {
      return Map<String, dynamic>.from(result);
    }
    return null;
  }

  @override
  Future<void> saveList(String key, List<String> list) async {
    final hiveBox = await box;
    await hiveBox.put(key, list);
  }

  @override
  Future<List<String>?> getList(String key) async {
    final hiveBox = await box;
    final result = hiveBox.get(key);
    if (result is List) {
      return List<String>.from(result);
    }
    return null;
  }

  @override
  Future<void> remove(String key) async {
    final hiveBox = await box;
    await hiveBox.delete(key);
  }

  @override
  Future<void> clear() async {
    final hiveBox = await box;
    await hiveBox.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final hiveBox = await box;
    return hiveBox.containsKey(key);
  }
}