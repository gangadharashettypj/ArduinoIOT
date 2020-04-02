/*
 * @Author GS
 */
import 'package:arduinoiot/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class MyColors {
  get primary => Colors.teal;
  get gray => Colors.grey;
  get lightGray => Colors.grey[400];
  get textColor => HexColor.fromHex('#FFFFFF');
  get opposite => Colors.white;
  get accent => Colors.teal[200];
  get white => HexColor.fromHex('#FFFFFF');
  MaterialColor primaryswatch = const MaterialColor(0x0e8f8d, const {
    50: const Color.fromARGB(255, 0, 150, 136),
    100: const Color.fromARGB(255, 0, 150, 136),
    200: const Color.fromARGB(255, 0, 150, 136),
    300: const Color.fromARGB(255, 0, 150, 136),
    400: const Color.fromARGB(255, 0, 150, 136),
    500: const Color.fromARGB(255, 0, 150, 136),
    600: const Color.fromARGB(255, 0, 150, 136),
    700: const Color.fromARGB(255, 0, 150, 136),
    800: const Color.fromARGB(255, 0, 150, 136),
    900: const Color.fromARGB(255, 0, 150, 136)
  });
}
