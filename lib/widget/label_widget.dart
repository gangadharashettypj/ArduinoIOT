/*
 * @Author GS
 */
import 'package:arduinoiot/resources/colors.dart';
import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final int maxLine;
  final TextOverflow overflow;
  final bool vertical;
  final double runSpacing;
  final double fontSize;
  final double height;
  final EdgeInsets padding;
  final TextAlign textAlign;

  const LabelWidget(
    this.text, {
    Key key,
    this.color = MyColors.textColor,
    this.fontSize,
    this.height,
    this.padding,
    this.fontWeight = FontWeight.normal,
    this.textAlign,
    this.maxLine = 1,
    this.overflow = TextOverflow.ellipsis,
    this.vertical = false,
    this.runSpacing = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Container(
        padding: padding,
        child: Wrap(
          runSpacing: runSpacing,
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: text
              .split("")
              .map(
                (string) => Text(
                  string,
                  textAlign: textAlign,
                  maxLines: maxLine,
                  overflow: overflow,
                ),
              )
              .toList(),
        ),
      );
    }
    return Container(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
        ),
        textAlign: textAlign,
        maxLines: maxLine,
        overflow: overflow,
      ),
    );
  }
}
