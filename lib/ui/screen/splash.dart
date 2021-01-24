/*
 * @Author GS
 */
import 'package:arduinoiot/local/local_data.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:arduinoiot/service/server/server.dart';
import 'package:arduinoiot/util/shared_preference.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ser = Server.inst;
    LocalData().getData();

    Future.delayed(
      Duration(seconds: 2),
      () => Navigator.pushReplacementNamed(context, R.routes.bike),
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
    DeviceManager().listenForData(R.api.setStudentsData,
        (Map<String, String> response) async {
      await SharedPreferenceUtil.write('title', response['title']);
      await SharedPreferenceUtil.write('description', response['description']);
      await SharedPreferenceUtil.write('student', response['students']);
    });
  }
}
