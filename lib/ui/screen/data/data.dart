/*
 * @Author GS
 */

import 'dart:convert';

import 'package:arduinoiot/db/db.dart';
import 'package:arduinoiot/model/questions_model.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  String bpm = '0';
  String gsr = '0';
  String gsrc = '0';
  String accelerometer = '0';
  String ecg = '0';
  double linearResult = -1;
  double dnnResult = -1;
  double actualDnnResult = -1;

  @override
  void initState() {
    startListening();
    super.initState();
  }

  Future<void> getAnalysis() async {
    /*
    2020,1,1,5,19.31,14.22,93.44,92.51,3.51,128.5,5.47,128.28
2020,1,1,6,19.33,13.98,92.06,92.64,3.6,124.03,5.26,123.93
2020,1,1,7,20.34,13.61,84.19,92.78,4.21,120.42,5.2,120.73
2020,1,1,8,21.73,12.88,73.19,92.89,4.46,118.09,5.3,118.72
2020,1,1,9,23.26,12.15,63.0,92.9,4.3,117.03,5.03,117.88
2020,1,1,10,24.87,11.66,54.94,92.87,3.86,115.01,4.51,115.86
2020,1,1,11,26.45,11.35,48.62,92.78,3.43,113.23,4.04,114.19
2020,1,1,12,27.68,11.11,44.38,92.65,3.07,113.24,3.66,114.32
2020,1,1,13,28.16,11.11,42.88,92.52,2.7,115.68,3.24,116.81
2020,1,1,14,27.91,11.11,43.62,92.45,2.19,120.96,2.67,120.99
2020,1,1,15,27.39,11.23,45.5,92.44,1.56,124.8,1.94,124.33
2020,1,1,16,26.56,12.08,51.38,92.48,0.8,116.82,1.11,116.21
2020,1,1,17,25.15,13.92,64.25,92.55,0.54,65.28,0.83,66.09
2020,1,1,18,23.84,15.01,74.94,92.64,0.88,43.57,1.49,45.0
2020,1,1,19,22.87,14.95,79.38,92.74,1.2,50.0,2.27,51.43
2020,1,1,20,22.16,14.59,80.62,92.82,1.45,54.68,2.97,55.6
2020,1,1,21,21.48,14.47,83.5,92.83,1.6,55.92,3.34,55.19
2020,1,1,22,20.93,14.47,86.38,92.8,1.7,56.46,3.44,55.37
2020,1,1,23,20.6,14.53,88.44,92.75,1.85,60.2,3.32,60.42
     */
    try {
      linearResult = await MethodChannel('com.trial.arduinoiot').invokeMethod(
          'linearPredict', [14.53, 88.44, 92.75, 1.85, 60.2, 3.32, 60.42]);
      dnnResult = await MethodChannel('com.trial.arduinoiot').invokeMethod(
          'dnnPredict', [14.53, 88.44, 92.75, 1.85, 60.2, 3.32, 60.42]);
      // if (linearResult > 1) linearResult = 1;
      // if (dnnResult > 1) dnnResult = 1;
      //
      // dnnResult = dnnResult * 100;
      // actualDnnResult = dnnResult;
      // linearResult = linearResult * 100;
      //
      // dnnResult = dnnResult * 0.6 + calculateStress() * 0.4;
      // linearResult = linearResult * 0.6 + calculateStress() * 0.4;
      // setState(() {});
      print(linearResult);
      print(dnnResult);
      return;

      if (ecg == '' || bpm == '' || gsrc == '') {
        return;
      }
      linearResult = await MethodChannel('com.trial.arduinoiot').invokeMethod(
          'linearPredict',
          [double.parse(ecg) / 10000, double.parse(bpm), double.parse(gsrc)]);
      dnnResult = await MethodChannel('com.trial.arduinoiot').invokeMethod(
          'dnnPredict',
          [double.parse(ecg) / 10000, double.parse(bpm), double.parse(gsrc)]);
      if (linearResult > 1) linearResult = 1;
      if (dnnResult > 1) dnnResult = 1;

      dnnResult = dnnResult * 100;
      actualDnnResult = dnnResult;
      linearResult = linearResult * 100;
      dnnResult = dnnResult * 0.6 + calculateStress() * 0.4;
      linearResult = linearResult * 0.6 + calculateStress() * 0.4;
      setState(() {});
    } catch (e) {
      print(e);
    }
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
    print(linearResult);
    print(dnnResult);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: R.color.primary,
        title: Text(
          'Live Device Data',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Reconnect',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Response res = await HttpREST().get(
                R.api.setClientIP,
                params: {
                  'ip': 'sd',
                  'port': '2345',
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'BPM: $bpm',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'GSRC: $gsrc',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'ECG: $ecg',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton(
              color: R.color.primary,
              child: Text(
                'Analyse Data',
                style: TextStyle(
                  color: R.color.opposite,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                await getAnalysis();
                return;
                await Navigator.pushNamed(context, R.routes.analysis,
                    arguments: {
                      'bpm': bpm,
                      'ecg': ecg,
                      'gsr': gsr,
                      'gsrc': gsrc,
                      'result': dnnResult,
                      'stressScore': calculateStress(),
                      'actualDnnResult': actualDnnResult,
                    });
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.data, (Map<String, String> response) {
      if (mounted) {
        setState(() {
          bpm = response['bpm'];
          gsr = response['gsr'];
          gsrc = response['gsrc'];
          ecg = response['ecg'];
          accelerometer = response['acc'];
          // print(jsonEncode(response));
        });
      }
    });
  }
}
