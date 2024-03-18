import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pets/views/Login.dart';
import 'package:pets/RouteGenerator.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch(e) {
    print("Failed to initialize Firebase: $e");
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: '',
    home: Login(),
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    navigatorObservers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
    ],
  ));
}
