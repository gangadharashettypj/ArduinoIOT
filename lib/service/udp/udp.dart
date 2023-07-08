/*
 * @Author GS
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:udp/udp.dart';

class LocalUDP {
  static Future<int> send(String msg) async {
    var multicastEndpoint = Endpoint.multicast(InternetAddress("224.10.10.10"),
        port: const Port(4200));
    var sender = await UDP.bind(Endpoint.any());
    return await sender
        .send(msg.codeUnits, multicastEndpoint)
        .whenComplete(() => sender.close())
        .catchError((e) => print(e));
  }

  static Future<StreamSubscription> receive(Function(String) callback) async {
    var multicastEndpoint = Endpoint.multicast(InternetAddress("224.10.10.10"),
        port: const Port(4202));
    Map<String, String> msg = {};
    var receiver = await UDP.bind(multicastEndpoint);
    return receiver.asStream().listen((datagram) {
      callback(String.fromCharCodes(datagram?.data ?? []));
    });
  }

  static Future<void> receiveAck(String path, Function callback) async {
    var multicastEndpoint = Endpoint.multicast(InternetAddress("224.10.10.10"),
        port: const Port(4200));
    Map<String, String> msg = {};
    var receiver = await UDP.bind(multicastEndpoint);
    receiver.asStream().listen((datagram) {
      msg = jsonDecode(String.fromCharCodes(datagram?.data ?? []));
      if (msg['path'] == path) {
        callback(msg);
      }
    });
  }
}
