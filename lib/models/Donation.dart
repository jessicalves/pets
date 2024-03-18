import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  late String id;
  late String estado;
  late String categoria;
  late String titulo;
  late String descricao;
  late String contato;
  late String cidade;
  late String foto;

  Donation({
    this.id = "",
    this.estado = "",
    this.categoria = "",
    this.titulo = "",
    this.descricao = "",
    this.contato = "",
    this.cidade = "",
    this.foto = "",
  });

  Donation.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    estado = documentSnapshot["estado"];
    categoria = documentSnapshot["categoria"];
    titulo = documentSnapshot["titulo"];
    descricao = documentSnapshot["descricao"];
    contato = documentSnapshot["contato"];
    cidade = documentSnapshot["cidade"];
    foto = documentSnapshot["foto"];
  }

  Donation.gerarId() {
    id = FirebaseFirestore.instance.collection("doacoes").doc().id;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "estado": estado,
      "categoria": categoria,
      "titulo": titulo,
      "descricao": descricao,
      "contato": contato,
      "cidade": cidade,
      "foto": foto,
    };
  }
}
