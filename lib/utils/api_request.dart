import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/env.dart';
import 'package:path_provider/path_provider.dart';

late PersistCookieJar persistCookieJar;

class ApiRequest {
  // Need to initialised once at the beginning.
  static void init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    persistCookieJar = PersistCookieJar(
      persistSession: true,
      ignoreExpires: true,
      storage: FileStorage(
        appDocPath + '/.cookies/',
      ),
    );
  }

  static final _dio = Dio(
    BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: _defaultHeaders,
    ),
  );
  static final _client = http.Client();
  static const Map<String, String> _defaultHeaders = {
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36',
    'cookie': 'CONSENT=YES+cb',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'accept-language: en-US,en;q=0.9',
    'sec-fetch-dest': 'document',
    'sec-fetch-mode': 'navigate',
    'sec-fetch-site': 'none',
    'sec-fetch-user': '?1',
    'sec-gpc': '1',
    'upgrade-insecure-requests': '1'
  };

  static Future<Response<String>> get(String url) {
    _dio.interceptors.add(CookieManager(persistCookieJar));
    _dio.interceptors.add(AppHttpInterceptor());
    return _dio.get(url, queryParameters: _defaultHeaders);
  }

  static Future<Response<String>> post(String url, dynamic data) async {
    _dio.interceptors.add(CookieManager(persistCookieJar));
    _dio.interceptors.add(AppHttpInterceptor());

    return _dio.post(
      url,
      data: data,
      queryParameters: _defaultHeaders,
    );
  }
}

class AppHttpInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(options.path);
    if (options.data != null && EnvConfig.logLevel == 1) {
      log(options.data.toString());
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('${response.statusCode}');
    if (EnvConfig.logLevel == 1) {
      log(response.data);
    }
    super.onResponse(response, handler);
  }
}
