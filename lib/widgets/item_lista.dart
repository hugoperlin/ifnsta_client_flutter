import 'package:flutter/material.dart';

import '../services/imagem_service.dart';
import '../models/imagem.dart';

class ItemLista extends StatelessWidget {
  const ItemLista({
    Key? key,
    required this.imagemService,
    required this.imagem,
  }) : super(key: key);

  final ImagemService imagemService;
  final Imagem imagem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FutureBuilder(
                future: imagemService.buscaImagem(imagem.id),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data as Image;
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            try {
                              await imagemService.curtirImagem(imagem.id);
                            } on ImagemServiceException catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(e.msg)));
                            }
                          },
                          icon: Icon(Icons.thumb_up_outlined)),
                      Text("${imagem.curtidas}")
                    ],
                  ),
                  Spacer(),
                  Text(
                    "${imagem.dono.username}",
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
