import 'package:flutter_test/flutter_test.dart';
import '../lib/services/http_service.dart';
import '../lib/services/auth_service.dart';

void main() {
  test('Faz login', () async {
    final auth =
        AuthService(httpService: HttpService(allowBadCertificate: true));

    await auth.login("blah", "123456");
    expect(true, auth.isLogado);
    expect("admin", auth.logado?.username);
  });

  test('Cria usuario', () async {
    final auth =
        AuthService(httpService: HttpService(allowBadCertificate: true));

    await auth.login("blah", "123456");
    expect(true, auth.isLogado);
    expect("blah", auth.logado?.username);

    await auth.cadastra("user1@teste.com", "user1", "123456");
  });
}
