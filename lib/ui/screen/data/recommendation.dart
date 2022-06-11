/*
 * @Author GS
 */

import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.blue,
      appBar: AppBar(
        title: Text('Recommendation'),
        backgroundColor: R.color.blue,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Image.asset(
            ModalRoute.of(context).settings.arguments as String,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
