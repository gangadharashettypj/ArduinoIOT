/*
 * @Author GS
 */
import 'package:arduinoiot/local/local_data.dart';
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
      () => Navigator.pushReplacementNamed(context, R.routes.home),
    );
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Stress Calculator',
            style: TextStyle(
              color: R.color.primary,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
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
