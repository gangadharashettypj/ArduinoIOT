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
  String message = '';

  @override
  void initState() {
    startListening();
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
    final items = message.split(',');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kid Monitoring',
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
        children: [
          const SizedBox(height: 12),
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
                  'Temperature: ${items.length > 1 ? items[1] : 'NA'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                  'Humidity: ${items.length > 2 ? items[2] : 'NA'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                  'BPM: ${items.length > 3 ? items[3] : 'NA'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                  'Toilet: ${items.length > 4 ? (int.parse(items[4]) > 250 ? 'YES' : 'NO') : 'NA'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                  'Crying: ${items.length > 5 ? (items[5] == '1' ? 'YES' : 'NO') : 'NA'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 12),
          // SizedBox(
          //   width: double.infinity,
          //   child: Card(
          //     shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(20),
          //       ),
          //     ),
          //     elevation: 8,
          //     child: Container(
          //       margin: const EdgeInsets.all(16),
          //       child: Text(
          //         message,
          //         style: const TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 20,
          //         ),
          //         maxLines: 3,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  int millis = -1;

  void startListening() async {
    DeviceManager().listenForData(R.api.flood, (Map<String, String> response) {
      if ((DateTime.now().millisecondsSinceEpoch - millis) > 2000) {
        millis = DateTime.now().millisecondsSinceEpoch;
        setState(() {
          message = response['data'] ?? '';
        });
      }
    });
  }
}
