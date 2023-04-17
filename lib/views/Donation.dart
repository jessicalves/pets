import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets/views/widgets/ItemDoacao.dart';

import '../models/Donation.dart';

class HomeDonation extends StatefulWidget {
  const HomeDonation({Key? key}) : super(key: key);

  @override
  State<HomeDonation> createState() => _HomeDonationState();
}

class _HomeDonationState extends State<HomeDonation> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  late String _categoriaSelecionada;

  _adicionarListenerDoacao() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("doacoes").snapshots();
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
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Doações",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField(
            //   keyboardType: TextInputType.text,
            //   style: const TextStyle(fontSize: 14),
            //   decoration: InputDecoration(
            //       contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            //       hintText: '🔎 Procure por alimentos, acessórios, etc.',
            //       filled: true,
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: const BorderSide(color: Colors.green),
            //           borderRadius: BorderRadius.circular(30))),
            //   cursorColor: Colors.green,
            // ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 2),
                  ElevatedButton(
                    onPressed: () {
                      _categoriaSelecionada = "Alimentos";
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage('assets/dogfood.png'),
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Alimentos',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _categoriaSelecionada = "Acessórios";
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage('assets/acessories.png'),
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Acessórios',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _categoriaSelecionada = "Brinquedos";
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage('assets/toys.png'),
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Brinquedos',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _categoriaSelecionada = "Medicamentos";
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage('assets/medicines.png'),
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Medicamentos',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return carregandoDados;
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text("Erro ao carregar os dados!");

                    QuerySnapshot? querySnapshot = snapshot.data;

                    return SizedBox(
                      height: 620,
                      child: ListView.builder(
                          itemCount: querySnapshot?.docs.length,
                          itemBuilder: (_, indice) {
                            List<DocumentSnapshot<Object?>>? doacoes =
                                querySnapshot?.docs
                                    .cast<DocumentSnapshot<Object?>>()
                                    .toList();
                            DocumentSnapshot documentSnapshot =
                                doacoes![indice];
                            Donation donation =
                                Donation.fromDocumentSnapshot(documentSnapshot);

                            return ItemDoacao(
                              donation: donation,
                              onTapItem: () {},
                            );
                          }),
                    );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/newDonation");
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.pets, size: 40),
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
              color: Colors.grey,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/my");
              },
              iconSize: 40,
            ),
            IconButton(
              icon: const Icon(Icons.volunteer_activism),
              color: Colors.green,
              onPressed: () {},
              iconSize: 40,
            ),
          ],
        ),
      ),
    );
  }
}
