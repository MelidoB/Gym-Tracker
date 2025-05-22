import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setPreferences(String key, dynamic value) async {
    final prefs = await _prefs;
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  Future<dynamic?> getPreferences(String key) async {
    final prefs = await _prefs;
    return prefs.get(key);
  }
}
