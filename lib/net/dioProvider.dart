import 'package:dio/dio.dart';

import '../config/net_config.dart';

class MyDio {
  static Dio createDio() {
    Dio dio;
    var options = BaseOptions(
      baseUrl: NetConfig.ip,
      contentType: Headers.formUrlEncodedContentType,
    );
    dio = Dio(options);
    return dio;
  }
}
