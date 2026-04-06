import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'measurements/screens/home_screen.dart' as measurements;
import 'measurements/utils/app_localizations.dart';
import 'measurements/utils/level_data.dart';
import 'measurements/utils/translation_service.dart';

class MeasurementsWrapper extends StatefulWidget {
  final String userPin;

  const MeasurementsWrapper({super.key, required this.userPin});

  @override
  State<MeasurementsWrapper> createState() => _MeasurementsWrapperState();
}

class _MeasurementsWrapperState extends State<MeasurementsWrapper> {
  bool _isInitialized = false;
  Locale _locale = const Locale('en', '');

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await Future.any([
        _doInitialize(),
        Future.delayed(const Duration(seconds: 3), () {
          debugPrint('Measurements initialization timeout - loading game anyway');
        }),
      ]);
    } catch (e) {
      debugPrint('Measurements initialization error: $e - loading game anyway');
    }

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _doInitialize() async {
    try {
      await TranslationService.initialize();
      LevelData.ensureInitialized();
    } catch (e) {
      debugPrint('Measurements data initialization error: $e');
    }
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
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

    return MaterialApp(
      title: 'Measurement Adventure',
      key: ValueKey(_locale.toString()),
      locale: _locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      home: measurements.HomeScreen(onLanguageChanged: _changeLanguage),
    );
  }
}
