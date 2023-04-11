import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  String _id = "";
  String _estado = "";
  String _categoria = "";
  String _titulo = "";
  String _descricao = "";
  String _contato = "";
  String _cidade = "";
  String _foto = "";

  Donation() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference novaColecaoRef = db.collection("minhas_doacoes");
    var novoRegistroRef = novaColecaoRef.doc();
    var novoRegistroKey = novoRegistroRef.id;
    id = novoRegistroKey;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : id,
      "estado": estado,
      "categoria": categoria,
      "titulo": titulo,
      "descricao": descricao,
      "contato": contato,
      "cidade": cidade,
      "foto": foto,
    };

    return map;
  }

  String get foto => _foto;

  set foto(String value) {
    _foto = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get contato => _contato;

  set contato(String value) {
    _contato = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
