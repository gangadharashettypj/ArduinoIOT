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

class PersonalFormScreen extends StatefulWidget {
  const PersonalFormScreen({Key key}) : super(key: key);

  @override
  State<PersonalFormScreen> createState() => _PersonalFormScreenState();
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

class _PersonalFormScreenState extends State<PersonalFormScreen> {
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
