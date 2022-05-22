import 'dart:convert';

import 'package:arduinoiot/db/db.dart';
import 'package:arduinoiot/model/questions_model.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/util/sized_box.dart';
import 'package:arduinoiot/widget/label_widget.dart';
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

class _FormScreenState extends State<FormScreen> {
  var questionsModel = QuestionsModel();

  Widget buildForm() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Card(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 1',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'How often do you get distressed due to overworking (presentations, reports, assignments)?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 2',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'How often do you get distressed due to Hybrid classes (offline and online)?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 3',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'How often do you get influenced by posts in social media?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 4',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'Felt unassured about your ability to handle your personal problems? (family problems, financial issues)?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 5',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I experienced palpitations and/or breathing difficulty(e.g. excessively rapid breathing,breathlessness in the abscence of physical exerction)?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 6',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I found it difficult to cope up with rejections/failures?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 7',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'Does just thinking of a situation panic you?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 8',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I experienced breathlessness/trembling in hands before a presentation or exams?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 9',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I felt hopeless and/or that I wasn\'t worth much as a person.?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 10',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I felt that life was meaningless and/or that my future was gloomy?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 11',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'How often do you zone out while watching a movie or making a conversation?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 12',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I find it difficult to adapt to the changes like isolation after covid outburst?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 13',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I\'m underconfident that I could deal with me or any of my loved ones having any health issues.?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 14',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I often compare myself with others and feel lower than them?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 15',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'How often do you get nightmares and cant get them out of your head?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 16',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I constantly have a fear of suddenly losing a loved one.?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 17',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I have Insomnia (sleeplessness)?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 18',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I often overthink when someone ignores or avoids me?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 19',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'Do you feel like withdrawing from family, friends, and isolating yourself when you are sad or low?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 20',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'how often do you fear judgements from others?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 21',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'How often do you feel exhausted while doing everyday chores?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 22',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'How often do you experience loss of appetite?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 23',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I have trouble initiating conversions or just simply being a part of it.?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 24',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I have experienced chronic/recurrent headaches/back pains/chest pain?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
                      ],
                    ),
                  ),
                ),
                CustomSizedBox.h18,
                Card(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        LabelWidget(
                          'Question 25',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                        CustomSizedBox.h18,
                        LabelWidget(
                          'I have experienced chronic/recurrent headaches/back pains/chest pain 4?',
                          color: Colors.white,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          maxLine: 10,
                        ),
                        CustomSizedBox.h18,
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
    );
  }

  void handleFormSubmit() {
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
      Navigator.pushReplacementNamed(context, R.routes.home);
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
        title: Text('Questions Form'),
      ),
      body: buildForm(),
    );
  }
}
