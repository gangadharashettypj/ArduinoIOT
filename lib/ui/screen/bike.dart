/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BikeScreen extends StatefulWidget {
  @override
  _BikeScreenState createState() => _BikeScreenState();
}

class _BikeScreenState extends State<BikeScreen> {
  int humidity;
  int moisture;
  int temperature;
  String raining;
  String lighting;

  bool light = false;
  bool fan = false;
  bool sprinkler = false;

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
          'Green House',
        ),
        actions: <Widget>[
          ElevatedButton(
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
          ElevatedButton(
            child: Text(
              "Refresh",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Response res = await HttpREST().get(
                R.api.getBikeStatus,
              );
              print(res?.body);
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
                    'Humidity: ${humidity ?? '--'}',
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
                    'Temperature: ${temperature ?? '--'}',
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
                    'Moisture: ${moisture == null ? '--' : (moisture > 1020 ? 'LOW' : (moisture > 500 ? 'MEDIUM' : 'LOW'))}',
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
                    'Weather: ${raining ?? '--'}',
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
                    'lighting: ${lighting ?? '--'}',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('LIGHT'),
                Text('FAN'),
                Text('SWITCH'),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoSwitch(
                  value: light,
                  onChanged: (value) {
                    setState(() {
                      light = value;
                    });
                    HttpREST().get(
                      value ? R.api.turnOnLight : R.api.turnOffLight,
                    );
                  },
                ),
                CupertinoSwitch(
                  value: fan,
                  onChanged: (value) {
                    setState(() {
                      fan = value;
                    });
                    HttpREST().get(
                      value ? R.api.turnOnFan : R.api.turnOffFan,
                    );
                  },
                ),
                CupertinoSwitch(
                  value: sprinkler,
                  onChanged: (value) {
                    setState(() {
                      sprinkler = value;
                    });
                    HttpREST().get(
                      value ? R.api.turnOnSprinkler : R.api.turnOffSprinkler,
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
    DeviceManager().listenForData(R.api.getHumidity,
        (Map<String, String> response) {
      setState(() {
        humidity = int.parse(response['humidity']);
      });
    });
    DeviceManager().listenForData(R.api.getTemperature,
        (Map<String, String> response) {
      setState(() {
        temperature = int.parse(response['temperature']);
      });
    });
    DeviceManager().listenForData(R.api.getMoisture,
        (Map<String, String> response) {
      setState(() {
        moisture = int.parse(response['moisture']);
      });
    });
    DeviceManager().listenForData(R.api.getRaining,
        (Map<String, String> response) {
      setState(() {
        raining = response['raining'];
      });
    });
    DeviceManager().listenForData(R.api.getLight,
        (Map<String, String> response) {
      setState(() {
        lighting = response['light'];
      });
    });
  }
}
