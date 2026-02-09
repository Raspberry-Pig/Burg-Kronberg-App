import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'end_screen.dart';

class TourScreen extends StatefulWidget {
  final String language; // 'en', 'es', 'fr', 'ru', 'ukr', 'jp', 'zh'

  const TourScreen({super.key, required this.language});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  final AudioPlayer _player = AudioPlayer();
  int currentRoom = 0;
  late String currentLanguage;

  // Räume: Hintergrundbilder
  final List<String> roomImages = [
    'assets/images/room1.jpg',
    'assets/images/room2.jpg',
    'assets/images/room3.jpg',
  ];

  // Audios pro Raum und Sprache
  final Map<int, Map<String, String>> roomAudios = {
    0: {
      'en': 'assets/audio/en_room1.mp3',
      'es': 'assets/audio/es_room1.mp3',
      'fr': 'assets/audio/fr_room1.mp3',
      'ru': 'assets/audio/ru_room1.mp3',
      'ukr': 'assets/audio/ukr_room1.mp3',
      'jp': 'assets/audio/jp_room1.mp3',
      'zh': 'assets/audio/zh_room1.mp3',
    },
    1: {
      'en': 'assets/audio/en_room2.mp3',
      'es': 'assets/audio/es_room2.mp3',
      'fr': 'assets/audio/fr_room2.mp3',
      'ru': 'assets/audio/ru_room2.mp3',
      'ukr': 'assets/audio/ukr_room2.mp3',
      'jp': 'assets/audio/jp_room2.mp3',
      'zh': 'assets/audio/zh_room2.mp3',
    },
    2: {
      'en': 'assets/audio/en_room3.mp3',
      'es': 'assets/audio/es_room3.mp3',
      'fr': 'assets/audio/fr_room3.mp3',
      'ru': 'assets/audio/ru_room3.mp3',
      'ukr': 'assets/audio/ukr_room3.mp3',
      'jp': 'assets/audio/jp_room3.mp3',
      'zh': 'assets/audio/zh_room3.mp3',
    },
  };

  // Überschriften pro Raum und Sprache
  final Map<int, Map<String, String>> roomTitles = {
    0: {
      'en': 'Entrance Hall',
      'es': 'Sala de Entrada',
      'fr': 'Hall d\'Entrée',
      'ru': 'Входной зал',
      'ukr': 'Вхідна зала',
      'jp': '入口ホール',
      'zh': '入口大厅',
    },
    1: {
      'en': 'Great Hall',
      'es': 'Gran Salón',
      'fr': 'Grande Salle',
      'ru': 'Большой зал',
      'ukr': 'Великий зал',
      'jp': '大広間',
      'zh': '大礼堂',
    },
    2: {
      'en': 'Tower Room',
      'es': 'Sala de la Torre',
      'fr': 'Salle de la Tour',
      'ru': 'Башенная комната',
      'ukr': 'Баштова кімната',
      'jp': '塔の部屋',
      'zh': '塔楼房间',
    },
  };

  // Buttons pro Sprache
  final Map<String, Map<String, String>> buttonTexts = {
    'previous': {
      'en': 'Previous Room',
      'es': 'Sala Anterior',
      'fr': 'Salle Précédente',
      'ru': 'Предыдущая комната',
      'ukr': 'Попередня кімната',
      'jp': '前の部屋',
      'zh': '上一间',
    },
    'next': {
      'en': 'Next Room',
      'es': 'Siguiente Sala',
      'fr': 'Salle Suivante',
      'ru': 'Следующая комната',
      'ukr': 'Наступна кімната',
      'jp': '次の部屋',
      'zh': '下一间',
    },
  };

  // Menütexte pro Sprache
  final Map<String, Map<String, String>> menuTexts = {
    'menu': {
      'en': 'Menu',
      'es': 'Menú',
      'fr': 'Menu',
      'ru': 'Меню',
      'ukr': 'Меню',
      'jp': 'メニュー',
      'zh': '菜单',
    },
    'rooms': {
      'en': 'Rooms',
      'es': 'Salas',
      'fr': 'Salles',
      'ru': 'Залы',
      'ukr': 'Зали',
      'jp': '部屋',
      'zh': '房间',
    },
    'language': {
      'en': 'Language',
      'es': 'Idioma',
      'fr': 'Langue',
      'ru': 'Язык',
      'ukr': 'Мова',
      'jp': '言語',
      'zh': '语言',
    },
  };

  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    currentLanguage = widget.language;
    _loadAudio();

    _player.positionStream.listen((pos) {
      setState(() {
        currentPosition = pos;
      });
    });
    _player.durationStream.listen((dur) {
      setState(() {
        totalDuration = dur ?? Duration.zero;
      });
    });
  }

  Future<void> _loadAudio() async {
    final path = roomAudios[currentRoom]?[currentLanguage];
    if (path != null) {
      await _player.setAsset(path);
      await _player.seek(Duration.zero);
      setState(() {
        currentPosition = Duration.zero;
        totalDuration = _player.duration ?? Duration.zero;
        isPlaying = false;
      });
    }
  }

  Future<void> _selectRoom(int roomIndex) async {
    if (roomIndex == currentRoom) return;
    setState(() {
      currentRoom = roomIndex;
    });
    await _player.stop();
    await _loadAudio();
  }

  Future<void> _selectLanguage(String languageCode) async {
    if (languageCode == currentLanguage) return;
    setState(() {
      currentLanguage = languageCode;
    });
    await _player.stop();
    await _loadAudio();
  }

  Future<void> _nextRoom() async {
    if (currentRoom < roomImages.length - 1) {
      setState(() {
        currentRoom++;
      });
      await _player.stop();
      await _loadAudio();
    } else {
      await _player.stop();
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EndScreen(language: currentLanguage),
        ),
      );
    }
  }

  Future<void> _previousRoom() async {
    if (currentRoom > 0) {
      setState(() {
        currentRoom--;
      });
      await _player.stop();
      await _loadAudio();
    }
  }

  void _togglePlayPause() {
    if (_player.playing) {
      _player.pause();
      setState(() => isPlaying = false);
    } else {
      _player.play();
      setState(() => isPlaying = true);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = roomTitles[currentRoom]?[currentLanguage] ?? '';
    final prevText = buttonTexts['previous']?[currentLanguage] ?? '';
    final nextText = buttonTexts['next']?[currentLanguage] ?? '';
    final menuTitle = menuTexts['menu']?[currentLanguage] ?? 'Menu';
    final roomsTitle = menuTexts['rooms']?[currentLanguage] ?? 'Rooms';
    final languageTitle =
        menuTexts['language']?[currentLanguage] ?? 'Language';
    final languages = const <Map<String, String>>[
      {'name': 'English', 'code': 'en'},
      {'name': 'Español', 'code': 'es'},
      {'name': 'Français', 'code': 'fr'},
      {'name': 'Русский', 'code': 'ru'},
      {'name': 'Українська', 'code': 'ukr'},
      {'name': '日本語', 'code': 'jp'},
      {'name': '中文', 'code': 'zh'},
    ];

    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              ListTile(
                title: Text(
                  menuTitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 16),
              ListTile(
                title: Text(
                  roomsTitle,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              for (var i = 0; i < roomImages.length; i++)
                ListTile(
                  title:
                      Text(roomTitles[i]?[currentLanguage] ?? 'Room ${i + 1}'),
                  trailing:
                      i == currentRoom ? const Icon(Icons.check) : null,
                  onTap: () async {
                    Navigator.pop(context);
                    await _selectRoom(i);
                  },
                ),
              const Divider(height: 16),
              ExpansionTile(
                title: Text(
                  languageTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  for (final lang in languages)
                    ListTile(
                      title: Text(lang['name']!),
                      trailing: currentLanguage == lang['code']
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () async {
                        Navigator.pop(context);
                        await _selectLanguage(lang['code']!);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(roomImages[currentRoom], fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Überschrift
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Slider
              Slider(
                value: currentPosition.inMilliseconds.toDouble(),
                max: totalDuration.inMilliseconds.toDouble() > 0
                    ? totalDuration.inMilliseconds.toDouble()
                    : 1,
                onChanged: (value) {
                  _player.seek(Duration(milliseconds: value.toInt()));
                },
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
              ),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _previousRoom,
                    child: Text(prevText),
                  ),
                  IconButton(
                    iconSize: 64,
                    color: Colors.white,
                    onPressed: _togglePlayPause,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                    ),
                  ),
                  ElevatedButton(onPressed: _nextRoom, child: Text(nextText)),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
