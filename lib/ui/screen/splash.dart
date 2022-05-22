/*
 * @Author GS
 */
import 'dart:convert';

import 'package:arduinoiot/db/db.dart';
import 'package:arduinoiot/local/local_data.dart';
import 'package:arduinoiot/model/questions_model.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:arduinoiot/service/server/server.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ser = Server.inst;
    LocalData().getData();

    Future.delayed(
      Duration(seconds: 2),
      () {
        final data = DB.instance.get(DBKeys.formData);
        if (data != null && data != '') {
          final questionsModel = QuestionsModel.fromJson(jsonDecode(data));
          if (questionsModel.q1 != null) {
            Navigator.pushReplacementNamed(context, R.routes.instruction);
          } else {
            Navigator.pushReplacementNamed(context, R.routes.form);
          }
        } else {
          Navigator.pushReplacementNamed(context, R.routes.personalForm);
        }
      },
    );
    return Scaffold(
      backgroundColor: R.color.primary,
      body: Container(
        child: Center(
          child: Image.asset(
            R.image.logo,
          ),
        ),
      ),
    );
  }

  void listen() async {
    Server().registerService(R.api.root, (Map<String, String> response) {
      HttpREST().get(
        R.api.setClientIP,
        params: {
          'ip': '',
          'port': '2345',
        },
      );
    });
  }
}
