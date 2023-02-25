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
  String v1 = '';
  String c1 = '';

  String v2 = '';
  String c2 = '';

  String v3 = '';
  String c3 = '';

  String humi = '';
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
          'Hydroponics',
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
                    'V1: $v1',
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
                    'C1: $c1',
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
                    'V2: $v2',
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
                    'C2: $c2',
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
                    'V3: $v3',
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
                    'C3: $c3',
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
          ],
        ),
      ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.getData,
        (Map<String, String> response) {
      print(response);
      setState(() {
        v1 = response['v1'] ?? '--';
        c1 = response['c1'] ?? '--';
        v2 = response['v2'] ?? '--';
        c2 = response['c2'] ?? '--';
        v3 = response['v3'] ?? '--';
        c3 = response['c3'] ?? '--';
        humi = response['humi'] ?? '--';
        temp = response['temp'] ?? '--';
      });
    });
  }
}
