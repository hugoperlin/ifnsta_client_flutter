import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import './auth_service.dart';
import './http_service.dart';
import './utils.dart';

import '../models/imagem.dart';

class ImagemServiceException implements Exception {
  final msg;

  ImagemServiceException(this.msg);
}

class ImagemService with ChangeNotifier {
  List<Imagem> _lista = [];
  List<Imagem> get lista {
    _lista.sort((img1, img2) => img1.id - img2.id);
    return _lista;
  }

  AuthService authService;
  HttpService httpService;

  ImagemService({
    required this.authService,
    required this.httpService,
  });

  Future<void> carregaLista() async {
    final endpoint = "https://${URL_API}/api/imagens";

    await httpService
        .getInstance()
        .get(
          endpoint,
          options: Options(
            headers: {"Authorization": 'Token ${authService.logado?.token}'},
          ),
        )
        .then((resp) {
      _lista.clear();
      resp.data.forEach((x) => _lista.add(Imagem.fromMap(x)));
      notifyListeners();
    });

    return Future.value(null);
  }

  Future<void> salvaImagem(File imagem) async {
    final endpoint = "https://${URL_API}/api/imagens/create/";

    String fileName = imagem.path.split('/').last;
    FormData formData = FormData.fromMap(
      {
        "data": await MultipartFile.fromFile(
          imagem.path,
          filename: fileName,
        ),
      },
    );
    print(authService.logado?.token);
    await httpService
        .getInstance()
        .post(
          endpoint,
          options: Options(
            headers: {"Authorization": 'Token ${authService.logado?.token}'},
          ),
          data: formData,
        )
        .then((resp) {})
        .onError((DioError error, stackTrace) {
      print(error.response?.data);
    });

    return Future.value(null);
  }

  Future<Widget> buscaImagem(int id) async {
    final endpoint = "https://${URL_API}/api/imagens/${id}/";

    return Image.network(
      endpoint,
      fit: BoxFit.fill,
    );
  }

  Future<void> curtirImagem(int id) async {
    final endpoint = "https://${URL_API}/api/imagens/${id}/curtir/";

    await httpService
        .getInstance()
        .put(
          endpoint,
          options: Options(
            headers: {"Authorization": 'Token ${authService.logado?.token}'},
          ),
        )
        .then(
      (resp) {
        final imagem = _lista.firstWhere((img) => img.id == id);
        imagem.curtir();
        notifyListeners();
      },
    ).onError((error, stackTrace) {
      final erro = error as DioError;
      throw ImagemServiceException(erro.response?.data);
    });
  }
}
