import 'package:flutter/material.dart';
import 'package:son/pdf/pdf.dart';

import 'modules/loginPage.dart';
//import 'models/pdf.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginForm(),
    );
  }
}