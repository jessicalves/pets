import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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

  void _removerDoacao(String idDoacao) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    var usuarioLogado = auth.currentUser;

    db
        .collection("minhas_doacoes")
        .doc(usuarioLogado?.uid)
        .collection("doacoes")
        .doc(idDoacao)
        .delete()
        .then((_) => {
              db.collection("doacoes").doc(idDoacao).delete(),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removido com sucesso!'),
                ),
              )
            });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerDoacao();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "MyDonation Screen");
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
                      onPressedRemover: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content:
                                    Text("Deseja realmente excluir a doação?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _removerDoacao(donation.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Remover",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                    );
                  });
          }
          return Container();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_note),
              color: Colors.green,
              onPressed: () {
              },
              iconSize: 40,
            ),
            IconButton(
              icon: const Icon(Icons.volunteer_activism),
              color: Colors.grey,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/donation");
              },
              iconSize: 40,
            ),
          ],
        ),
      ),
    );
  }
}
