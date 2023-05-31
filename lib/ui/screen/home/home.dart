/*
 * @Author GS
 */
import 'package:arduino_iot_v2/db/db.dart';
import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:arduino_iot_v2/service/rest/http_rest.dart';
import 'package:arduino_iot_v2/service/udp/udp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> messages = [];

  VlcPlayerController? _videoPlayerController;

  String url = '192.168.29.122';

  final controller = TextEditingController();

  @override
  void initState() {
    startListening();
    if (dbInstance.containsKey(DBKeys.data)) {
      messages = dbInstance.get(DBKeys.data);
    }
    controller.text = url;
    // playVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void playVideo() {
    _videoPlayerController = VlcPlayerController.network(
      'http://$url:5001/video_feed',
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'IP Address',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      url = controller.text;
                      playVideo();
                    });
                  },
                  child: const Text('PLAY'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _videoPlayerController?.dispose();
                      _videoPlayerController = null;
                    });
                  },
                  child: const Text('STOP'),
                ),
              ],
            ),
          ),
          if (_videoPlayerController == null)
            SizedBox(
              height: 200,
              child: Container(
                color: Colors.grey,
                child: const Center(
                  child: Text(
                    'LIVE VIDEO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          if (_videoPlayerController != null)
            SizedBox(
              height: 200,
              child: VlcPlayer(
                aspectRatio: 4 / 3,
                placeholder: Container(),
                controller: _videoPlayerController!,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  LocalUDP.send('PLATOON');
                },
                child: const Text('PLATOON'),
              ),
              ElevatedButton(
                onPressed: () {
                  LocalUDP.send('AUTO');
                },
                child: const Text('AUTO'),
              ),
              ElevatedButton(
                onPressed: () {
                  LocalUDP.send('MANUAL');
                },
                child: const Text('MANUAL'),
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
