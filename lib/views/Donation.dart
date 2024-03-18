import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  late StreamController<QuerySnapshot> _controller;
  String _categoriaSelecionada = "null";
  Color _corSelecionado = Colors.white;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<QuerySnapshot>.broadcast();
    _adicionarListenerDoacao();
    _startTime = DateTime.now();
    FirebaseAnalytics.instance.setUserProperty(name: "testing", value: "test");
  }

  @override
  void dispose() {
    DateTime endTime = DateTime.now();
    Duration stayTime = endTime.difference(_startTime);
    FirebaseAnalytics.instance.setUserProperty(
        name: 'stay_time', value: stayTime.inSeconds.toString());
    _controller.close();
    super.dispose();
  }

  void _adicionarListenerDoacao() {
    FirebaseFirestore.instance.collection("doacoes").snapshots().listen((event) {
      _controller.add(event);
    });
  }

  void _filtrarDoacoes(String categoria) {
    setState(() {
      _categoriaSelecionada = categoria;
    });
    Query query = FirebaseFirestore.instance.collection("doacoes");
    if (categoria != "null") {
      query = query.where("categoria", isEqualTo: categoria);
    }
    query.snapshots().listen((event) {
      _controller.add(event);
    });
  }

  void _selectedMenuItem(String item) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Doações",
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.green,
            ),
            onSelected: _selectedMenuItem,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Sair',
                  child: Text('Sair'),
                ),
              ];
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _filtrarDoacoes("Alimentos"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: _categoriaSelecionada == "Alimentos"
                          ? Colors.green[200]
                          : Colors.white, elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                    onPressed: () => _filtrarDoacoes("Acessórios"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _categoriaSelecionada == "Acessórios"
                          ? Colors.green[200]
                          : Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                    onPressed: () => _filtrarDoacoes("Brinquedos"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _categoriaSelecionada == "Brinquedos"
                          ? Colors.green[200]
                          : Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                    onPressed: () => _filtrarDoacoes("Medicamentos"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _categoriaSelecionada == "Medicamentos"
                          ? Colors.green[200]
                          : Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return const Text("Erro ao carregar os dados!");
                    }
                    QuerySnapshot? querySnapshot = snapshot.data as QuerySnapshot?;
                    if (querySnapshot!.docs.isEmpty) {
                      return Center(
                        child: Container(
                          width: 300,
                          height: 500,
                          alignment: Alignment.center,
                          child: const Text(
                            "Nenhuma doação para essa categoria ainda...",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, indice) {
                          List<DocumentSnapshot> doacoes =
                          querySnapshot.docs.cast<DocumentSnapshot>();
                          Donation donation = Donation.fromDocumentSnapshot(doacoes[indice]);
                          return ItemDoacao(
                            donation: donation,
                            onTapItem: () {},
                          );
                        },
                      ),
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
        child: const Icon(Icons.pets, color: Colors.white, size: 40),
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
