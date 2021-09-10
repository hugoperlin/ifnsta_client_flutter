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
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
  );

  static final lightTheme = ThemeData(
    primaryColor: Colors.purple,
    colorScheme: ColorScheme.light(
      primary: Colors.purple,
      secondary: Colors.amber,
    ),
    fontFamily: 'RobotoMono',
    textTheme: TextTheme(
      headline6: TextStyle(
          color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
