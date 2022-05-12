/*
 * @Author GS
 */
import 'package:arduinoiot/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class MyColors {
  get primary => Colors.teal;
  get gray => Colors.grey;
  get lightGray => Colors.grey[400];
  get opposite => Colors.white;
  get accent => Colors.teal[200];
  get white => HexColor.fromHex('#FFFFFF');
  get red => Colors.red;
  get green => Colors.green;

  /*
  * general
  */
  static const Color backgroundColor = Color(0xffF1F3F7);
  static const Color textColor = Color(0xff778496);
  static const Color textLightColor = Color(0xff596574);
  static const Color textDarkColor = Color(0xFF505050);
}
