import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ifnsta_client/models/imagem.dart';
import 'package:ifnsta_client/pages/adicionar_foto.dart';

import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/imagem_service.dart';
import '../widgets/item_lista.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _init = true;
  bool _working = false;

  @override
  void didChangeDependencies() {
    if (_init) {
      Provider.of<ImagemService>(context, listen: false).carregaLista();
      _init = false;
    }

    super.didChangeDependencies();
  }

  refresh(BuildContext context) async {
    setState(() {
      _working = true;
    });
    await Provider.of<ImagemService>(context, listen: false).carregaLista();
    setState(() {
      _working = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final imagemService = Provider.of<ImagemService>(context);

    final lista = imagemService.lista;

    return Scaffold(
      appBar: AppBar(
        title: Text('IFnsta'),
        actions: [
          _working
              ? Transform.scale(
                  //permite alterar o tamanho de um widget
                  scale: 0.3,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    refresh(context);
                  },
                  icon: Icon(Icons.refresh)),
          IconButton(onPressed: auth.logout, icon: Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AdicionarFoto.routeName);
        },
        child: Icon(
          Icons.add_a_photo,
          size: 30,
        ),
      ),
      body: lista.length == 0
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (ctx, index) {
                final imagem = lista[index];
                return ItemLista(
                  imagemService: imagemService,
                  imagem: imagem,
                );
              },
            ),
    );
  }
}
