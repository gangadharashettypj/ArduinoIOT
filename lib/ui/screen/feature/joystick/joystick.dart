/*
 * @Author GS
 */
import 'package:control_pad/control_pad.dart';
import 'package:flutter/material.dart';

class JoyStick extends StatelessWidget {
  Function(double, double) onChanged;
  JoyStick({this.onChanged});
  @override
  Widget build(BuildContext context) {
    return JoystickView(
      innerCircleColor: Colors.grey,
      onDirectionChanged: (x, y) {
        if (onChanged != null) onChanged(x, y);
      },
    );
  }
}
