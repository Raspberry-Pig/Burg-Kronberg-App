import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'end_screen.dart';

class TourScreen extends StatefulWidget {
  final String language; // 'en', 'es', 'fr', 'ko', 'ukr', 'zh'

  const TourScreen({super.key, required this.language});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class RoomStop {
  final String id;
  final String code;
  final Map<String, String> titles;

  const RoomStop({required this.id, required this.code, required this.titles});
}

class _TourScreenState extends State<TourScreen> {
  final AudioPlayer _player = AudioPlayer();
  static const List<String> _audioLanguages = [
    'en',
    'es',
    'fr',
    'ko',
    'ukr',
    'zh',
  ];
  int currentRoom = 0;
  late String currentLanguage;

  final List<RoomStop> rooms = const [
    RoomStop(
      id: 'room1',
      code: '1',
      titles: {
        'de': 'Einführung',
        'en': 'Introduction',
        'es': 'Introducción',
        'fr': 'Introduction',
        'ko': '소개',
        'ukr': 'Вступ',
        'zh': '导言',
      },
    ),
    RoomStop(
      id: 'room1a',
      code: '1a',
      titles: {
        'de': 'Die Geschichte der Burg Kronberg',
        'en': 'The History of Kronberg Castle',
        'es': 'La historia del Castillo de Kronberg',
        'fr': 'L\'histoire du château de Kronberg',
        'ko': '크론베르크 성의 역사',
        'ukr': 'Історія замку Кронберг',
        'zh': '克龙贝格城堡的历史',
      },
    ),
    RoomStop(
      id: 'room2',
      code: '3',
      titles: {
        'de': 'Kaiserzimmer',
        'en': 'Emperor\'s Room',
        'es': 'Sala del Emperador',
        'fr': 'Chambre de l\'Empereur',
        'ko': '황제의 방',
        'ukr': 'Кімната імператора',
        'zh': '皇帝房间',
      },
    ),
    RoomStop(
      id: 'room3',
      code: '4',
      titles: {
        'de': 'Flur',
        'en': 'Corridor',
        'es': 'Pasillo',
        'fr': 'Couloir',
        'ko': '복도',
        'ukr': 'Коридор',
        'zh': '走廊',
      },
    ),
    RoomStop(
      id: 'room4',
      code: '5',
      titles: {
        'de': 'Wappensaal',
        'en': 'Coat of Arms Hall',
        'es': 'Sala de Escudos',
        'fr': 'Salle des Armoiries',
        'ko': '문장 홀',
        'ukr': 'Зала гербів',
        'zh': '纹章大厅',
      },
    ),
    RoomStop(
      id: 'room5',
      code: '6',
      titles: {
        'de': 'Wehrgang',
        'en': 'Battlement Walk',
        'es': 'Camino de Ronda',
        'fr': 'Chemin de ronde',
        'ko': '성벽 통로',
        'ukr': 'Бойовий хід',
        'zh': '城墙步道',
      },
    ),
    RoomStop(
      id: 'room6',
      code: '7a',
      titles: {
        'de': 'Ritterzimmer - Hartmut',
        'en': 'Knights\' Room - Hartmut',
        'es': 'Sala de los Caballeros - Hartmut',
        'fr': 'Salle des Chevaliers - Hartmut',
        'ko': '기사의 방 - 하르트무트',
        'ukr': 'Лицарська кімната - Гартмут',
        'zh': '骑士房间 - 哈特穆特',
      },
    ),
    RoomStop(
      id: 'room6a',
      code: '7b',
      titles: {
        'de': 'Ritterzimmer - Schlachtengemälde',
        'en': 'Knights\' Room - Battle Painting',
        'es': 'Sala de los Caballeros - Pintura de Batalla',
        'fr': 'Salle des Chevaliers - Tableau de bataille',
        'ko': '기사의 방 - 전투 그림',
        'ukr': 'Лицарська кімната - Батальна картина',
        'zh': '骑士房间 - 战争画',
      },
    ),
    RoomStop(
      id: 'room7',
      code: '8',
      titles: {
        'de': 'Herrenzimmer',
        'en': 'Gentlemen\'s Room',
        'es': 'Sala de los Senores',
        'fr': 'Salle des Seigneurs',
        'ko': '신사실',
        'ukr': 'Чоловіча кімната',
        'zh': '男士房间',
      },
    ),
    RoomStop(
      id: 'room8',
      code: '9a',
      titles: {
        'de': 'Damenzimmer - Die Truhe',
        'en': 'Ladies\' Room - The Chest',
        'es': 'Sala de las Damas (1) - Arcon',
        'fr': 'Chambre des Dames (1) - Coffre',
        'ko': '여성의 방 (1) - 궤',
        'ukr': 'Жіноча кімната (1) - Скриня',
        'zh': '女士房间 (1) - 箱柜',
      },
    ),
    RoomStop(
      id: 'room8a',
      code: '9b',
      titles: {
        'de': 'Damenzimmer - Disch',
        'en': 'Ladies\' Room - Disch',
        'es': 'Sala de las Damas - Disch',
        'fr': 'Chambre des Dames - Disch',
        'ko': '여성의 방 - Disch',
        'ukr': 'Жіноча кімната - Disch',
        'zh': '女士房间 - Disch',
      },
    ),
    RoomStop(
      id: 'room8b',
      code: '9c',
      titles: {
        'de': 'Damenzimmer - Tränenbecher',
        'en': 'Ladies\' Room - Tear Goblet',
        'es': 'Sala de las Damas (3) - Copa de Lagrimas',
        'fr': 'Chambre des Dames (3) - Coupe des larmes',
        'ko': '여성의 방 (3) - 눈물의 잔',
        'ukr': 'Жіноча кімната (3) - Чаша сліз',
        'zh': '女士房间 (3) - 泪之杯',
      },
    ),
    RoomStop(
      id: 'room9',
      code: '10',
      titles: {
        'de': 'Kuche',
        'en': 'Kitchen',
        'es': 'Cocina',
        'fr': 'Cuisine',
        'ko': '주방',
        'ukr': 'Кухня',
        'zh': '厨房',
      },
    ),
    RoomStop(
      id: 'room10',
      code: '11',
      titles: {
        'de': 'Speisekammer',
        'en': 'Pantry',
        'es': 'Despensa',
        'fr': 'Garde-manger',
        'ko': '식료품 저장실',
        'ukr': 'Комора',
        'zh': '食品储藏室',
      },
    ),
  ];

  // Buttons pro Sprache
  final Map<String, Map<String, String>> buttonTexts = {
    'previous': {
      'en': 'Previous Room',
      'es': 'Sala Anterior',
      'fr': 'Salle Precedente',
      'ko': '이전 방',
      'ukr': 'Попередня кімната',
      'zh': '上一间',
    },
    'next': {
      'en': 'Next Room',
      'es': 'Siguiente Sala',
      'fr': 'Salle Suivante',
      'ko': '다음 방',
      'ukr': 'Наступна кімната',
      'zh': '下一间',
    },
  };

  // Menütexte pro Sprache
  final Map<String, Map<String, String>> menuTexts = {
    'menu': {
      'en': 'Menu',
      'es': 'Menu',
      'fr': 'Menu',
      'ko': '메뉴',
      'ukr': 'Меню',
      'zh': '菜单',
    },
    'rooms': {
      'en': 'Rooms',
      'es': 'Salas',
      'fr': 'Salles',
      'ko': '방',
      'ukr': 'Зали',
      'zh': '房间',
    },
    'language': {
      'en': 'Language',
      'es': 'Idioma',
      'fr': 'Langue',
      'ko': '언어',
      'ukr': 'Мова',
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

  Future<String?> _audioPathForCurrentRoom() async {
    final roomId = rooms[currentRoom].id;
    final fallbackLanguages = _audioLanguages
        .where((lang) => lang != currentLanguage && lang != 'en')
        .toList();
    final candidates = <String>[
      'assets/audio/${roomId}_$currentLanguage.mp3',
      'assets/audio/${roomId}_en.mp3',
      for (final lang in fallbackLanguages) 'assets/audio/${roomId}_$lang.mp3',
    ];

    for (final path in candidates) {
      try {
        await rootBundle.load(path);
        return path;
      } catch (_) {
        // Try next candidate.
      }
    }
    return null;
  }

  String _imagePathForRoom(int index) {
    return 'assets/images/${rooms[index].id}.jpg';
  }

  String _roomTitle(int index) {
    final titles = rooms[index].titles;
    return titles[currentLanguage] ?? titles['de'] ?? 'Room ${index + 1}';
  }

  Future<void> _loadAudio() async {
    final path = await _audioPathForCurrentRoom();
    if (path == null) {
      await _player.stop();
      setState(() {
        currentPosition = Duration.zero;
        totalDuration = Duration.zero;
        isPlaying = false;
      });
      return;
    }

    await _player.setAsset(path);
    await _player.seek(Duration.zero);
    setState(() {
      currentPosition = Duration.zero;
      totalDuration = _player.duration ?? Duration.zero;
      isPlaying = false;
    });
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
    if (currentRoom < rooms.length - 1) {
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
    if (totalDuration == Duration.zero) return;
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
    final title = _roomTitle(currentRoom);
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
      {'name': '한국어', 'code': 'ko'},
      {'name': 'Українська', 'code': 'ukr'},
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 16),
              ListTile(
                title: Text(
                  roomsTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              for (var i = 0; i < rooms.length; i++)
                ListTile(
                  title: Text(_roomTitle(i)),
                  trailing: i == currentRoom ? const Icon(Icons.check) : null,
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
          Image.asset(
            _imagePathForRoom(currentRoom),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.black87,
              alignment: Alignment.center,
              child: const Text(
                'Bild fehlt',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
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
