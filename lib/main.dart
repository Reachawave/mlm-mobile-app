import 'package:flutter/material.dart';
import 'package:new_project/adminpages/DashboardPage.dart';
import 'package:new_project/adminpages/LoginPage.dart';

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
