/*
 * @Author GS
 */

import 'dart:convert';
import 'dart:io';

import 'package:udp/udp.dart';

class LocalUDP {
  static Future<int> send(String msg) async {
    var multicastEndpoint =
        Endpoint.multicast(InternetAddress("224.10.10.10"), port: Port(4200));
    var sender = await UDP.bind(Endpoint.any());
    return await sender
        .send(msg.codeUnits, multicastEndpoint)
        .whenComplete(() => sender.close())
        .catchError((e) => print(e));
  }

  static Future<void> receive(
      String path, Function(Map<String, String>) callback) async {
    var multicastEndpoint =
        Endpoint.multicast(InternetAddress("225.10.10.10"), port: Port(4202));
    Map<String, String> msg = {};
    var receiver = await UDP.bind(multicastEndpoint);
    await receiver.listen((datagram) {
      msg = jsonDecode(String.fromCharCodes(datagram.data));
      if (msg['path'] == path) {
        callback(msg);
      }
    });
  }

  static Future<void> receiveAck(String path, Function callback) async {
    var multicastEndpoint =
        Endpoint.multicast(InternetAddress("224.10.10.10"), port: Port(4200));
    Map<String, String> msg = {};
    var receiver = await UDP.bind(multicastEndpoint);
    await receiver.listen((datagram) {
      msg = jsonDecode(String.fromCharCodes(datagram.data));
      if (msg['path'] == path) {
        callback(msg);
      }
    });
  }
}
