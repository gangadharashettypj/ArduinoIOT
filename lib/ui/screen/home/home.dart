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
  String phValue;
  String humidity;
  String waterTemperature;
  String airTemperature;

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
          'Hydroponics',
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
                  margin: EdgeInsets.all(16),
                  child: Text(
                    'pH: $phValue',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
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
                  margin: EdgeInsets.all(16),
                  child: Text(
                    'Humidity: $humidity',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
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
                  margin: EdgeInsets.all(16),
                  child: Text(
                    'Air Temperature: $airTemperature',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
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
                  margin: EdgeInsets.all(16),
                  child: Text(
                    'Water Temperature: $waterTemperature',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              color: R.color.primary,
              child: Text(
                'Water Pump',
                style: TextStyle(
                  color: R.color.opposite,
                ),
              ),
              onPressed: () async {
                await DeviceManager().sendData(R.api.waterPump);
              },
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              color: R.color.red,
              child: Text(
                'Nutrition Pump',
                style: TextStyle(
                  color: R.color.opposite,
                ),
              ),
              onPressed: () async {
                await DeviceManager().sendData(R.api.nutritionPump);
              },
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              color: R.color.green,
              child: Text(
                'Light',
                style: TextStyle(
                  color: R.color.opposite,
                ),
              ),
              onPressed: () async {
                await DeviceManager().sendData(R.api.light);
              },
            ),
          ],
        ),
      ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.pH, (Map<String, String> response) {
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
