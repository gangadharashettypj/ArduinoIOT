/*
 * @Author GS
 */
import 'dart:async';

import 'package:arduino_iot_v2/service/udp/udp.dart';
import 'package:firebase_database/firebase_database.dart';
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
  StreamSubscription? subscription1;
  StreamSubscription? subscription2;

  List<String> logs = [];

  bool showVoiceLogin = false;
  bool isLogin = false;
  bool isRegister = false;

  @override
  void initState() {
    startListening();
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription1?.cancel();
    subscription2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Platoon',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
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
                ),
                const SizedBox(width: 20),
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
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Please enter a valid id and proceed');
                      return;
                    }
                    setState(() {
                      isRegister = true;
                      isLogin = false;
                      showVoiceLogin = false;
                    });
                    LocalUDP.send('ENROLL');
                  },
                  child: const Text('REGISTER'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isRegister = false;
                      isLogin = true;
                      showVoiceLogin = false;
                    });
                    LocalUDP.send('SEARCH');
                  },
                  child: const Text('LOGIN'),
                ),
                if (showVoiceLogin)
                  ElevatedButton(
                    onPressed: () {
                      FirebaseDatabase.instance.ref().child('app').set({
                        'command': 'recognize',
                      });
                    },
                    child: const Text('VOICE LOGIN'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      logs.clear();
                    });
                  },
                  child: const Text('Clear Logs'),
                ),
                ElevatedButton(
                  onPressed: () {
                    LocalUDP.send('EMPTY');
                  },
                  child: const Text('Clear Fingerprint Database'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('LOGS'),
            const SizedBox(height: 10),
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
        if (msg.startsWith('ERROR:') && isLogin) {
          showVoiceLogin = true;
        } else {
          showVoiceLogin = false;
        }

        if (msg.startsWith('RESULT: User Registered successfully ')) {
          FirebaseDatabase.instance.ref().child('app').set({
            'filename': controller.text.toString(),
            'command': 'enroll',
          });
        }
        logs.insert(0, msg);
      });
    });

    subscription1 = FirebaseDatabase.instance
        .ref()
        .child('app')
        .child('result')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        FirebaseDatabase.instance.ref().child('app').child('result').remove();
        if (mounted) {
          setState(() {
            controller.text = '';
            isLogin = false;
            isRegister = false;
            showVoiceLogin = false;
            logs.insert(0, 'RESULT: ${event.snapshot.value}');
          });
        }
      }
    });

    subscription2 = FirebaseDatabase.instance
        .ref()
        .child('app')
        .child('resultall')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        FirebaseDatabase.instance
            .ref()
            .child('app')
            .child('resultall')
            .remove();
        if (mounted) {
          setState(() {
            controller.text = '';
            isLogin = false;
            isRegister = false;
            showVoiceLogin = false;
            logs.insert(0, 'RESULT: ${event.snapshot.value}');
          });
        }
      }
    });
  }
}
