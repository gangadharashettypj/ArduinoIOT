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

class FormScreen extends StatefulWidget {
  const FormScreen({Key key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

/*
How often do you get distressed due to overworking (presentations, reports, assignments)
How often do you get distressed due to Hybrid classes (offline and online)?
How often do you get influenced by posts in social media?
Felt unassured about your ability to handle your personal problems? (family problems, financial issues)
I experienced palpitations and/or breathing difficulty(e.g. excessively rapid breathing,breathlessness in the abscence of physical exerction)
 I found it difficult to cope up with rejections/failures
Does just thinking of a situation panic you?
I experienced breathlessness/trembling in hands before a presentation or exams
I felt hopeless and/or that I wasn't worth much as a person.
I felt that life was meaningless and/or that my future was gloomy
How often do you zone out while watching a movie or making a conversation?
I find it difficult to adapt to the changes like isolation after covid outburst
I'm underconfident that I could deal with me or any of my loved ones having any health issues.
I often compare myself with others and feel lower than them
How often do you get nightmares and cant get them out of your head?
I constantly have a fear of suddenly losing a loved one.
I have Insomnia (sleeplessness)
I often overthink when someone ignores or avoids me
Do you feel like withdrawing from family, friends, and isolating yourself when you are sad or low?
how often do you fear judgements from others?
How often do you feel exhausted while doing everyday chores?
How often do you experience loss of appetite?
I have trouble initiating conversions or just simply being a part of it.
I have experienced chronic/recurrent headaches/back pains/chest pain
 */

final formKey = GlobalKey<FormState>();

class _FormScreenState extends State<FormScreen> {
  var questionsModel = QuestionsModel();

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
                  CustomSizedBox.h18,
                  LabelWidget(
                    'How often do you get distressed due to overworking (presentations, reports, assignments)',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q1,
                    onChanged: (value) => setState(() {
                      questionsModel.q1 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'How often do you get distressed due to Hybrid classes (offline and online)?',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q2,
                    onChanged: (value) => setState(() {
                      questionsModel.q2 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'How often do you get influenced by posts in social media?',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q3,
                    onChanged: (value) => setState(() {
                      questionsModel.q3 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'Felt unassured about your ability to handle your personal problems? (family problems, financial issues)',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q4,
                    onChanged: (value) => setState(() {
                      questionsModel.q4 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I experienced palpitations and/or breathing difficulty(e.g. excessively rapid breathing,breathlessness in the abscence of physical exerction)',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q5,
                    onChanged: (value) => setState(() {
                      questionsModel.q5 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I found it difficult to cope up with rejections/failures',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q6,
                    onChanged: (value) => setState(() {
                      questionsModel.q6 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'Does just thinking of a situation panic you?',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q7,
                    onChanged: (value) => setState(() {
                      questionsModel.q7 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I experienced breathlessness/trembling in hands before a presentation or exams',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q8,
                    onChanged: (value) => setState(() {
                      questionsModel.q8 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I felt hopeless and/or that I wasn\'t worth much as a person.',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q9,
                    onChanged: (value) => setState(() {
                      questionsModel.q9 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I felt that life was meaningless and/or that my future was gloomy',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q10,
                    onChanged: (value) => setState(() {
                      questionsModel.q10 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'How often do you zone out while watching a movie or making a conversation?',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q11,
                    onChanged: (value) => setState(() {
                      questionsModel.q11 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I find it difficult to adapt to the changes like isolation after covid outburst',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q12,
                    onChanged: (value) => setState(() {
                      questionsModel.q12 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I\'m underconfident that I could deal with me or any of my loved ones having any health issues.',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q13,
                    onChanged: (value) => setState(() {
                      questionsModel.q13 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I often compare myself with others and feel lower than them',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q14,
                    onChanged: (value) => setState(() {
                      questionsModel.q14 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'How often do you get nightmares and cant get them out of your head?',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q15,
                    onChanged: (value) => setState(() {
                      questionsModel.q15 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I constantly have a fear of suddenly losing a loved one.',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q16,
                    onChanged: (value) => setState(() {
                      questionsModel.q16 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I have Insomnia (sleeplessness)',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q17,
                    onChanged: (value) => setState(() {
                      questionsModel.q17 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I often overthink when someone ignores or avoids me',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q18,
                    onChanged: (value) => setState(() {
                      questionsModel.q18 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'Do you feel like withdrawing from family, friends, and isolating yourself when you are sad or low?',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q19,
                    onChanged: (value) => setState(() {
                      questionsModel.q19 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'how often do you fear judgements from others?',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q20,
                    onChanged: (value) => setState(() {
                      questionsModel.q20 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'How often do you feel exhausted while doing everyday chores?',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q21,
                    onChanged: (value) => setState(() {
                      questionsModel.q21 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'How often do you experience loss of appetite?',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q22,
                    onChanged: (value) => setState(() {
                      questionsModel.q22 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I have trouble initiating conversions or just simply being a part of it.',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q23,
                    onChanged: (value) => setState(() {
                      questionsModel.q23 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I have experienced chronic/recurrent headaches/back pains/chest pain',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q24,
                    onChanged: (value) => setState(() {
                      questionsModel.q24 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
                  ),
                  CustomSizedBox.h18,
                  LabelWidget(
                    'I have experienced chronic/recurrent headaches/back pains/chest pain 4',
                    color: MyColors.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                  ),
                  RadioGroup<int>.builder(
                    groupValue: questionsModel.q25,
                    onChanged: (value) => setState(() {
                      questionsModel.q25 = value;
                    }),
                    items: [0, 1, 2, 3, 4],
                    direction: Axis.horizontal,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.toString(),
                    ),
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
      if (questionsModel.q1 == null ||
          questionsModel.q2 == null ||
          questionsModel.q3 == null ||
          questionsModel.q4 == null ||
          questionsModel.q5 == null ||
          questionsModel.q6 == null ||
          questionsModel.q7 == null ||
          questionsModel.q8 == null ||
          questionsModel.q9 == null ||
          questionsModel.q10 == null ||
          questionsModel.q11 == null ||
          questionsModel.q12 == null ||
          questionsModel.q13 == null ||
          questionsModel.q14 == null ||
          questionsModel.q15 == null ||
          questionsModel.q16 == null ||
          questionsModel.q16 == null ||
          questionsModel.q18 == null ||
          questionsModel.q19 == null ||
          questionsModel.q20 == null ||
          questionsModel.q21 == null ||
          questionsModel.q22 == null ||
          questionsModel.q23 == null ||
          questionsModel.q24 == null) {
        Fluttertoast.showToast(msg: 'Please enter a valid details');
      } else {
        DB.instance.store(DBKeys.formData, jsonEncode(questionsModel.toJson()));
        Fluttertoast.showToast(msg: 'Form submitted successfully');
        Navigator.pop(context);
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
        title: Text('Form'),
      ),
      body: buildForm(),
    );
  }
}
