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
          'ROBOT A',
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
            Container(),
            Container(),
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
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      HttpREST().get(
                        R.api.toggle,
                        params: {
                          'direction': 'LIGHT1',
                        },
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('L 1'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      HttpREST().get(
                        R.api.toggle,
                        params: {
                          'direction': 'LIGHT2',
                        },
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('L 2'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      HttpREST().get(
                        R.api.toggle,
                        params: {
                          'direction': 'LIGHT3',
                        },
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('L 3'),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.data, (Map<String, String> response) {
      return;
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
