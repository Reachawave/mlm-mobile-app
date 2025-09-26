import 'package:flutter/material.dart';
import 'package:myprojects/adminpages/DashboardPage.dart';
import 'package:myprojects/adminpages/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'RedRose'),
      home: Loginpage(),
    );
  }
}
