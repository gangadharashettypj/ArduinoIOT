// import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
// import 'package:arduino_iot_v2/service/manager/device_manager.dart';
// import 'package:arduino_iot_v2/service/rest/http_rest.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   VlcPlayerController? _videoPlayerController;
//
//   String url = '192.168.68.106';
//
//   final controller = TextEditingController(text: '192.168.68.106');
//   final controller1 = TextEditingController(text: '10.10.10.1');
//
//   String lat = '';
//   String lon = '';
//   String distance = '';
//   String metal = '';
//   String temp = '';
//
//   @override
//   void initState() {
//     startListening();
//     // playVideo();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     super.dispose();
//   }
//
//   void playVideo() {
//     _videoPlayerController = VlcPlayerController.network(
//       'http://$url:5000/video_feed',
//       autoPlay: true,
//       options: VlcPlayerOptions(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'ROBOT I',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.blue,
//         actions: <Widget>[
//           TextButton(
//             child: const Text(
//               'Reconnect',
//               style: TextStyle(color: Colors.white),
//             ),
//             onPressed: () {
//               HttpREST().get(
//                 R.api.setClientIP,
//                 params: {
//                   'ip': 'sd',
//                   'port': '2345',
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 child: TextField(
//                   onChanged: (val) {
//                     R.api.baseUrl = 'http://$val/';
//                   },
//                   controller: controller1,
//                   decoration: const InputDecoration(
//                       hintText: 'ESP Address',
//                       alignLabelWithHint: true,
//                       labelText: 'ESP Address'),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 child: TextField(
//                   controller: controller,
//                   decoration: const InputDecoration(
//                       hintText: 'IP Address',
//                       alignLabelWithHint: true,
//                       labelText: 'Raspberry pi address'),
//                 ),
//               ),
//               Container(
//                 margin:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           url = controller.text;
//                           playVideo();
//                         });
//                       },
//                       child: const Text(
//                         'PLAY',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _videoPlayerController?.dispose();
//                           _videoPlayerController = null;
//                         });
//                       },
//                       child: const Text('STOP'),
//                     ),
//                   ],
//                 ),
//               ),
//               if (_videoPlayerController == null)
//                 SizedBox(
//                   height: 200,
//                   child: Container(
//                     color: Colors.grey,
//                     child: const Center(
//                       child: Text(
//                         'LIVE VIDEO',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               if (_videoPlayerController != null)
//                 SizedBox(
//                   height: 200,
//                   child: VlcPlayer(
//                     aspectRatio: 4 / 3,
//                     placeholder: Container(),
//                     controller: _videoPlayerController!,
//                   ),
//                 ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Latitude: ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: Text(
//                       lat,
//                       style: const TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Longitude: ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: Text(
//                       lon,
//                       style: const TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Distance: ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: Text(
//                       distance,
//                       style: const TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Gas Detected: ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: Text(
//                       metal.replaceAll('Metal', 'Gas'),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: metal == 'Metal Detected'
//                             ? Colors.red
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Temperature: ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: Text(
//                       temp,
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//               InkWell(
//                 onTapDown: (_) {
//                   HttpREST().get(
//                     R.api.toggle,
//                     params: {
//                       'direction': 'FRONT',
//                     },
//                   );
//                 },
//                 onTapUp: (_) {
//                   HttpREST().get(
//                     R.api.toggle,
//                     params: {
//                       'direction': 'STOP',
//                     },
//                   );
//                 },
//                 child: AbsorbPointer(
//                   absorbing: true,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     child: const Text('FRONT'),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTapDown: (_) {
//                             HttpREST().get(
//                               R.api.toggle,
//                               params: {
//                                 'direction': 'LEFT',
//                               },
//                             );
//                           },
//                           onTapUp: (_) {
//                             HttpREST().get(
//                               R.api.toggle,
//                               params: {
//                                 'direction': 'STOP',
//                               },
//                             );
//                           },
//                           child: AbsorbPointer(
//                             absorbing: true,
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               child: const Text('LEFT'),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTapDown: (_) {
//                             HttpREST().get(
//                               R.api.toggle,
//                               params: {
//                                 'direction': 'RIGHT',
//                               },
//                             );
//                           },
//                           onTapUp: (_) {
//                             HttpREST().get(
//                               R.api.toggle,
//                               params: {
//                                 'direction': 'STOP',
//                               },
//                             );
//                           },
//                           child: AbsorbPointer(
//                             absorbing: true,
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               child: const Text('RIGHT'),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               InkWell(
//                 onTapDown: (_) {
//                   HttpREST().get(
//                     R.api.toggle,
//                     params: {
//                       'direction': 'BACK',
//                     },
//                   );
//                 },
//                 onTapUp: (_) {
//                   HttpREST().get(
//                     R.api.toggle,
//                     params: {
//                       'direction': 'STOP',
//                     },
//                   );
//                 },
//                 child: AbsorbPointer(
//                   absorbing: true,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     child: const Text('BACK'),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void startListening() async {
//     DeviceManager().listenForData(R.api.data, (Map<String, String> response) {
//       setState(() {
//         setState(() {
//           lat = response['lat'] ?? '';
//           lon = response['lon'] ?? '';
//           distance = response['distance'] ?? '';
//           metal = response['metal'] ?? '';
//           temp = response['temp'] ?? '';
//           // if (response['time'] != null) {
//           //   var date = DateFormat('HH:mm:ss').parse(response['time']!);
//           //   date = date.add(const Duration(minutes: 330));
//           //   metal = DateFormat('hh:mm:ss a').format(date);
//           // }
//         });
//       });
//     });
//   }
// }
