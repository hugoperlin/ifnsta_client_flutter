import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import './autenticacao.dart';
import './home.dart';

class Splash extends StatelessWidget {
  static const routeName = '/splash';

  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    return auth.isLogado ? Home() : Autenticacao();
  }
}
