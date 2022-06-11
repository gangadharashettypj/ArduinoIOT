import 'dart:convert';

import 'package:arduinoiot/db/db.dart';
import 'package:arduinoiot/model/questions_model.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/util/sized_box.dart';
import 'package:arduinoiot/widget/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '''
Please read the Statement and select the options 1,2,3,4,5 which indicates how much statement will applied to you.There are no right or wrong answers.
                    ''',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '''
The rating scale as follows:
   1 - Never 
   2 - Almost Never
   3 - Sometimes
   4 - Fairly Often
   5 - Very Often
''',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating: questionsModel.q1?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q1 = rating.toInt() - 1;
                              } else {
                                questionsModel.q1 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating: questionsModel.q2?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q2 = rating.toInt() - 1;
                              } else {
                                questionsModel.q2 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating: questionsModel.q3?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q3 = rating.toInt() - 1;
                              } else {
                                questionsModel.q3 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating: questionsModel.q4?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q4 = rating.toInt() - 1;
                              } else {
                                questionsModel.q4 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating: questionsModel.q5?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q5 = rating.toInt() - 1;
                              } else {
                                questionsModel.q5 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating: questionsModel.q6?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q6 = rating.toInt() - 1;
                              } else {
                                questionsModel.q6 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating: questionsModel.q7?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q7 = rating.toInt() - 1;
                              } else {
                                questionsModel.q7 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating: questionsModel.q8?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q8 = rating.toInt() - 1;
                              } else {
                                questionsModel.q8 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating: questionsModel.q9?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q9 = rating.toInt() - 1;
                              } else {
                                questionsModel.q9 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q10?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q10 = rating.toInt() - 1;
                              } else {
                                questionsModel.q10 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q11?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q11 = rating.toInt() - 1;
                              } else {
                                questionsModel.q11 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q12?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q12 = rating.toInt() - 1;
                              } else {
                                questionsModel.q12 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q13?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q13 = rating.toInt() - 1;
                              } else {
                                questionsModel.q13 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q14?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q14 = rating.toInt() - 1;
                              } else {
                                questionsModel.q14 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q15?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q15 = rating.toInt() - 1;
                              } else {
                                questionsModel.q15 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q16?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q16 = rating.toInt() - 1;
                              } else {
                                questionsModel.q16 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q17?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q17 = rating.toInt() - 1;
                              } else {
                                questionsModel.q17 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q18?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q18 = rating.toInt() - 1;
                              } else {
                                questionsModel.q18 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q19?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q19 = rating.toInt() - 1;
                              } else {
                                questionsModel.q19 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q20?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q20 = rating.toInt() - 1;
                              } else {
                                questionsModel.q20 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                            'I often am concerned or overthink about my academic performance?',
                            color: Colors.white,
                            fontSize: 20,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            maxLine: 10,
                          ),
                          CustomSizedBox.h18,
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q21?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q21 = rating.toInt() - 1;
                              } else {
                                questionsModel.q21 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                            'How often do you feel exhausted while doing everyday chores?',
                            color: Colors.white,
                            fontSize: 20,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            maxLine: 10,
                          ),
                          CustomSizedBox.h18,
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q22?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q22 = rating.toInt() - 1;
                              } else {
                                questionsModel.q22 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                            'How often do you experience loss of appetite?',
                            color: Colors.white,
                            fontSize: 20,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            maxLine: 10,
                          ),
                          CustomSizedBox.h18,
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q23?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q23 = rating.toInt() - 1;
                              } else {
                                questionsModel.q23 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                            'I have trouble initiating conversions or just simply being a part of it.?',
                            color: Colors.white,
                            fontSize: 20,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            maxLine: 10,
                          ),
                          CustomSizedBox.h18,
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q24?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q24 = rating.toInt() - 1;
                              } else {
                                questionsModel.q24 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox.h18,
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                            'I have experienced chronic/recurrent headaches/back pains/chest pain?',
                            color: Colors.white,
                            fontSize: 20,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            maxLine: 10,
                          ),
                          CustomSizedBox.h18,
                          RatingBar.builder(
                            initialRating:
                                questionsModel.q25?.toDouble() ?? 0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (rating.toInt() > 0) {
                                questionsModel.q25 = rating.toInt() - 1;
                              } else {
                                questionsModel.q25 = rating.toInt();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            width: double.infinity,
            child: RaisedButton(
              color: R.color.white,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                child: Text(
                  'SUBMIT FORM',
                  style: TextStyle(
                    color: R.color.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                handleFormSubmit();
              },
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
      Navigator.pushReplacementNamed(context, R.routes.data);
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
      backgroundColor: R.color.primary,
      appBar: AppBar(
        title: Text('Questions Form'),
      ),
      body: buildForm(),
    );
  }
}
