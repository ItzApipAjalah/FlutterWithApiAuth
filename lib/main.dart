import 'package:flutter/material.dart';
import 'package:perpustakaanflutter/LoginPage.dart';
import 'package:perpustakaanflutter/RegisterPage.dart';
import 'package:perpustakaanflutter/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Ap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
