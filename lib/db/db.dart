/*
 * @Author GS
 */
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

final dbInstance = DB();

class DB {
  late Box _box;

  Future<void> register() async {
    if (!kIsWeb) {
      var path = Directory.systemTemp.path;
      Hive.init(path);
    }
    _box = await Hive.openBox('default');
  }

  Future<void> store(DBKeys key, dynamic value) async {
    await _box.put(key.name, value);
  }

  dynamic get(DBKeys key) {
    return _box.get(key.name);
  }

  void remove(DBKeys key) {
    _box.delete(key.name);
  }

  bool containsKey(DBKeys key) {
    return _box.containsKey(key.name);
  }

  dynamic getData(String key) {
    return _box.get(key);
  }

  String? getString(DBKeys key) {
    return _box.get(key.name, defaultValue: null);
  }

  int? getInt(DBKeys key) {
    return _box.get(key.name, defaultValue: null);
  }

  Future<void> storeData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  Future<void> storeString(DBKeys key, String value) async {
    await _box.put(key.name, value);
  }

  Future<void> storeInt(DBKeys key, int value) async {
    await _box.put(key.name, value);
  }

  void removeData(String key) {
    _box.delete(key);
  }

  bool containsKeyData(String key) {
    return (_box.containsKey(key));
  }

  Future<void> clear() async {
    await _box.clear();
  }
}

enum DBKeys {
  data,
}
