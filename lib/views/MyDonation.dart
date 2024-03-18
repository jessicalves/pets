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
  late final StreamController<QuerySnapshot> _controller =
  StreamController<QuerySnapshot>.broadcast();

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
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _adicionarListenerDoacao() {
    final db = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final usuarioLogado = auth.currentUser;
    final stream = db
        .collection("minhas_doacoes")
        .doc(usuarioLogado?.uid)
        .collection("doacoes")
        .snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
  }

  Future<void> _removerDoacao(String idDoacao) async {
    final db = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final usuarioLogado = auth.currentUser;

    await db
        .collection("minhas_doacoes")
        .doc(usuarioLogado?.uid)
        .collection("doacoes")
        .doc(idDoacao)
        .delete();

    await db.collection("doacoes").doc(idDoacao).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removido com sucesso!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carregandoDados = Center(
      child: Column(
        children: const [
          Text("Carregando doações"),
          CircularProgressIndicator(),
        ],
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
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) return const Text("Erro ao carregar os dados!");

              final querySnapshot = snapshot.data;
              final doacoes = querySnapshot?.docs.cast<DocumentSnapshot<Object?>>().toList();

              return ListView.builder(
                itemCount: doacoes?.length ?? 0,
                itemBuilder: (_, indice) {
                  final documentSnapshot = doacoes![indice];
                  final donation = Donation.fromDocumentSnapshot(documentSnapshot);

                  return ItemDoacao(
                    donation: donation,
                    onTapItem: () {},
                    onPressedRemover: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirmar"),
                            content: const Text("Deseja realmente excluir a doação?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _removerDoacao(donation.id);
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Remover",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            default:
              return Container();
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_note),
              color: Colors.green,
              onPressed: () {},
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
