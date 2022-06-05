import 'dart:convert';

import 'package:arduinoiot/db/db.dart';
import 'package:arduinoiot/model/questions_model.dart';
import 'package:arduinoiot/resources/colors.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/util/sized_box.dart';
import 'package:arduinoiot/widget/label_widget.dart';
import 'package:arduinoiot/widget/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';

class RangeFormScreen extends StatefulWidget {
  const RangeFormScreen({Key key}) : super(key: key);

  @override
  State<RangeFormScreen> createState() => _RangeFormScreenState();
}

class _RangeFormScreenState extends State<RangeFormScreen> {
  var questionsModel = QuestionsModel();
  final formKey = GlobalKey<FormState>();
  Widget buildForm() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextFieldWidget(
                    placeHolder: 'Name',
                    initialValue: questionsModel.name,
                    onChanged: (val) {
                      questionsModel.name = val;
                    },
                    validator: (val) {
                      return val.isEmpty ? 'Enter a valid name' : null;
                    },
                  ),
                  CustomSizedBox.h12,
                  TextFieldWidget(
                    placeHolder: 'Phone',
                    initialValue: questionsModel.phone?.toString(),
                    textInputType: TextInputType.phone,
                    maxLength: 10,
                    onChanged: (val) {
                      questionsModel.phone = int.tryParse(val);
                    },
                    validator: (val) {
                      return val.isEmpty || val.length != 10
                          ? 'Enter a valid phone'
                          : null;
                    },
                  ),
                  CustomSizedBox.h12,
                  TextFieldWidget(
                    placeHolder: 'Age',
                    maxLength: 2,
                    textInputType: TextInputType.number,
                    initialValue: questionsModel.age?.toString(),
                    onChanged: (val) {
                      questionsModel.age = int.tryParse(val);
                    },
                    validator: (val) {
                      return val.isEmpty || val.length > 99
                          ? 'Enter a valid age'
                          : null;
                    },
                  ),
                  CustomSizedBox.h12,
                  LabelWidget(
                    'Gender',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<String>.builder(
                    groupValue: questionsModel.gender,
                    onChanged: (value) => setState(() {
                      questionsModel.gender = value;
                    }),
                    items: ['MALE', 'FEMALE'],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item,
                    ),
                  ),
                  CustomSizedBox.h12,
                  TextFieldWidget(
                    placeHolder: 'Course',
                    initialValue: questionsModel.course,
                    onChanged: (val) {
                      questionsModel.course = val;
                    },
                    validator: (val) {
                      return val.isEmpty ? 'Enter a valid course' : null;
                    },
                  ),
                  CustomSizedBox.h12,
                  TextFieldWidget(
                    placeHolder: 'Semester',
                    textInputType: TextInputType.number,
                    maxLength: 1,
                    initialValue: questionsModel.semester?.toString(),
                    onChanged: (val) {
                      questionsModel.semester = int.tryParse(val);
                    },
                    validator: (val) {
                      return val.isEmpty ? 'Enter a valid semester' : null;
                    },
                  ),
                  CustomSizedBox.h12,
                  TextFieldWidget(
                    placeHolder: 'College',
                    initialValue: questionsModel.college,
                    onChanged: (val) {
                      questionsModel.college = val;
                    },
                    validator: (val) {
                      return val.isEmpty ? 'Enter a valid college' : null;
                    },
                  ),
                  CustomSizedBox.h12,
                  TextFieldWidget(
                    placeHolder: 'Having disabilities',
                    initialValue: questionsModel.disabilities,
                    onChanged: (val) {
                      questionsModel.disabilities = val;
                    },
                  ),
                  CustomSizedBox.h12,
                  TextFieldWidget(
                    placeHolder:
                        'Having any previous medical records(If yes, give the details. Else , mention NA)',
                    initialValue: questionsModel.previousMedicalRecords,
                    onChanged: (val) {
                      questionsModel.previousMedicalRecords = val;
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      color: R.color.primary,
                      child: Text(
                        'SUBMIT FORM',
                        style: TextStyle(
                          color: R.color.opposite,
                        ),
                      ),
                      onPressed: () {
                        handleFormSubmit();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleFormSubmit() {
    if (formKey.currentState.validate()) {
      DB.instance.store(DBKeys.formData, jsonEncode(questionsModel.toJson()));
      Fluttertoast.showToast(msg: 'Form submitted successfully');
      final data = DB.instance.get(DBKeys.formData);
      final qModel = QuestionsModel.fromJson(jsonDecode(data));
      if (qModel.q1 != null) {
        Navigator.pushReplacementNamed(context, R.routes.instruction);
      } else {
        Navigator.pushReplacementNamed(context, R.routes.form);
      }
    } else {
      Fluttertoast.showToast(msg: 'Please enter a valid details');
    }
  }

  @override
  void initState() {
    final data = DB.instance.get(DBKeys.formData);
    if (data != null && data != '') {
      questionsModel = QuestionsModel.fromJson(jsonDecode(data));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Form'),
      ),
      body: buildForm(),
    );
  }
}
