import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Servo extends StatelessWidget {
  double min, max;
  String suffix, prefix;
  Function(double) onChange;
  Servo({
    this.min = 0,
    this.max = 100,
    this.onChange,
    this.prefix = '',
    this.suffix = '',
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
              customColors: CustomSliderColors(
                  dotColor: Colors.white,
                  trackColor: Colors.grey,
                  progressBarColors: [Colors.lightGreenAccent, Colors.green])),
          min: min,
          max: max,
          innerWidget: (val) {
            return Center(
              child: Text(
                prefix + val.toInt().toString() + suffix,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          },
          onChange: (double value) {
            if (onChange != null) onChange(value);
          }),
    );
  }
}
