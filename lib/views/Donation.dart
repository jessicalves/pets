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
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _categoriaSelecionada = "null";
  String _antigaCategoria = "null";
  Color _corSelecionado1 = Colors.white;
  Color _corSelecionado2 = Colors.white;
  Color _corSelecionado3 = Colors.white;
  Color _corSelecionado4 = Colors.white;
  late DateTime _startTime;

  _adicionarListenerDoacao() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("doacoes").snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  _filtarDoacaoes() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("doacoes");
    if (_categoriaSelecionada != "null") {
      query = query.where("categoria", isEqualTo: _categoriaSelecionada);
    }
    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Donation Screen");
  }

  _selectedMenuItem(String item) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = const Center(
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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.green, // define a cor do ícone
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
                  const SizedBox(width: 2),
                  ElevatedButton(
                    onPressed: () {
                      _antigaCategoria = _categoriaSelecionada;
                      _categoriaSelecionada = "Alimentos";
                      FirebaseAnalytics.instance.logEvent(
                        name: 'select_category',
                        parameters: <String, dynamic>{
                          'category': 'Alimentos',
                          'int_parameter': 01,
                        },
                      );
                      setState(() {
                        _corSelecionado1 = Colors.green[200]!;
                        _corSelecionado2 = Colors.white;
                        _corSelecionado3 = Colors.white;
                        _corSelecionado4 = Colors.white;
                      });
                      if (_categoriaSelecionada == _antigaCategoria) {
                        _categoriaSelecionada = "null";
                        setState(() {
                          _corSelecionado1 = Colors.white;
                        });
                      }
                      _filtarDoacaoes();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(_corSelecionado1),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Row(
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
                    onPressed: () {
                      _antigaCategoria = _categoriaSelecionada;
                      _categoriaSelecionada = "Acessórios";
                      FirebaseAnalytics.instance.logEvent(
                        name: 'select_category',
                        parameters: <String, dynamic>{
                          'category': 'Acessórios',
                          'int_parameter': 02,
                        },
                      );
                      setState(() {
                        _corSelecionado2 = Colors.green[200]!;
                        _corSelecionado1 = Colors.white;
                        _corSelecionado3 = Colors.white;
                        _corSelecionado4 = Colors.white;
                      });
                      if (_categoriaSelecionada == _antigaCategoria) {
                        _categoriaSelecionada = "null";
                        setState(() {
                          _corSelecionado2 = Colors.white;
                        });
                      }
                      _filtarDoacaoes();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(_corSelecionado2),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Row(
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
                    onPressed: () {
                      _antigaCategoria = _categoriaSelecionada;
                      _categoriaSelecionada = "Brinquedos";
                      FirebaseAnalytics.instance.logEvent(
                        name: 'select_category',
                        parameters: <String, dynamic>{
                          'category': 'Brinquedos',
                          'int_parameter': 03,
                        },
                      );
                      setState(() {
                        _corSelecionado3 = Colors.green[200]!;
                        _corSelecionado1 = Colors.white;
                        _corSelecionado2 = Colors.white;
                        _corSelecionado4 = Colors.white;
                      });
                      if (_categoriaSelecionada == _antigaCategoria) {
                        _categoriaSelecionada = "null";
                        setState(() {
                          _corSelecionado3 = Colors.white;
                        });
                      }
                      _filtarDoacaoes();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(_corSelecionado3),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Row(
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
                    onPressed: () {
                      _antigaCategoria = _categoriaSelecionada;
                      _categoriaSelecionada = "Medicamentos";
                      FirebaseAnalytics.instance.logEvent(
                        name: 'select_category',
                        parameters: <String, dynamic>{
                          'category': 'Medicamentos',
                          'int_parameter': 03,
                        },
                      );
                      setState(() {
                        _corSelecionado4 = Colors.green[200]!;
                        _corSelecionado1 = Colors.white;
                        _corSelecionado2 = Colors.white;
                        _corSelecionado3 = Colors.white;
                      });
                      if (_categoriaSelecionada == _antigaCategoria) {
                        _categoriaSelecionada = "null";
                        setState(() {
                          _corSelecionado4 = Colors.white;
                        });
                      }
                      _filtarDoacaoes();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(_corSelecionado4),
                      elevation: MaterialStateProperty.all<double>(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Row(
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
                    if (snapshot.hasError) {
                      return const Text("Erro ao carregar os dados!");
                    }

                    QuerySnapshot? querySnapshot = snapshot.data;

                    if (querySnapshot!.docs.isEmpty) {
                      return Center(
                        child: Container(
                          width: 300,
                          height: 500,
                          alignment: Alignment.center,
                          child: const Text(
                            "Nenhuma doação para essa categorina ainda...",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 400,
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
