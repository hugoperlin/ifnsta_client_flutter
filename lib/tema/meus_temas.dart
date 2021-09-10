import 'package:flutter/material.dart';

class TemaProvider with ChangeNotifier {
  bool _dark = false;

  bool get isDark => _dark;

  mudaTema() {
    _dark = !_dark;

    notifyListeners();
  }
}

class MeusTemas {
  static final dark = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade700,
      primaryColor: Colors.black,
      colorScheme: ColorScheme.dark(primary: Colors.white));

  static final light = ThemeData(
    scaffoldBackgroundColor: Colors.yellow.shade100,
    primaryColor: Colors.pink,
    colorScheme: ColorScheme.light(primary: Colors.pink),
    fontFamily: 'RobotoMono',
  );
}
