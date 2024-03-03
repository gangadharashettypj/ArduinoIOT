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
  final controller = TextEditingController();

  String lat = '';
  String lon = '';
  String distance = '';
  String metal = '';
  String temp = '';

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
          'ROBOT I',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Latitude: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    lat,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Longitude: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    lon,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Distance: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    distance,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Gas Detected: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    metal.replaceAll('Metal', 'Gas'),
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          metal == 'Metal Detected' ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Temperature: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    temp,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            InkWell(
              onTapDown: (_) {
                HttpREST().get(
                  R.api.toggle,
                  params: {
                    'direction': 'FRONT',
                  },
                );
              },
              onTapUp: (_) {
                HttpREST().get(
                  R.api.toggle,
                  params: {
                    'direction': 'STOP',
                  },
                );
              },
              child: AbsorbPointer(
                absorbing: true,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('FRONT'),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTapDown: (_) {
                          HttpREST().get(
                            R.api.toggle,
                            params: {
                              'direction': 'LEFT',
                            },
                          );
                        },
                        onTapUp: (_) {
                          HttpREST().get(
                            R.api.toggle,
                            params: {
                              'direction': 'STOP',
                            },
                          );
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('LEFT'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTapDown: (_) {
                          HttpREST().get(
                            R.api.toggle,
                            params: {
                              'direction': 'RIGHT',
                            },
                          );
                        },
                        onTapUp: (_) {
                          HttpREST().get(
                            R.api.toggle,
                            params: {
                              'direction': 'STOP',
                            },
                          );
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('RIGHT'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            InkWell(
              onTapDown: (_) {
                HttpREST().get(
                  R.api.toggle,
                  params: {
                    'direction': 'BACK',
                  },
                );
              },
              onTapUp: (_) {
                HttpREST().get(
                  R.api.toggle,
                  params: {
                    'direction': 'STOP',
                  },
                );
              },
              child: AbsorbPointer(
                absorbing: true,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('BACK'),
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
          distance = response['distance'] ?? '';
          metal = response['metal'] ?? '';
          temp = response['temp'] ?? '';
          // if (response['time'] != null) {
          //   var date = DateFormat('HH:mm:ss').parse(response['time']!);
          //   date = date.add(const Duration(minutes: 330));
          //   metal = DateFormat('hh:mm:ss a').format(date);
          // }
        });
      });
    });
  }
}
