/*
 * @Author GS
 */
import 'package:arduino_iot_v2/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class MyColors {
  get primary => Colors.teal;
  get gray => Colors.grey;
  get lightGray => Colors.grey[400];
  get textColor => HexColor.fromHex('#FFFFFF');
  get opposite => Colors.white;
  get accent => Colors.teal[200];
  get white => HexColor.fromHex('#FFFFFF');
  get red => Colors.red;
  get green => Colors.green;
}
