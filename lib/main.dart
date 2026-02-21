import 'package:flutter/material.dart';
import 'screens/location_gate_screen.dart';
import 'screens/title_screen.dart';

void main() {
  runApp(const BurgApp());
}

class BurgApp extends StatelessWidget {
  const BurgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Burg Kronberg',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const LocationGateScreen(child: TitleScreen()),
    );
  }
}
