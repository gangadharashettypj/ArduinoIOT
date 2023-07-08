/*
 * @Author GS
 */
import 'dart:async';

import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/service/rest/http_rest.dart';
import 'package:arduino_iot_v2/service/udp/udp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();

  StreamSubscription? subscription;

  List<String> logs = [];

  @override
  void initState() {
    startListening();
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Platoon',
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
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'User Id',
                  labelText: 'User Id',
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (controller.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: 'Please enter a valid id and proceed');
                  return;
                }
                LocalUDP.send('setId${controller.text}');
              },
              child: const Text('SetId'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                LocalUDP.send('ENROLL');
              },
              child: const Text('ENROLL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                LocalUDP.send('SEARCH');
              },
              child: const Text('SEARCH'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                LocalUDP.send('EMPTY');
              },
              child: const Text('CLEAR DATABASE'),
            ),
            const SizedBox(height: 20),
            const Text('LOGS'),
            Container(
              height: 300,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    logs[index],
                    style: TextStyle(
                      color: logs[index].startsWith('ERROR')
                          ? Colors.red
                          : Colors.black,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 5);
                },
                itemCount: logs.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startListening() async {
    subscription = await LocalUDP.receive((msg) {
      // Fluttertoast.showToast(msg: msg);
      setState(() {
        logs.insert(0, msg);
      });
    });
  }
}
