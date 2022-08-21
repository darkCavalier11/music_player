import 'package:dio/dio.dart';

class ApiRequest {
  static final _dio = Dio(
    BaseOptions(
      connectTimeout: 5000,
    ),
  );

  static Future<Response> get(String url, {Options? options}) async {
    return _dio.getUri(Uri.parse(url), options: options);
  }

  static Future<Response> post(String url, dynamic data,
      {Options? options}) async {
    return _dio.postUri(
      Uri.parse(url),
      data: data,
      options: options,
    );
  }
}
