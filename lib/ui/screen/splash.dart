/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/server/server.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ser = Server.inst;
    Future.delayed(
      Duration(seconds: 2),
      () => Navigator.pushReplacementNamed(context, '/home'),
    );
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Arduino IOT",
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
}
