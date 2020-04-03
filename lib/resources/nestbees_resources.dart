/*
 * @Author GS
 */

import 'package:arduinoiot/resources/api.dart';
import 'package:arduinoiot/resources/colors.dart';
import 'package:arduinoiot/resources/images.dart';
import 'package:arduinoiot/resources/routes.dart';
import 'package:arduinoiot/resources/shared_pref_constant.dart';
import 'package:arduinoiot/resources/strings.dart';

abstract class R {
  static MyColors color = MyColors();
  static Images image = Images();
  static Api api = Api();
  static SharedPrefConstants pref = SharedPrefConstants();
  static MyString string = MyString();
  static Routes routes = Routes();
}
