/*
 * @Author GS
 */
import 'dart:io';

import 'package:hive/hive.dart';

class DB {
  Box _box;

  static DB _instance;
  static DB get instance {
    _instance ??= DB();
    return _instance;
  }

  Future<void> register() async {
    var path = Directory.systemTemp.path;
    Hive.init(path);
    _box = await Hive.openBox('default');
  }

  dynamic get(DBKeys key) {
    return _box.containsKey(key.toString()) ? _box.get(key.toString()) : null;
  }

  Future<void> store(DBKeys key, dynamic value) async {
    await _box.put(key.toString(), value);
  }

  void remove(DBKeys key) {
    _box.delete(key.toString());
  }

  bool containsKey(DBKeys key) {
    return _box.containsKey(key.toString());
  }

  dynamic getData(String key) {
    return _box.get(key.toString());
  }

  Future<void> storeData(String key, dynamic value) async {
    await _box.put(key.toString(), value);
  }

  void removeData(String key) {
    _box.delete(key.toString());
  }

  bool containsKeyData(String key) {
    return (_box.containsKey(key.toString()));
  }

  Future<void> clear() async {
    await _box.clear();
  }
}

enum DBKeys {
  formData,
}
