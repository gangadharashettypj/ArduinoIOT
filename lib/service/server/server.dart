/*
 * @Author GS
 */

import 'dart:io';

import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/rest/http_rest.dart';
import 'package:get_ip/get_ip.dart';

class Server {
  static var _instance;
  static Map<String, Function(Map<String, String>)> maps = {};
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

  void registerService(String path, Function(Map<String, String>) callback) {
    print('Path>>$path');
    maps[path] = callback;
  }

  static void _listenToRequests() async {
    Server.instance.listen((HttpRequest request) {
      // print(request.uri.queryParameters.toString());
      // print('>>>');
      // print(maps.keys);
      if (maps.containsKey(request.uri.queryParameters['type'])) {
        maps[request.uri.queryParameters['type']](request.uri.queryParameters);
        request.response
          ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
          ..write({'status': 'success', 'status code': '200'})
          ..close();
      } else {
        request.response
          ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
          ..write({'status': 'failure', 'status code': '404'})
          ..close();
      }
    });
  }

  static HttpServer get instance {
    return _instance;
  }
}
