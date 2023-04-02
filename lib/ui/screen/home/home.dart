/*
 * @Author GS
 */
import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/service/manager/device_manager.dart';
import 'package:arduino_iot_v2/service/rest/http_rest.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String humi = '';
  String level = '';

  String windDirection = '';
  String speed = '';

  String temp = '';

  @override
  void initState() {
    startListening();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flood Detection',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Reconnect',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              HttpREST().get(
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
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    'Humidity: $humi',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    'Temperature: $temp',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    'Level: $level',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    'Wind Direction: $windDirection',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    'Speed: $speed',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.flood, (Map<String, String> response) {
      setState(() {
        humi = response['humi'] ?? '--';
        level = response['level'] ?? '--';
        windDirection = response['windDirection'] ?? '--';
        speed = response['speed'] ?? '--';
        temp = response['temp'] ?? '--';
      });
    });
  }
}
