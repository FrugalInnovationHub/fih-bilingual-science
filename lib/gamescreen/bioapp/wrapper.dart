import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'pages/Home.dart';
import 'pages/lesson.dart';
import 'pages/mcq.dart';
import 'pages/face_lesson.dart';
import 'pages/word_scramble_game.dart';
import 'pages/memory_game.dart';
import 'pages/FaceQuizGame.dart';
import 'pages/BodyPartsConnections.dart';
import 'pages/search.dart';
import 'pages/DragDrop.dart';
import 'pages/BodyPartsButtonGame.dart';
import 'pages/LearningPage.dart';
import 'pages/FaceLearningPage.dart';

class BioAppWrapper extends StatefulWidget {
  final String userPin;

  const BioAppWrapper({super.key, required this.userPin});

  @override
  State<BioAppWrapper> createState() => _BioAppWrapperState();
}

class _BioAppWrapperState extends State<BioAppWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize Gemini with API Key (empty for now, can be configured later)
    try {
      Gemini.init(
        apiKey: " ", // Add your Gemini API key here if needed
      );
    } catch (e) {
      // Gemini might already be initialized
      debugPrint('Gemini initialization: $e');
    }

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Return the BioApp wrapped in a MaterialApp to provide its own navigation context
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        fontFamily: 'LuckiestGuy',
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
        dividerTheme: const DividerThemeData(thickness: 1),
        chipTheme: const ChipThemeData(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.all(8),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0),
          bodyLarge: TextStyle(fontSize: 18.0),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/question': (context) => const Mcq(),
        '/lesson': (context) => const Lesson(),
        '/facelesson': (context) => const FaceLesson(),
        '/memorygame': (context) => const MemoryGame(),
        '/dragdrop': (context) => const DragDrop(),
        "/wordscramble": (context) => const WordScrambleGameV2(),
        "/facequizgame": (context) => const FaceQuizGame(),
        "/bodypartsconnections": (context) => const BodyPartsConnections(),
        "/bodyassembly": (context) => const BodyPartsButtonGame(),
        "/learningpage": (context) => const LearningPage(),
        "/facelearningpage": (context) => const Facelearningpage(),
        '/search': (context) => const SearchPage(),
      },
      onGenerateRoute: (settings) {
        final String? name = settings.name;
        if (name == null) {
          return null;
        }
        final Uri uri = Uri.parse(name);

        // Deep link: /search?q=face
        if (uri.path == '/search') {
          final String initialQuery = uri.queryParameters['q'] ?? '';
          final String initialType = uri.queryParameters['type'] ?? 'all';
          return MaterialPageRoute(
            builder: (_) => SearchPage(
                initialQuery: initialQuery, initialType: initialType),
            settings: settings,
          );
        }

        // Deep link: /open/<route>
        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'open') {
          final String target = '/${uri.pathSegments[1]}';
          return MaterialPageRoute(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(target);
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
            settings: settings,
          );
        }

        return null;
      },
    );
  }
}


