/*
 * @Author GS
 */
import 'package:arduino_iot_v2/db/db.dart';
import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/service/rest/http_rest.dart';
import 'package:arduino_iot_v2/service/udp/udp.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> messages = [];

  @override
  void initState() {
    startListening();
    if (dbInstance.containsKey(DBKeys.data)) {
      messages = dbInstance.get(DBKeys.data);
    }
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Black Box',
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  LocalUDP.send('PLATOON');
                },
                child: const Text('PLATOON MODE'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  LocalUDP.send('AUTO');
                },
                child: const Text('AUTO MODE'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  LocalUDP.send('MANUAL');
                },
                child: const Text('MANUAL MODE'),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTapDown: (_) {
                  LocalUDP.send('FRONT');
                },
                onTapUp: (_) {
                  LocalUDP.send('STOP');
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTapDown: (_) {
                      LocalUDP.send('LEFT');
                    },
                    onTapUp: (_) {
                      LocalUDP.send('STOP');
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('LEFT'),
                      ),
                    ),
                  ),
                  InkWell(
                    onTapDown: (_) {
                      LocalUDP.send('RIGHT');
                    },
                    onTapUp: (_) {
                      LocalUDP.send('STOP');
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
              InkWell(
                onTapDown: (_) {
                  LocalUDP.send('BACK');
                },
                onTapUp: (_) {
                  LocalUDP.send('STOP');
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
        ],
      ),
    );
  }

  void startListening() async {
    // DeviceManager().listenForData(R.api.flood, (Map<String, String> response) {
    //   setState(() {
    //     messages.add(response['data']!);
    //     dbInstance.store(DBKeys.data, messages);
    //   });
    // });
  }
}
