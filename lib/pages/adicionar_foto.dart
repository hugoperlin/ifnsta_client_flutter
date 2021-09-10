import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/imagem_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdicionarFoto extends StatefulWidget {
  static const routeName = '/adicionar_foto';

  const AdicionarFoto({Key? key}) : super(key: key);

  @override
  State<AdicionarFoto> createState() => _AdicionarFotoState();
}

class _AdicionarFotoState extends State<AdicionarFoto> {
  File? _img = null;
  bool _working = false;

  _tirarFoto() async {
    final XFile? photo =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _img = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagemService = Provider.of<ImagemService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Enviar foto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  width: 600,
                  height: 400,
                  child: _img != null
                      ? Image.file(
                          _img!,
                          fit: BoxFit.fill,
                        )
                      : IconButton(
                          onPressed: _tirarFoto,
                          icon: Icon(
                            Icons.photo_camera,
                            size: 40,
                          )),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _img != null || !_working
                  ? () {
                      setState(() {
                        _working = true;
                      });
                      imagemService.salvaImagem(_img!).then((value) {
                        setState(() {
                          _working = false;
                        });
                        Navigator.of(context).pop();
                      });
                    }
                  : null,
              child: _working ? CircularProgressIndicator() : Text("Enviar"),
            )
          ],
        ),
      ),
    );
  }
}
