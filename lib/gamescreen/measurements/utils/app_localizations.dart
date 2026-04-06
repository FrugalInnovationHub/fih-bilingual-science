import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en', ''));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('es', ''),
  ];

  bool get isEnglish => locale.languageCode == 'en';

  // Game UI Text
  String get gameTitle => isEnglish ? 'Measurement Adventure' : 'Aventura de Medidas';
  String get playButton => isEnglish ? 'Play Game' : 'Jugar';
  String get settingsButton => isEnglish ? 'Settings' : 'Configuración';
  String get languageButton => isEnglish ? 'Language' : 'Idioma';
  String get english => isEnglish ? 'English' : 'Inglés';
  String get spanish => isEnglish ? 'Spanish' : 'Español';
  
  // Game Instructions
  String get gameInstructions => isEnglish 
    ? 'Match the measurements! Drag the correct answer to the question.'
    : '¡Empareja las medidas! Arrastra la respuesta correcta a la pregunta.';
  
  String get correctAnswer => isEnglish ? 'Correct! 🎉' : '¡Correcto! 🎉';
  String get wrongAnswer => isEnglish ? 'Try again! 🤔' : '¡Inténtalo de nuevo! 🤔';
  String get nextQuestion => isEnglish ? 'Next Question' : 'Siguiente Pregunta';
  String get score => isEnglish ? 'Score' : 'Puntuación';
  String get level => isEnglish ? 'Level' : 'Nivel';
  
  // Conversion Questions
  String getConversionQuestion(String fromUnit, String toUnit, double value) {
    if (isEnglish) {
      return 'How many $toUnit are in ${value.toStringAsFixed(0)} $fromUnit?';
    } else {
      return '¿Cuántos $toUnit hay en ${value.toStringAsFixed(0)} $fromUnit?';
    }
  }
  
  String get equals => isEnglish ? '=' : '=';
  String get convert => isEnglish ? 'Convert' : 'Convertir';
  
  // Difficulty Levels
  String get easy => isEnglish ? 'Easy' : 'Fácil';
  String get medium => isEnglish ? 'Medium' : 'Medio';
  String get hard => isEnglish ? 'Hard' : 'Difícil';
  
  // Game Over
  String get gameOver => isEnglish ? 'Game Over!' : '¡Juego Terminado!';
  String get playAgain => isEnglish ? 'Play Again' : 'Jugar de Nuevo';
  String get finalScore => isEnglish ? 'Final Score' : 'Puntuación Final';
  
  // Settings
  String get soundEffects => isEnglish ? 'Sound Effects' : 'Efectos de Sonido';
  String get music => isEnglish ? 'Music' : 'Música';
  String get difficulty => isEnglish ? 'Difficulty' : 'Dificultad';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
