/*
 * @Author GS
 */
import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:http/http.dart' as http;

class HttpREST {
//  static HttpREST _instance;
//
//  static HttpREST get instance {
//    if (_instance == null) {
//      _instance = HttpREST();
//    }
//    return _instance;
//  }

  Future<http.Response> get(String url, {Map<String, String> params}) async {
    String formattedUrl = url;
    if (params != null && params.length > 0) {
      formattedUrl += '?';
      params.forEach((String k, String v) => formattedUrl += "$k=$v&");
    }
    http.Response response;
    try {
      response = await http.get(R.api.baseUrl + formattedUrl);
    } catch (e) {
      print(e);
    }
    return response;
  }
}
