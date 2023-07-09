/*
 * @Author GS
 */
import 'dart:convert';

import 'package:arduino_iot_v2/local/local_data.dart';
import 'package:arduino_iot_v2/service/rest/http_rest.dart';
import 'package:arduino_iot_v2/service/udp/udp.dart';
import 'package:http/http.dart';

class DeviceManager {
  Future<void> sendData(String path, {Map<String, String>? params}) async {
    switch (LocalData.connectionType) {
      case ConnectionType.HTTP:
        await sendHttpRequest(path, params: params);
        break;
      case ConnectionType.UDP:
        await sendUDPRequest(path, params: params);
        break;
    }
  }

  Future<void> sendUDPRequest(String path,
      {Map<String, String>? params}) async {
    params ??= {};
    params['path'] = path;
    await LocalUDP.send(
      json.encode(params).toString(),
    );
  }

  Future<void> sendHttpRequest(String path,
      {Map<String, String>? params}) async {
    Response? res = await HttpREST().get(
      path,
      params: params,
    );
    print(res?.body);
    print(res?.toString());
  }
}
