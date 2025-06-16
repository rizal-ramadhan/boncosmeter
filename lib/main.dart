import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(BoncosMeterApp());
}

class BoncosMeterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoncosMeter',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
