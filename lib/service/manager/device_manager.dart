/*
 * @Author GS
 */
import 'dart:convert';

import 'package:arduinoiot/local/local_data.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:arduinoiot/service/server/server.dart';
import 'package:arduinoiot/service/udp/udp.dart';

class DeviceManager {
  void sendData(String path, {Map<String, String> params}) {
    switch (LocalData.connectionType) {
      case ConnectionType.HTTP:
        sendHttpRequest(path, params: params);
        break;
      case ConnectionType.UDP:
        sendUDPRequest(path, params: params);
        break;
    }
  }

  void sendUDPRequest(String path, {Map<String, String> params}) {
    params['path'] = path;
    LocalUDP.send(
      json.encode(params).toString(),
    );
  }

  void sendHttpRequest(String path, {Map<String, String> params}) {
    HttpREST().get(
      path,
      params: params,
    );
  }

  void listenForData(String path, Function(Map<String, String>) callback) {
    switch (LocalData.connectionType) {
      case ConnectionType.HTTP:
        Server().registerService(path, callback);
        break;
      case ConnectionType.UDP:
        LocalUDP.receive(path, (msg) {
          callback(msg);
        });
        break;
    }
  }
}
