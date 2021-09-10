import 'dart:io';

import 'package:flutter/material.dart';

import 'package:ifnsta_client/pages/adicionar_foto.dart';
import 'package:ifnsta_client/pages/autenticacao.dart';

import 'package:provider/provider.dart';

import './services/auth_service.dart';
import './services/http_service.dart';
import './services/imagem_service.dart';
import './pages/splash.dart';
import 'tema/meus_temas.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TemaProvider()),
        Provider.value(value: HttpService(allowBadCertificate: true)),
        ChangeNotifierProxyProvider<HttpService, AuthService>(
          create: (ctx) => AuthService(
            httpService: Provider.of<HttpService>(ctx, listen: false),
          ),
          update: (ctx, httpService, anterior) =>
              AuthService(httpService: httpService),
        ),
        ChangeNotifierProxyProvider2<HttpService, AuthService, ImagemService>(
          create: (ctx) => ImagemService(
            authService: Provider.of<AuthService>(ctx, listen: false),
            httpService: Provider.of<HttpService>(ctx, listen: false),
          ),
          update: (ctx, httpService, authService, anterior) =>
              ImagemService(authService: authService, httpService: httpService),
        )
      ],
      builder: (ctx, _) {
        final temaProvider = Provider.of<TemaProvider>(ctx);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "IFnsta",
          initialRoute: Splash.routeName,
          themeMode: temaProvider.isDark ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            primaryColor: Colors.purple,
            colorScheme: ColorScheme.light(
              primary: Colors.purple,
              secondary: Colors.amber,
            ),
            fontFamily: 'RobotoMono',
            textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          routes: {
            Autenticacao.routeName: (ctx) => Autenticacao(),
            Splash.routeName: (ctx) => Splash(),
            AdicionarFoto.routeName: (ctx) => AdicionarFoto(),
          },
        );
      },
    );
  }
}
