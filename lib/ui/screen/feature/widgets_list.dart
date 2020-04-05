/*
 * @Author GS
 */
import 'package:arduinoiot/ui/screen/feature/car/car_controller.dart';
import 'package:arduinoiot/ui/screen/feature/chat/chat.dart';
import 'package:arduinoiot/ui/screen/feature/joystick/joystick.dart';
import 'package:arduinoiot/ui/screen/feature/login/login.dart';
import 'package:arduinoiot/ui/screen/feature/servo/servo.dart';
import 'package:flutter/material.dart';

Map<String, Widget> widgetsList = {
  'Car': CarController(),
  'Chat': Chat(),
  'Login': Login(),
  'Servo': Servo(),
  'Joy Stick': JoyStick(),
};
