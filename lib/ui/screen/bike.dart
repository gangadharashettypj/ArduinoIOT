/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BikeScreen extends StatefulWidget {
  @override
  _BikeScreenState createState() => _BikeScreenState();
}

class _BikeScreenState extends State<BikeScreen> {
  int bikeStatus = 0;
  String lat = 'NA';
  String lng = 'NA';

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
          'Accident Monitor',
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
                    'Vehicle Status: ${bikeStatus == 1 ? 'RUNNING' : (bikeStatus == 2 ? 'ACCIDENT' : (bikeStatus == 3 ? 'PROBLEM' : '--'))}',
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
    DeviceManager().listenForData(R.api.bikeLocation,
        (Map<String, String> response) {
      setState(() {
        lat = double.parse(response['lat']).toStringAsFixed(6);
        lng = double.parse(response['lng']).toStringAsFixed(6);
      });
    });
  }
}
