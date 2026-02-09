import 'package:flutter/material.dart';
import 'screens/title_screen.dart';

void main() {
  runApp(const BurgApp());
}

class BurgApp extends StatelessWidget {
  const BurgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Burg Kronberg Tour',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: TitleScreen(), // kein const, weil State/Animation
    );
  }
}
