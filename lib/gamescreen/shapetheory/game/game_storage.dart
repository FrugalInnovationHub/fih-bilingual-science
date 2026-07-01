import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:supersetfirebase/gamescreen/shapetheory/game/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class is used to store settings and scores in the user machine.
class GameStorage {
  static Future<void> saveDifficulty(Difficulty level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_difficulty', level.name);
  }

  static Future<Difficulty> loadDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString('user_difficulty');

    return Difficulty.values.firstWhere(
      (e) => e.name == name,
      orElse: () => Difficulty.easy,
    );
  }

  static const String _scoreKey = 'high_scores_v2';

  static Future<void> saveScore(int newScore) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentList = prefs.getStringList(_scoreKey) ?? [];

    List<Map<String, dynamic>> decodedList = currentList.map((item) {
      return jsonDecode(item) as Map<String, dynamic>;
    }).toList();

    String formattedDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
    Map<String, dynamic> newEntry = {'score': newScore, 'date': formattedDate};

    decodedList.add(newEntry);
    decodedList.sort((a, b) => b['score'].compareTo(a['score']));

    if (decodedList.length > 10) {
      decodedList = decodedList.sublist(0, 10);
    }

    List<String> finalList = decodedList.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_scoreKey, finalList);
  }

  static Future<List<Map<String, dynamic>>> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList(_scoreKey) ?? [];

    List<Map<String, dynamic>> decodedList = savedList.map((item) {
      return jsonDecode(item) as Map<String, dynamic>;
    }).toList();

    decodedList.sort((a, b) => b['score'].compareTo(a['score']));

    return decodedList;
  }

  static Future<void> saveSoundPreference(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', isEnabled);
  }

  static Future<bool> loadSoundPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('sound_enabled') ?? true;
  }

  static Future<void> saveLanguage(Language language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_language', language.name);
  }

  static Future<Language> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString('user_language');

    return Language.values.firstWhere(
      (e) => e.name == name,
      orElse: () => Language.english,
    );
  }
}

