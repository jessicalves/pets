import 'package:flutter/material.dart';
import 'package:pets/views/Donation.dart';
import 'package:pets/views/Login.dart';
import 'package:pets/views/RegisterDonation.dart';
import 'package:pets/views/MyDonation.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;

    if (name == '/') {
      return MaterialPageRoute(builder: (context) => Login(), settings: settings);
    } else if (name == '/my') {
      return MaterialPageRoute(builder: (context) => MinhasDoacoes(), settings: settings);
    } else if (name == '/donation') {
      return MaterialPageRoute(builder: (context) => HomeDonation(), settings: settings);
    } else if (name == '/newDonation') {
      return MaterialPageRoute(builder: (context) => NewDonation(), settings: settings);
    }

    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada"),
        ),
        body: const Center(
          child: Text("Tela não encontrada"),
        ),
      );
    }, settings: settings);
  }
}
