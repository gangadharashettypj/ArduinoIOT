/*
 * @Author GS
 */

import 'dart:io';

import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/rest/HTTPRest.dart';
import 'package:get_ip/get_ip.dart';

class Server {
  static var _instance;
  static Map<String, Function(HttpRequest)> maps = {};
  static Future<HttpServer> get inst async {
    if (_instance == null) {
      _instance = await HttpServer.bind('0.0.0.0', 2345);
      print("Server running on IP : " +
          _instance.address.toString() +
          " On Port : " +
          _instance.port.toString());
      String str = await GetIp.ipAddress;
      HttpREST().get(
        R.api.setClientIP,
        params: {
          'ip': str,
          'port': '2345',
        },
      );
      _listenToRequests();
    }
    return _instance;
  }

  void registerService(String path, Function(HttpRequest) callback) {
    maps[path] = callback;
  }

  static void _listenToRequests() async {
    Server.instance.listen((HttpRequest request) {
      _mapRequestToService(request);
    });
  }

  static HttpServer get instance {
    return _instance;
  }

  static void _mapRequestToService(HttpRequest request) {
    if (maps.containsKey(request.uri.queryParameters['type'])) {
      maps[request.uri.queryParameters['type']](request);
    }
  }
}
