/*
 * @Author GS
 */
import 'dart:convert';

import 'package:arduinoiot/local/local_data.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:arduinoiot/service/server/server.dart';
import 'package:arduinoiot/service/udp/udp.dart';
import 'package:http/http.dart';

class DeviceManager {
  Future<void> sendData(String path, {Map<String, String> params}) async {
    switch (LocalData.connectionType) {
      case ConnectionType.HTTP:
        await sendHttpRequest(path, params: params);
        break;
      case ConnectionType.UDP:
        await sendUDPRequest(path, params: params);
        break;
    }
  }

  Future<void> sendUDPRequest(String path, {Map<String, String> params}) async {
    params['path'] = path;
    await LocalUDP.send(
      json.encode(params).toString(),
    );
  }

  Future<void> sendHttpRequest(String path,
      {Map<String, String> params}) async {
    Response res = await HttpREST().get(
      path,
      params: params,
    );
    print(res.body);
    print(res.toString());
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
