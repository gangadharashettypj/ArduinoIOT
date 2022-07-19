/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String accident;
  String isPanic;
  String isEmergency;

  var semesterss = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];
  var subjects = {
    '1st Semester': [
      'Basic Electronics',
      'Digital Electronics',
    ],
    '2nd Semester': [
      'Network Theory Analysis',
    ],
    '3rd Semester': [
      'Electronics Devices and Circuits',
    ],
    '4th Semester': [
      'Signals & Systems',
    ],
    '5th Semester': [
      'Digital Signal Processing',
    ],
    '6th Semester': [
      'Control System',
    ],
    '7th Semester': [
      'PSA',
    ],
    '8th Semester': [
      'PSP',
    ],
  };
  var pins = {
    '1st Semester': [
      13,
      12,
    ],
    '2nd Semester': [
      14,
    ],
    '3rd Semester': [
      27,
    ],
    '4th Semester': [
      26,
    ],
    '5th Semester': [
      25,
    ],
    '6th Semester': [
      33,
    ],
    '7th Semester': [
      32,
    ],
    '8th Semester': [
      2,
    ],
  };

  @override
  void initState() {
    startListening();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Vending Machine',
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
        child: ListView.builder(
          itemBuilder: (_, index) {
            return ExpansionTile(
              title: Text(
                '${semesterss[index]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              children: [
                ...List.generate(subjects[semesterss[index]].length, (index1) {
                  return ListTile(
                    title: Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '${index1 + 1}. ${subjects[semesterss[index]][index1]}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () async {
                      await DeviceManager()
                          .sendData(R.api.bookSelected, params: {
                        'book': subjects[semesterss[index]][index1],
                        'pin': pins[semesterss[index]][index1].toString(),
                        'semester': semesterss[index],
                      });
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  );
                }),
              ],
            );
          },
          itemCount: semesterss.length,
        ),
      ),
    );
  }

  void startListening() async {
    // DeviceManager().listenForData(R.api.data, (Map<String, String> response) {
    //   if (mounted) {
    //     setState(() {
    //       accident = response['accident'];
    //       isPanic = response['isPanic'];
    //       isEmergency = response['isEmergency'];
    //     });
    //   }
    // });
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
