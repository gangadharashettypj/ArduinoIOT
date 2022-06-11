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
    // [0.003863636, 92.11363636, 21.39022727],
    try {
      // linearResult = await MethodChannel('com.trial.arduinoiot').invokeMethod(
      //     'linearPredict', [0.003863636, 92.11363636, 21.39022727]);
      // dnnResult = await MethodChannel('com.trial.arduinoiot')
      //     .invokeMethod('dnnPredict', [0.003863636, 92.11363636, 21.39022727]);
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
      // return;

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
