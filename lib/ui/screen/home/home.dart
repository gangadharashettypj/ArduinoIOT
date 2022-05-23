/*
 * @Author GS
 */
import 'dart:convert';

import 'package:arduinoiot/db/db.dart';
import 'package:arduinoiot/model/questions_model.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/util/sized_box.dart';
import 'package:arduinoiot/widget/label_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String phValue;
  String humidity;
  String waterTemperature;
  String airTemperature;

  @override
  void initState() {
    startListening();
    super.initState();
  }

  int calculateStress() {
    final data = DB.instance.get(DBKeys.formData);
    if (data == null || data == '') {
      return -1;
    }
    final model = QuestionsModel.fromJson(jsonDecode(data));
    if (model.q1 == null) {
      return -1;
    }
    var x1 =
        (model.q5 + model.q8 + model.q17 + model.q22 + model.q23 + model.q25) /
            24;
    var x2 = (model.q1 +
            model.q2 +
            model.q7 +
            model.q15 +
            model.q18 +
            model.q10 +
            model.q9 +
            model.q21) /
        32;
    var x3 = (model.q12 + model.q11 + model.q24 + model.q19) / 16;
    var x4 = (model.q3 +
            model.q4 +
            model.q6 +
            model.q13 +
            model.q14 +
            model.q16 +
            model.q20) /
        28;
    return ((x1 + x2 + x3 + x4) / 4 * 100).toInt();
  }

  String getStressScore() {
    return calculateStress() != -1 ? calculateStress().toString() : '--';
  }

  String getStressLevel() {
    if (calculateStress() > 50) {
      return 'Highly Stressed';
    } else if (calculateStress() > 35) {
      return 'Stressed';
    } else if (calculateStress() > 0) {
      return 'Mild Stressed';
    } else {
      return '--';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stress Calculator',
        ),
        actions: <Widget>[
          // FlatButton(
          //   child: Text(
          //     'Reconnect',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onPressed: () async {
          //     Response res = await HttpREST().get(
          //       R.api.setClientIP,
          //       params: {
          //         'ip': 'sd',
          //         'port': '2345',
          //       },
          //     );
          //   },
          // ),
          FlatButton(
            child: Text(
              'Fill Form',
              style: TextStyle(
                color: R.color.opposite,
              ),
            ),
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                R.routes.form,
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Column(
                    children: [
                      Center(
                        child: LabelWidget(
                          'STRESS SCORE:',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white54,
                        ),
                      ),
                      CustomSizedBox.h40,
                      Center(
                        child: LabelWidget(
                          '${getStressScore()}',
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          maxLine: 2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomSizedBox.h30,
              Card(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Column(
                    children: [
                      Center(
                        child: LabelWidget(
                          'STRESS LEVEL:',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white54,
                        ),
                      ),
                      CustomSizedBox.h40,
                      Center(
                        child: LabelWidget(
                          '${getStressLevel()}',
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          maxLine: 2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
          // child: ListView(
          //   shrinkWrap: true,
          //   children: <Widget>[
          //     Container(
          //       width: double.infinity,
          //       child: Card(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(20),
          //           ),
          //         ),
          //         elevation: 8,
          //         child: Container(
          //           margin: EdgeInsets.all(16),
          //           child: Text(
          //             'pH: $phValue',
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 20,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       height: 30,
          //     ),
          //     Container(
          //       width: double.infinity,
          //       child: Card(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(20),
          //           ),
          //         ),
          //         elevation: 8,
          //         child: Container(
          //           margin: EdgeInsets.all(16),
          //           child: Text(
          //             'Humidity: $humidity',
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 20,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       height: 30,
          //     ),
          //     Container(
          //       width: double.infinity,
          //       child: Card(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(20),
          //           ),
          //         ),
          //         elevation: 8,
          //         child: Container(
          //           margin: EdgeInsets.all(16),
          //           child: Text(
          //             'Air Temperature: $airTemperature',
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 20,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       height: 30,
          //     ),
          //     Container(
          //       width: double.infinity,
          //       child: Card(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(20),
          //           ),
          //         ),
          //         elevation: 8,
          //         child: Container(
          //           margin: EdgeInsets.all(16),
          //           child: Text(
          //             'Water Temperature: $waterTemperature',
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 20,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       height: 30,
          //     ),
          //     RaisedButton(
          //       color: R.color.primary,
          //       child: Text(
          //         'Water Pump',
          //         style: TextStyle(
          //           color: R.color.opposite,
          //         ),
          //       ),
          //       onPressed: () async {
          //         await DeviceManager().sendData(R.api.waterPump);
          //       },
          //     ),
          //     SizedBox(
          //       height: 30,
          //     ),
          //     RaisedButton(
          //       color: R.color.red,
          //       child: Text(
          //         'Nutrition Pump',
          //         style: TextStyle(
          //           color: R.color.opposite,
          //         ),
          //       ),
          //       onPressed: () async {
          //         await DeviceManager().sendData(R.api.nutritionPump);
          //       },
          //     ),
          //     SizedBox(
          //       height: 30,
          //     ),
          //     RaisedButton(
          //       color: R.color.green,
          //       child: Text(
          //         'Light',
          //         style: TextStyle(
          //           color: R.color.opposite,
          //         ),
          //       ),
          //       onPressed: () async {
          //         await DeviceManager().sendData(R.api.light);
          //       },
          //     ),
          //     SizedBox(
          //       height: 30,
          //     ),
          //     RaisedButton(
          //       color: R.color.green,
          //       child: Text(
          //         'Fill Form',
          //         style: TextStyle(
          //           color: R.color.opposite,
          //         ),
          //       ),
          //       onPressed: () {
          //         Navigator.pushNamed(
          //           context,
          //           R.routes.form,
          //         );
          //       },
          //     ),
          //   ],
          // ),
          ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.data, (Map<String, String> response) {
      setState(() {
        phValue = response['pH'];
        humidity = response['humidity'];
        airTemperature = response['airTemperature'];
        waterTemperature = response['waterTemperature'];
      });
    });
    // DeviceManager().listenForData(R.api.humidity,
    //     (Map<String, String> response) {
    //   setState(() {
    //     humidity = int.parse(response['humidity']);
    //   });
    // });
    // DeviceManager().listenForData(R.api.airTemperature,
    //     (Map<String, String> response) {
    //   setState(() {
    //     airTemperature = int.parse(response['airTemperature']);
    //   });
    // });
    // DeviceManager().listenForData(R.api.waterTemperature,
    //     (Map<String, String> response) {
    //   setState(() {
    //     waterTemperature = int.parse(response['waterTemperature']);
    //   });
    // });
  }
}
