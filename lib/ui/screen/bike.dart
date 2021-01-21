/*
 * @Author GS
 */
import 'package:arduinoiot/local/local_data.dart';
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PhSensor extends StatefulWidget {
  @override
  _PhSensorState createState() => _PhSensorState();
}

class _PhSensorState extends State<PhSensor> {
  int bikeStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocalData.title != '' ? LocalData.title : 'Title',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Reconnect",
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
          FlatButton(
            child: Text(
              "Refresh",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Response res = await HttpREST().get(
                R.api.getBikeStatus,
              );
              print(res.body);
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
              height: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Bike status is ',
                      style: TextStyle(
                        color: R.color.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      '${bikeStatus == 1 ? 'RUNNING' : bikeStatus == 2 ? "STOPPED" : "UNKNOWN"}',
                      style: TextStyle(
                        color: R.color.gray,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: R.color.primary,
                  child: Text(
                    "Start Bike",
                    style: TextStyle(
                      color: R.color.opposite,
                    ),
                  ),
                  onPressed: () {
                    DeviceManager().sendData(
                      R.api.turnOnBike,
                    );
                  },
                ),
                RaisedButton(
                  color: R.color.red,
                  child: Text(
                    "Stop Bike",
                    style: TextStyle(
                      color: R.color.opposite,
                    ),
                  ),
                  onPressed: () {
                    DeviceManager().sendData(
                      R.api.turnOffBike,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.bikeStatus,
        (Map<String, String> response) {
      setState(() {
        bikeStatus = int.parse(response['bikeStatus']);
      });
    });
  }
}
