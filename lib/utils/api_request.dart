import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:music_player/env.dart';
import 'package:path_provider/path_provider.dart';

late PersistCookieJar persistCookieJar;

class ApiRequest {
  // Need to initialised once at the beginning.
  static Future<void> init() async {
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
      headers: _defaultHeaders,
    ),
  );
  static const Map<String, String> _defaultHeaders = {
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36',
    'Cookie':
        'GPS=1; YSC=UXDSIGaFIJM; VISITOR_INFO1_LIVE=U-GtxxdUtbg; VISITOR_PRIVACY_METADATA=CgJJThIEGgAgJA%3D%3D; SOCS=CAISNQgDEitib3FfaWRlbnRpdHlmcm9udGVuZHVpc2VydmVyXzIwMjMwODI5LjA3X3AxGgJlbiADGgYIgJnPpwY; PREF=f6=40000000&tz=Asia.Calcutta',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'accept-language: en-US,en;q=0.9',
    'sec-fetch-dest': 'document',
    'sec-fetch-mode': 'navigate',
    'sec-fetch-site': 'none',
    'sec-fetch-user': '?1',
    'sec-gpc': '1',
    'upgrade-insecure-requests': '1',
    'User-Agent': 'PostmanRuntime/7.36.3'
  };

  static String getSearchPayload(String query) {
    return '{"context":{"client":{"hl":"en-GB","gl":"IN","remoteHost":"45.121.2.125","deviceMake":"Apple","deviceModel":"","visitorData":"CgtVLUd0eHhkVXRiZyj2mqWvBjIKCgJJThIEGgAgJA%3D%3D","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36,gzip(gfe)","clientName":"WEB","clientVersion":"2.20240304.00.00","osName":"Macintosh","osVersion":"10_15_7","originalUrl":"https://www.youtube.com/results?search_query=${query.replaceAll(' ', '+')}","platform":"DESKTOP","clientFormFactor":"UNKNOWN_FORM_FACTOR","configInfo":{"appInstallData":"CPaapa8GEMm4sAUQt-r-EhCiu7AFEKKBsAUQ9sCwBRCGtrAFELiqsAUQz6iwBRCIh7AFEKKSsAUQt6uwBRDViLAFENyCsAUQkLuwBRChw7AFENCNsAUQgrawBRDbr68FEJeDsAUQ4sawBRDM364FEKaBsAUQvoqwBRC--a8FEKaasAUQ6L-wBRDnuq8FEMn3rwUQibawBRComrAFEN3o_hIQ-qewBRCku7AFEOHyrwUQ7qKvBRCa8K8FENPhrwUQt--vBRCu1P4SEPyFsAUQg7-wBRD2q7AFENShrwUQu9KvBRC2srAFEO6zsAUQ3MOwBRDzobAFEPSrsAUQ4tSuBRDrk64FEPywsAUQvZmwBRCI468FEIyY_xIQ6sOvBRDZya8FEL22rgUQ1-mvBRClwv4SEKa7sAUQkLKwBRC8-a8FEInorgUQqruwBRDr6P4SELfgrgUQmrCwBRC9t7AFEJWVsAUQvcOwBRDDubAFEMq1sAUQ3qiwBRCYxbAFKjBDQU1TSGhVZG9MMndETkhrQm9qWkhzV3FELVh0eUF2MnB3YlpHNjdfaUEwZEJ3PT0%3D"},"userInterfaceTheme":"USER_INTERFACE_THEME_DARK","timeZone":"Asia/Calcutta","browserName":"Chrome","browserVersion":"122.0.0.0","acceptHeader":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8","deviceExperimentId":"ChxOek0wTXpRNE5UZ3pPREV3T0RZeU56SXhOUT09EPaapa8GGPaapa8G","screenWidthPoints":810,"screenHeightPoints":847,"screenPixelDensity":1,"screenDensityFloat":1,"utcOffsetMinutes":330,"memoryTotalKbytes":"2000000","mainAppWebInfo":{"graftUrl":"/results?search_query=${query.replaceAll(' ', '+')}","pwaInstallabilityStatus":"PWA_INSTALLABILITY_STATUS_UNKNOWN","webDisplayMode":"WEB_DISPLAY_MODE_BROWSER","isWebNativeShareAvailable":false}},"user":{"lockedSafetyMode":false},"request":{"useSsl":true,"internalExperimentFlags":[],"consistencyTokenJars":[]},"clickTracking":{"clickTrackingParams":"CA0Q7VAiEwi3s9_RsuGEAxVmvVYBHVxHCUI="},"adSignalsInfo":{"params":[{"key":"dt","value":"1709788534713"},{"key":"flash","value":"0"},{"key":"frm","value":"0"},{"key":"u_tz","value":"330"},{"key":"u_his","value":"2"},{"key":"u_h","value":"854"},{"key":"u_w","value":"810"},{"key":"u_ah","value":"854"},{"key":"u_aw","value":"810"},{"key":"u_cd","value":"24"},{"key":"bc","value":"31"},{"key":"bih","value":"847"},{"key":"biw","value":"795"},{"key":"brdim","value":"4,4,4,4,810,4,810,854,810,847"},{"key":"vis","value":"1"},{"key":"wgl","value":"true"},{"key":"ca_type","value":"image"}]}},"query":"$query","webSearchboxStatsUrl":"/search?oq=$query&gs_l=youtube.12..0i512i433k1l2j0i512k1l12.8549.10208.0.16208.13.11.0.0.0.0.736.2101.4-3j0j1.6.0....0...1ac.1.64.youtube..7.4.2101.0...774.XKmhSbST7lA"}';
  }

  static String getNextListOfMusicPayload(String musicId) {
    return '{"context":{"client":{"hl":"en-GB","gl":"IN","remoteHost":"45.121.2.125","deviceMake":"Apple","deviceModel":"","visitorData":"CgtVLUd0eHhkVXRiZyjcpaWvBjIKCgJJThIEGgAgJA%3D%3D","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36,gzip(gfe)","clientName":"WEB","clientVersion":"2.20240304.00.00","osName":"Macintosh","osVersion":"10_15_7","originalUrl":"https://www.youtube.com/watch?v=$musicId","platform":"DESKTOP","clientFormFactor":"UNKNOWN_FORM_FACTOR","configInfo":{"appInstallData":"CNylpa8GELersAUQ2cmvBRDov7AFEO6zsAUQkLuwBRDuoq8FELiqsAUQt-r-EhDrk64FEKiasAUQ3MOwBRCDv7AFEJeDsAUQ-qewBRC9t7AFEKaasAUQ6-j-EhDd6P4SEKa7sAUQ1KGvBRDJuLAFEKS7sAUQ1-mvBRC9mbAFEIiHsAUQ6sOvBRC8-a8FEJCysAUQ98CwBRD2q7AFEMn3rwUQ0I2wBRCJ6K4FEIjjrwUQlZWwBRDzobAFEIa2sAUQ3IKwBRCMmP8SEIK2sAUQt-CuBRC9tq4FEKaBsAUQ26-vBRDPqLAFEIm2sAUQ4fKvBRCa8K8FEKKBsAUQ4sawBRClwv4SEPywsAUQt--vBRDnuq8FEKHDsAUQu9KvBRDViLAFEK7U_hIQ0-GvBRD0q7AFEJqwsAUQ4tSuBRC-irAFEKq7sAUQ_IWwBRCikrAFELaysAUQvvmvBRDM364FEKK7sAUQvcOwBRDKtbAFEMO5sAUQmMWwBRDeqLAFKjBDQU1TSGhVZG9MMndETkhrQm9qWkhzV3FELVh0eUF2MnB3YlpHNjdfaUEwZEJ3PT0%3D"},"userInterfaceTheme":"USER_INTERFACE_THEME_DARK","timeZone":"Asia/Calcutta","browserName":"Chrome","browserVersion":"122.0.0.0","acceptHeader":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8","deviceExperimentId":"ChxOek0wTXpRNU1UYzNOREV6TWpjME1EY3lOQT09ENylpa8GGNylpa8G","screenWidthPoints":810,"screenHeightPoints":847,"screenPixelDensity":1,"screenDensityFloat":1,"utcOffsetMinutes":330,"memoryTotalKbytes":"2000000","clientScreen":"WATCH","mainAppWebInfo":{"graftUrl":"/watch?v=$musicId","pwaInstallabilityStatus":"PWA_INSTALLABILITY_STATUS_UNKNOWN","webDisplayMode":"WEB_DISPLAY_MODE_BROWSER","isWebNativeShareAvailable":false}},"user":{"lockedSafetyMode":false},"request":{"useSsl":true,"internalExperimentFlags":[],"consistencyTokenJars":[]},"clickTracking":{"clickTrackingParams":"CO4CENwwIhMI3Y7d5LfhhAMV56tWAR0itAFjMgpnLWhpZ2gtcmVjWg9GRXdoYXRfdG9fd2F0Y2iaAQYQjh4YngE="},"adSignalsInfo":{"params":[{"key":"dt","value":"1709789916178"},{"key":"flash","value":"0"},{"key":"frm","value":"0"},{"key":"u_tz","value":"330"},{"key":"u_his","value":"2"},{"key":"u_h","value":"854"},{"key":"u_w","value":"810"},{"key":"u_ah","value":"854"},{"key":"u_aw","value":"810"},{"key":"u_cd","value":"24"},{"key":"bc","value":"31"},{"key":"bih","value":"847"},{"key":"biw","value":"795"},{"key":"brdim","value":"4,4,4,4,810,4,810,854,810,847"},{"key":"vis","value":"1"},{"key":"wgl","value":"true"},{"key":"ca_type","value":"image"}]}},"videoId":"$musicId","racyCheckOk":false,"contentCheckOk":false,"autonavState":"STATE_NONE","playbackContext":{"vis":0,"lactMilliseconds":"-1"},"captionsRequested":false}';
  }

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

  static Future<Response<dynamic>> download({
    required Uri uri,
    required String savePath,
    Function(int count, int total)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    return _dio.downloadUri(
      uri,
      savePath,
      onReceiveProgress: onReceiveProgress,
      deleteOnError: true,
      cancelToken: cancelToken,
    );
  }
}

class AppHttpInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(options.path, name: 'Url');
    if (options.data != null && EnvConfig.logLevel == 1) {
      log(options.data.toString());
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('${response.statusCode}', name: 'StatusCode');
    if (EnvConfig.logLevel == 1) {
      log(response.data);
    }
    super.onResponse(response, handler);
  }
}
