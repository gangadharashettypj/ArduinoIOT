/*
 * @Author GS
 */
import 'package:arduino_iot_v2/resources/nestbees_resources.dart';
import 'package:http/http.dart' as http;

class HttpREST {
  Future<http.Response?> get(String url, {Map<String, String>? params}) async {
    String formattedUrl = url;
    if (params != null && params.isNotEmpty) {
      formattedUrl += '?';
      params.forEach((String k, String v) => formattedUrl += "$k=$v&");
    }
    http.Response? response;
    try {
      response = await http.get(Uri.parse(R.api.baseUrl + formattedUrl));
    } catch (e) {
      print(e);
    }
    return response;
  }
}
