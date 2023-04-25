/*
 * @Author GS
 */
import 'package:arduino_iot_v2/db/db.dart';
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
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) {
            final items = messages.reversed.toList()[index].split(',');
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: R.color.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${messages.length - index}. ${items[0].replaceAll('Tilt', 'Crash')}'
                        .toUpperCase(),
                    style: TextStyle(
                      color: R.color.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Date: ${items[1]}   Time: ${items[2]}'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Lat: ${items[3]}    Lon: ${items[4]}'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Acc   X: ${items[5]}  Y: ${items[6]}  Z: ${items[7]}'
                        .toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 30);
          },
          itemCount: messages.length,
        ),
      ),
    );
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.flood, (Map<String, String> response) {
      setState(() {
        messages.add(response['data']!);
        dbInstance.store(DBKeys.data, messages);
      });
    });
  }
}
