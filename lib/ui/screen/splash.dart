/*
 * @Author GS
 */

import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(context, R.routes.data);
        return;
      },
    );

    return Scaffold(
      backgroundColor: R.color.primary,
      body: Container(
        child: Center(
          child: Image.asset(
            R.image.logo1,
            height: 200,
          ),
        ),
      ),
    );
  }
}
