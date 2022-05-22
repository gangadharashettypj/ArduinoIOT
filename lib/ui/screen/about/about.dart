/*
 * @Author GS
 */

import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/util/sized_box.dart';
import 'package:arduinoiot/widget/label_widget.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.primary,
      appBar: AppBar(
        title: Text(
          'About',
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            CustomSizedBox.h18,
            CustomSizedBox.h18,
            Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.white,
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  children: [
                    LabelWidget(
                      'Track',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white54,
                    ),
                    CustomSizedBox.h18,
                    LabelWidget(
                      'Tracking your stress levels and panic attack symptoms can be an important aspect of managing and understanding your stress.',
                      color: Colors.white,
                      fontSize: 20,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                      maxLine: 10,
                    ),
                    CustomSizedBox.h18,
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
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  children: [
                    LabelWidget(
                      'Analyze',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white54,
                    ),
                    CustomSizedBox.h18,
                    LabelWidget(
                      'View stress level and stress score that give you deeper insight into triggers and trends.',
                      color: Colors.white,
                      fontSize: 20,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                      maxLine: 10,
                    ),
                    CustomSizedBox.h18,
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
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  children: [
                    LabelWidget(
                      'Manage',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white54,
                    ),
                    CustomSizedBox.h18,
                    LabelWidget(
                      'Get the recommendation to manage your stress level.',
                      color: Colors.white,
                      fontSize: 20,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                      maxLine: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
