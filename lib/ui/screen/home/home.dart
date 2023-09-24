/*
 * @Author GS
 */
import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/service/manager/device_manager.dart';
import 'package:arduino_iot_v2/service/rest/http_rest.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();

  String lat = '';
  String lon = '';
  String date = '';
  String time = '';

  @override
  void initState() {
    startListening();
    // playVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GPS',
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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Latitude: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      lat,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Longitude: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      lon,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Date: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Time: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      time,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                HttpREST().get(R.api.toggle);
              },
              child: AbsorbPointer(
                absorbing: true,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('LED'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.data, (Map<String, String> response) {
      setState(() {
        setState(() {
          lat = response['lat'] ?? '';
          lon = response['lon'] ?? '';
          date = response['date'] ?? '';
          if (response['time'] != null) {
            var date = DateFormat('HH:mm:ss').parse(response['time']!);
            date = date.add(const Duration(minutes: 330));
            time = DateFormat('hh:mm:ss a').format(date);
          }
          // time = response['time'] ?? '';
        });
      });
    });
  }
}
