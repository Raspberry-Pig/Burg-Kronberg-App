import 'dart:async';

import 'package:flutter/material.dart';

class EndScreen extends StatefulWidget {
  final String language; // 'en', 'es', 'fr', 'ru', 'ukr', 'jp', 'zh'

  const EndScreen({super.key, required this.language});

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  final List<String> _slideshowImages = const [
    'assets/images/end1.jpg',
    'assets/images/end2.jpg',
    'assets/images/end3.jpg',
    'assets/images/end4.jpg',
    'assets/images/end5.jpg',
    'assets/images/end6.jpg',
    'assets/images/end7.jpg',
    'assets/images/end8.jpg',
    'assets/images/end9.jpg',
  ];

  final Map<String, String> _thanksText = const {
    'en': 'Thank you for your visit!',
    'es': '¡Gracias por tu visita!',
    'fr': 'Merci pour votre visite !',
    'ru': 'Спасибо за визит!',
    'ukr': 'Дякуємо за візит!',
    'jp': 'ご訪問ありがとうございました！',
    'zh': '感谢您的参观！',
  };

  final Map<String, String> _backText = const {
    'en': 'Back to Tour',
    'es': 'Volver al recorrido',
    'fr': 'Retour à la visite',
    'ru': 'Назад к туру',
    'ukr': 'Назад до туру',
    'jp': 'ツアーに戻る',
    'zh': '返回导览',
  };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_slideshowImages.isEmpty) return;
      _currentPage = (_currentPage + 1) % _slideshowImages.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thanks = _thanksText[widget.language] ?? 'Thank you!';
    final back = _backText[widget.language] ?? 'Back';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slideshowImages.length,
            itemBuilder: (context, index) {
              return Image.asset(_slideshowImages[index], fit: BoxFit.cover);
            },
          ),
          Container(color: Colors.black.withOpacity(0.35)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    thanks,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(back),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
