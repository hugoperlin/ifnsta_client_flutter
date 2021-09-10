import 'dart:convert';

import './user.dart';

class Imagem {
  final int id;
  int curtidas;
  final DateTime dataCriacao;
  final User dono;

  Imagem({
    required this.id,
    required this.curtidas,
    required this.dataCriacao,
    required this.dono,
  });

  Imagem copyWith({
    int? id,
    int? curtidas,
    DateTime? dataCriacao,
    User? dono,
  }) {
    return Imagem(
      id: id ?? this.id,
      curtidas: curtidas ?? this.curtidas,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dono: dono ?? this.dono,
    );
  }

  curtir() {
    curtidas += 1;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'curtidas': curtidas,
      'dataCriacao': dataCriacao,
      'dono': dono.toMap(),
    };
  }

  factory Imagem.fromMap(Map<String, dynamic> map) {
    return Imagem(
      id: map['id'],
      curtidas: map['curtidas'],
      dataCriacao: DateTime.parse(map['dataCriacao']),
      dono: User.fromMap(map['dono']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Imagem.fromJson(String source) => Imagem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Imagem(id: $id, curtidas: $curtidas, dataCriacao: $dataCriacao, dono: $dono)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Imagem &&
        other.id == id &&
        other.curtidas == curtidas &&
        other.dataCriacao == dataCriacao &&
        other.dono == dono;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        curtidas.hashCode ^
        dataCriacao.hashCode ^
        dono.hashCode;
  }
}
