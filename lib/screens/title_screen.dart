import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'language_screen.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>
    with TickerProviderStateMixin {
  static const Duration _slideDuration = Duration(seconds: 8);
  int currentIndex = 0;
  bool _didPrecache = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  late AnimationController _buttonController;
  late Animation<double> _buttonScale;
  late final double _zoomEndScale;

  final List<String> images = [
    'assets/images/en.jpg',
    'assets/images/es.jpg',
    'assets/images/fr.jpg',
    'assets/images/ko.jpg',
    'assets/images/ukr.jpg',
    'assets/images/zh.jpg',
  ];

  final List<String> texts = [
    'Start the Tour', // EN
    'Iniciar la Tour', // ES
    'Commencer la visite', // FR
    '투어 시작', // KO
    'Почати тур', // UKR
    '開始您的旅程', // ZH
  ];

  @override
  void initState() {
    super.initState();
    _zoomEndScale = defaultTargetPlatform == TargetPlatform.windows ? 1.01 : 1.04;
    // Fade für Hintergrund
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_fadeController);

    // Sanftes Zoom
    _zoomController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    );
    _zoomAnimation = Tween(begin: 1.0, end: _zoomEndScale).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.linear),
    );
    _zoomController.forward();

    // Button Puls
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _buttonScale = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(_buttonController);

    // Starte Slideshow
    _fadeController.forward();
    Future.delayed(_slideDuration, _nextSlide);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecache) return;
    for (final image in images) {
      precacheImage(AssetImage(image), context);
    }
    _didPrecache = true;
  }

  void _nextSlide() {
    if (!mounted) return;

    _fadeController.reverse().then((_) {
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
      });
      _fadeController.forward();
      _zoomController
        ..reset()
        ..forward();
      Future.delayed(_slideDuration, _nextSlide);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _zoomController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Hintergrundbild mit Fade + Zoom
          AnimatedBuilder(
            animation: _zoomAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _zoomAnimation.value,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    images[currentIndex],
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    filterQuality: FilterQuality.low,
                    isAntiAlias: false,
                  ),
                ),
              );
            },
          ),
          Container(color: Colors.black.withOpacity(0.3)),

          // Button unten mit Animation
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: ScaleTransition(
                scale: _buttonScale,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LanguageScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(texts[currentIndex], textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
          // Optional: Logo oben mittig (falls du willst)
          // Positioned(
          //   top: 50,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: Image.asset('assets/images/logo.png', height: 80),
          //   ),
          // ),
        ],
      ),
    );
  }
}
