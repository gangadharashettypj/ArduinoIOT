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
  String data = '';
  String data1 = '';
  String data2 = '';
  String data3 = '';

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
          'BESCOM',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              if (data3 == '1')
                const Text(
                  'HOSPITAL',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              if (data3 == '1') const SizedBox(height: 24),
              if (data2 == '1')
                Text(
                  'INDUSTRY',
                  style: TextStyle(
                    color: Colors.deepOrange.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              if (data2 == '1') const SizedBox(height: 24),
              if (data1 == '1')
                const Text(
                  'AREA',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              if (data1 == '1') const SizedBox(height: 24),
            ],
          ),
          Text(
            data.split(',').first,
            style: TextStyle(
              color: data.split(',').first.startsWith('OVER LOAD')
                  ? Colors.red
                  : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                HttpREST().get(
                  R.api.controller,
                  params: {'command': 'AUTO'},
                );
              },
              child: Text(
                (data.split(',')[1] == '1') ? 'CLOSED CIRCUIT' : 'OPEN CIRCUIT',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.flood, (Map<String, String> response) {
      setState(() {
        data = response['data']!;
        data1 = response['data1']!;
        data2 = response['data2']!;
        data3 = response['data3']!;
      });
    });
  }
}
