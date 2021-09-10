import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class HttpService {
  final _dio = Dio();

  HttpService({bool allowBadCertificate = false}) {
    if (allowBadCertificate) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  Dio getInstance() {
    return _dio;
  }
}
