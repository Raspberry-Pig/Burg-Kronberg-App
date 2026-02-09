// lib/screens/language_screen.dart
import 'package:flutter/material.dart';
import 'tour_screen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  final List<Map<String, String>> languages = const [
    {'name': 'English', 'code': 'EN', 'flag': 'assets/flags/en.png'},
    {'name': 'Español', 'code': 'ES', 'flag': 'assets/flags/es.png'},
    {'name': 'Français', 'code': 'FR', 'flag': 'assets/flags/fr.png'},
    {'name': 'Русский', 'code': 'RU', 'flag': 'assets/flags/ru.png'},
    {'name': 'Українська', 'code': 'UKR', 'flag': 'assets/flags/ukr.png'},
    {'name': '日本語', 'code': 'JP', 'flag': 'assets/flags/jp.png'},
    {'name': '中文', 'code': 'ZH', 'flag': 'assets/flags/zh.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Hintergrundbild
          Image.asset(
            'assets/images/burg_background.jpg', // hier dein Hintergrundbild
            fit: BoxFit.cover,
          ),
          // Overlay für bessere Lesbarkeit
          Container(color: Colors.black.withOpacity(0.4)),
          // Buttons in der Mitte
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: languages.map((lang) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 24,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TourScreen(
                              language: lang['code']!.toLowerCase(),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(lang['flag']!, width: 40, height: 40),
                          const SizedBox(width: 12),
                          Text(
                            lang['name']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
