/*
 * @Author GS
 */

import 'package:arduino_iot_v2/resources/api.dart';
import 'package:arduino_iot_v2/resources/colors.dart';
import 'package:arduino_iot_v2/resources/images.dart';
import 'package:arduino_iot_v2/resources/routes.dart';
import 'package:arduino_iot_v2/resources/strings.dart';

abstract class R {
  static MyColors color = MyColors();
  static Images image = Images();
  static Api api = Api();
  static MyString string = MyString();
  static Routes routes = Routes();
}
