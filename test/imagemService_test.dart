import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import '../lib/services/http_service.dart';
import '../lib/services/imagem_service.dart';
import '../lib/services/auth_service.dart';

void main() {
  test('Busca Imagens', () async {
    final http = HttpService(allowBadCertificate: true);
    final auth = AuthService(httpService: http);

    await auth.login("blah", "123456");

    final service = ImagemService(authService: auth, httpService: http);

    await service.carregaLista();
    expect(service.lista.length, greaterThan(0));
  });

  test('Busca Imagem', () async {
    final http = HttpService(allowBadCertificate: true);
    final auth = AuthService(httpService: http);

    await auth.login("blah", "123456");

    final service = ImagemService(authService: auth, httpService: http);

    final imagem = await service.buscaImagem(1);
    expect(imagem, isNotNull);
  });

  test('Curtir Imagem', () async {
    final http = HttpService(allowBadCertificate: true);
    final auth = AuthService(httpService: http);

    await auth.login("blah", "123456");

    final service = ImagemService(authService: auth, httpService: http);

    await service.curtirImagem(3);
  });

  test('Salva Imagem', () async {
    var dir = Directory.current.path;
    final http = HttpService(allowBadCertificate: true);
    final auth = AuthService(httpService: http);

    await auth.login("blah", "123456");

    final service = ImagemService(authService: auth, httpService: http);

    File file = File('test/xpto.png');

    await service.salvaImagem(file);
  });
}
