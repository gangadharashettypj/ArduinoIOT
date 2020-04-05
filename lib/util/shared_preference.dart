import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //method to read the colors from the shared preference
  static Future<String> read(String key) async {
    final SharedPreferences prefs = await _prefs;
    String str = prefs.getString(key);
    return str == null ? '' : str;
  }

  static Future<bool> readBool(String key) async {
    final SharedPreferences prefs = await _prefs;
    bool str = prefs.getBool(key);
    return str == null ? false : str;
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
