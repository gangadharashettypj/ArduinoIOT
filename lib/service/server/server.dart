/*
 * @Author GS
 */

import 'dart:io';

class Server {
  static var _instance;
  static Future<HttpServer> get inst async {
    if (_instance == null) {
      _instance = await HttpServer.bind('0.0.0.0', 2345);
      print("Server running on IP : " +
          _instance.address.toString() +
          " On Port : " +
          _instance.port.toString());
    }
    return _instance;
  }

  static HttpServer get instance {
    return _instance;
  }
}
