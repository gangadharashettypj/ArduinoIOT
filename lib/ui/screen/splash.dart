/*
 * @Author GS
 */
import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/service/rest/http_rest.dart';
import 'package:arduino_iot_v2/service/server/server.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pushReplacementNamed(context, R.routes.home),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Server.inst;

    return Scaffold(
      body: Center(
        child: Text(
          "Green Spaces",
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
