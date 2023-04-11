import 'package:flutter/material.dart';
import 'package:pets/views/Donation.dart';
import 'package:pets/views/Login.dart';
import 'package:pets/views/MyDonations.dart';
import 'package:pets/views/RegisterDonation.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;

    if (name == '/') {
      return MaterialPageRoute(builder: (context) => Login());
    } else if (name == '/my') {
      final args = settings.arguments;
      return MaterialPageRoute(builder: (context) => MyDonations());
    } else if (name == '/donation') {
      return MaterialPageRoute(builder: (context) => HomeDonation());
    } else if (name == '/newDonation') {
      return MaterialPageRoute(builder: (context) => NewDonation());
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
    });
  }
}
