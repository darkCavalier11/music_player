import 'package:http/http.dart' as http;

class ApiRequest {
  static Future<http.Response> get(String url,
      {Map<String, String>? headers}) async {
    return http.get(Uri.parse(url), headers: headers);
  }
}
