import 'package:flutter/material.dart';
import 'package:ifnsta_client/tema/meus_temas.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class Autenticacao extends StatefulWidget {
  static const routeName = '/autenticacao';

  Autenticacao({Key? key}) : super(key: key);

  @override
  _AutenticacaoState createState() => _AutenticacaoState();
}

class _AutenticacaoState extends State<Autenticacao> {
  var novoUsuario = false;
  var username = '';
  var email = '';
  var senha = '';
  var confirmacaoSenha = '';
  var ocultarSenha = true;
  final formKey = GlobalKey<FormState>();

  mudaNovoUsuario() {
    setState(() {
      novoUsuario = !novoUsuario;
    });
  }

  mudaOcultarSenha() {
    setState(() {
      ocultarSenha = !ocultarSenha;
    });
  }

  submeter(AuthService servicoAutenticao) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        if (novoUsuario) {
          await servicoAutenticao.cadastra(email, username, senha);
        } else {
          await servicoAutenticao.login(username, senha);
        }
      } on AuthException catch (e) {
        print(e.msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicoAutenticacao =
        Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('IFnsta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (novoUsuario)
                _CustomFormField(
                  label: "E-mail",
                  hint: "Digite seu e-mail",
                  icon: Icon(Icons.email),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Não pode ser vazio';
                    }
                    if (!text.contains("@") || !text.contains(".")) {
                      return 'Digite um e-mail válido!';
                    }
                  },
                  save: (text) {
                    setState(() {
                      email = text ?? '';
                    });
                  },
                ),
              if (novoUsuario) SizedBox(height: 8),
              _CustomFormField(
                label: "Username",
                hint: "Digite seu username",
                icon: Icon(Icons.person),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Não pode ser vazio';
                  }
                },
                save: (text) {
                  setState(() {
                    username = text ?? '';
                  });
                },
              ),
              SizedBox(height: 8),
              _CustomFormField(
                label: "Senha",
                hint: "Digite sua senha",
                icon: Icon(Icons.vpn_key),
                obscureText: ocultarSenha,
                sufixIcon: IconButton(
                  icon: Icon(
                      ocultarSenha ? Icons.visibility : Icons.visibility_off),
                  onPressed: mudaOcultarSenha,
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Não pode ser vazio!';
                  }

                  if (text.length < 6) {
                    return 'A senha necessita de no mínimo 6 caracteres!';
                  }
                  if (novoUsuario && senha != confirmacaoSenha) {
                    return 'As senhas não são iguais!';
                  }
                },
                save: (text) {
                  setState(() {
                    senha = text ?? '';
                  });
                },
                onChanged: (text) {
                  setState(() {
                    senha = text ?? '';
                  });
                },
              ),
              if (novoUsuario) SizedBox(height: 8),
              if (novoUsuario)
                _CustomFormField(
                  label: "Confirmação da senha",
                  hint: "Digite a senha novamente",
                  icon: Icon(Icons.vpn_key),
                  obscureText: ocultarSenha,
                  sufixIcon: IconButton(
                    icon: Icon(
                        ocultarSenha ? Icons.visibility : Icons.visibility_off),
                    onPressed: mudaOcultarSenha,
                  ),
                  validator: (text) {
                    if (novoUsuario) {
                      if (text == null || text.isEmpty) {
                        return 'Não pode ser vazio!';
                      }

                      if (text.length < 6) {
                        return 'A senha necessita de no mínimo 6 caracteres!';
                      }
                      if (senha != confirmacaoSenha) {
                        return 'As senhas não são iguais!';
                      }
                    }
                  },
                  onChanged: (text) {
                    setState(() {
                      confirmacaoSenha = text ?? '';
                    });
                  },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submeter(servicoAutenticacao);
                },
                child: Text(novoUsuario ? 'Cadastrar' : 'Login'),
              ),
              TextButton(
                onPressed: mudaNovoUsuario,
                child: Text(novoUsuario ? 'Login' : 'Novo usuário'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomFormField extends StatelessWidget {
  final String label;
  final String hint;
  final Icon? icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String?)? save;
  final Function(String?)? onChanged;
  final bool obscureText;
  final Widget? sufixIcon;

  const _CustomFormField({
    Key? key,
    required this.label,
    required this.hint,
    this.icon,
    this.keyboardType,
    this.validator,
    this.save,
    this.onChanged,
    this.obscureText = false,
    this.sufixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: save,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: sufixIcon,
        prefixIcon: icon,
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}

class SwithTheme extends StatefulWidget {
  SwithTheme({Key? key}) : super(key: key);

  @override
  _SwithThemeState createState() => _SwithThemeState();
}

class _SwithThemeState extends State<SwithTheme> {
  @override
  Widget build(BuildContext context) {
    final temaProvider = Provider.of<TemaProvider>(context, listen: false);

    return Switch.adaptive(
        value: temaProvider.isDark,
        onChanged: (changed) => temaProvider.mudaTema());
  }
}
