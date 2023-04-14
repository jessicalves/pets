import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets/models/Donation.dart';
import 'package:pets/views/widgets/ItemDoacao.dart';

class MinhasDoacoes extends StatefulWidget {
  const MinhasDoacoes({Key? key}) : super(key: key);

  @override
  State<MinhasDoacoes> createState() => _MinhasDoacoesState();
}

class _MinhasDoacoesState extends State<MinhasDoacoes> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _adicionarListenerDoacao() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    FirebaseAuth auth = FirebaseAuth.instance;
    var usuarioLogado = auth.currentUser;

    Stream<QuerySnapshot> stream = db
        .collection("minhas_doacoes")
        .doc(usuarioLogado?.uid)
        .collection("doacoes")
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
  }


  @override
  void initState() {
    super.initState();
    _adicionarListenerDoacao();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: [Text("Carregando doações"), CircularProgressIndicator()],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Minhas Doações",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/donation");
          },
        ),
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) return Text("Erro ao carregar os dados!");

              QuerySnapshot? querySnapshot = snapshot.data;

              return ListView.builder(
                  itemCount: querySnapshot?.docs.length,
                  itemBuilder: (_, indice) {
                    List<DocumentSnapshot<Object?>>? doacoes = querySnapshot
                        ?.docs
                        .cast<DocumentSnapshot<Object?>>()
                        .toList();
                    DocumentSnapshot documentSnapshot = doacoes![indice];
                    Donation donation =
                        Donation.fromDocumentSnapshot(documentSnapshot);

                    return ItemDoacao(
                      donation: donation,
                      onTapItem: () {},
                      onPressedRemover: () {},
                    );
                  });
          }
          return Container();
        },
      ),
    );
  }
}
