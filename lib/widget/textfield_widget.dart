/*
 * @Author GS
 */

import 'package:arduinoiot/resources/colors.dart';
import 'package:arduinoiot/util/sized_box.dart';
import 'package:arduinoiot/widget/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final FormFieldValidator<String> validator;
  final String placeHolder;
  final String hintText;
  final String suffixText;
  final TextInputType textInputType;
  final int numberOfLine;
  final String initialValue;
  final bool obscureText;
  final VoidCallback onTap;
  final Widget prefix;
  final void Function(String) onChanged;
  final void Function(String) onSaved;
  final bool filled;
  final bool alignLabelWithHint;
  final IconData suffixIcon;
  final int maxLength;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Color borderColor;
  final List<TextInputFormatter> formatters;
  final TextEditingController controller = TextEditingController();

  TextFieldWidget({
    Key key,
    this.hintText,
    this.numberOfLine = 1,
    this.textInputType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.initialValue = '',
    this.obscureText = false,
    this.onTap,
    this.prefix,
    this.suffixText = '',
    this.placeHolder,
    this.filled = false,
    this.maxLength,
    this.fontSize,
    this.fontWeight,
    this.suffixIcon,
    this.textAlign,
    this.formatters,
    this.alignLabelWithHint = false,
    this.onSaved,
    this.borderColor = MyColors.textDarkColor,
  }) : super(key: key) {
    controller.text = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (placeHolder != null)
          LabelWidget(
            placeHolder,
            color: MyColors.textDarkColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            maxLine: 2,
          ),
        CustomSizedBox.h4,
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: onTap,
          decoration: InputDecoration(
            suffixText: suffixText,
            filled: filled,
            prefixIcon: prefix,
            suffixIcon: suffixIcon != null
                ? Icon(
                    suffixIcon,
                  )
                : null,
            hintText: hintText,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            hintStyle: TextStyle(
              fontSize: fontSize,
              color: MyColors.textColor,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            counterText: '',
          ),
          inputFormatters: formatters,
          maxLines: numberOfLine,
          maxLength: maxLength,
          textAlignVertical: TextAlignVertical.bottom,
          obscureText: obscureText,
          controller: controller
            ..selection = TextSelection(
              baseOffset: controller.text.length,
              extentOffset: controller.text.length,
            ),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: MyColors.textColor,
          ),
          textAlign: textAlign ?? TextAlign.start,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          keyboardType: textInputType,
        ),
      ],
    );
  }
}
