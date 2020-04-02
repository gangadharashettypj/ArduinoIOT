import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //method to read the colors from the shared preference
  static Future<String> read(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }

  static Future<bool> readBool(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key);
  }

  static Future<void> write(String key, String val) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, val);
  }

  static Future<void> writeBool(String key, bool val) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(key, val);
  }

  static Future<void> remove(String key) async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(key);
  }
}
