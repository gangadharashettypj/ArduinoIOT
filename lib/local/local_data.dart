/*
 * @Author GS
 */

import 'package:arduinoiot/util/shared_preference.dart';

enum ConnectionType { HTTP, UDP }

class LocalData {
  void getData() async {
    title = await SharedPreferenceUtil.read('title');
    description = await SharedPreferenceUtil.read('description');
    students = await SharedPreferenceUtil.read('students');
  }

  static ConnectionType connectionType = ConnectionType.HTTP;
  static String username = 'user';
  static String password = 'pass';
  static String title = '';
  static String description = '';
  static String students = '';
}
