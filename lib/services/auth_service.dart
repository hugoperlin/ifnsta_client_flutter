import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './http_service.dart';
import './utils.dart';

import '../models/user.dart';

class AuthException implements Exception {
  String msg;
  AuthException(this.msg);
}

class AuthService with ChangeNotifier {
  HttpService httpService;

  User? _user = null;

  User? get logado => _user;

  bool get isLogado => _user != null;

  AuthService({
    required this.httpService,
  });

  Future<void> cadastra(String email, String username, String password) async {
    const endpoint = 'https://${URL_API}/api/register/';

    await httpService
        .getInstance()
        .post(endpoint,
            queryParameters: {"key": _user?.token},
            data: {'username': username, 'email': email, 'password': password})
        .then((resp) => print(resp.data))
        .onError((error, stackTrace) => throw AuthException(error.toString()));

    return Future.value(null);
  }

  Future<void> login(String username, String password) async {
    const endpoint = 'https://${URL_API}/api/login/';

    final auth_data = base64.encode(utf8.encode("${username}:${password}"));

    await httpService
        .getInstance()
        .post(endpoint,
            options: Options(headers: {'Authorization': 'basic ${auth_data}'}))
        .then((resp) {
      _user = User.fromJson(json.encode(resp.data));
      notifyListeners();
    }).onError((error, stackTrace) {
      final erro = error as DioError;
      print(erro.response?.data);
      throw AuthException(erro.response?.data);
    });
    return Future.value(null);
  }

  logout() {
    _user = null;
    notifyListeners();
  }
}
