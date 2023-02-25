/*
 * @Author GS
 */
import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/service/rest/http_rest.dart';
import 'package:arduino_iot_v2/service/server/server.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Server.inst;
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushReplacementNamed(context, R.routes.home),
    );
    return Scaffold(
      body: Center(
        child: Text(
          "Arduino IOT",
          style: TextStyle(
            color: R.color.primary,
            fontWeight: FontWeight.bold,
            fontSize: 40,
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
