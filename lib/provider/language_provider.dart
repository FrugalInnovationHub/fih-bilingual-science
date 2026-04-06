import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = 'en';
  static const String _languageKey = 'app_language';

  String get language => _language;
  bool get isSpanish => _language == 'es';

  // Translations map
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'BILINGUAL': 'BILINGUAL',
      'SCIENTISTS': 'SCIENTISTS',
      'Learning Made Fun': 'Learning Made Fun',
      'Enter Your Access Code': 'Enter Your Access Code',
      "Don't have a code? Create one": "Don't have a code? Create one",
      "Let's Play": "Let's Play",
      'Please enter your code': 'Please enter your code',
      'Oops! Wrong PIN. Try again!': 'Oops! Wrong PIN. Try again!',
      'Create Your Access Code': 'Create Your Access Code',
      'Name': 'Name',
      'Back to Login': 'Back to Login',
      "Sign Up!": "Sign Up!",
      'Oops! We need all 3 numbers for your secret code! 🎯':
          'Oops! We need all 3 numbers for your secret code! 🎯',
      'This secret code is already taken! Try another one! 🎲':
          'This secret code is already taken! Try another one! 🎲',
      'Hi': 'Hi',
      'Score': 'Score',
      'Exit': 'Exit',
    },
    'es': {
      'BILINGUAL': 'BILINGÜE',
      'SCIENTISTS': 'CIENTÍFICOS',
      'Learning Made Fun': 'Aprender es Divertido',
      'Enter Your Access Code': 'Ingresa Tu Código de Acceso',
      "Don't have a code? Create one": "¿No tienes un código? Crea uno",
      "Let's Play": "¡Juguemos",
      'Please enter your code': 'Por favor ingresa tu código',
      'Oops! Wrong PIN. Try again!':
          '¡Ups! PIN incorrecto. ¡Inténtalo de nuevo!',
      'Create Your Access Code': 'Crea Tu Código de Acceso',
      'Name': 'Nombre',
      'Back to Login': 'Volver al Inicio de Sesión',
      "Sign Up!": "¡Regístrate!",
      'Oops! We need all 3 numbers for your secret code! 🎯':
          '¡Ups! ¡Necesitamos los 3 números para tu código secreto! 🎯',
      'This secret code is already taken! Try another one! 🎲':
          '¡Este código secreto ya está en uso! ¡Prueba con otro! 🎲',
      'Hi': 'Hola',
      'Score': 'Puntuación',
      'Exit': 'Salir',
    },
  };

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      if (savedLanguage != null &&
          (savedLanguage == 'en' || savedLanguage == 'es')) {
        _language = savedLanguage;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  Future<void> setLanguage(String lang) async {
    if (lang != _language && (lang == 'en' || lang == 'es')) {
      _language = lang;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, lang);
      } catch (e) {
        debugPrint('Error saving language: $e');
      }
      notifyListeners();
    }
  }

  void toggleLanguage() {
    setLanguage(_language == 'en' ? 'es' : 'en');
  }

  String translate(String key) {
    return _translations[_language]?[key] ?? key;
  }
}
