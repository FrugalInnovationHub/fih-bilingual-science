import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';

import 'screens/home_screen.dart';
import 'utils/measurement_data.dart';
import 'utils/app_localizations.dart';
import 'utils/level_data.dart';
import 'utils/translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TranslationService.initialize();
  LevelData.ensureInitialized();
  runApp(const MeasurementGameApp());
}

class MeasurementGameApp extends StatefulWidget {
  const MeasurementGameApp({super.key});

  @override
  State<MeasurementGameApp> createState() => _MeasurementGameAppState();
}

class _MeasurementGameAppState extends State<MeasurementGameApp> {
  Locale _locale = const Locale('en', '');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measurement Adventure',
      key: ValueKey(_locale.toString()), // Force rebuild when locale changes
      locale: _locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // fontFamily: 'KidsFont',
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
      home: HomeScreen(onLanguageChanged: changeLanguage),
    );
  }
}
