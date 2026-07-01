// Page to set the language mode.
import 'package:flutter/material.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/game_storage.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/types.dart';

class LanguagePage extends StatefulWidget {
  final ShapeTheoryGame game;
  static const String id = 'language';
  const LanguagePage({super.key, required this.game});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LANGUAGE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            _languageButton(Language.english),
            SizedBox(height: 20),
            _languageButton(Language.spanish),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D92F5),
                foregroundColor: Colors.white,
                minimumSize: const Size(230, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                widget.game.overlays.remove('language');
                widget.game.overlays.add('mainMenu');
              },
              child: Text('Back to Menu', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageButton(Language language) {
    bool isSelected = Configuration.currentLanguage == language;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Color.fromARGB(255, 203, 197, 244)
            : Color(0xFF9D92F5),
        foregroundColor: Colors.white,
        minimumSize: Size(230, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        Configuration.currentLanguage = language;
        GameStorage.saveLanguage(language);
        setState(() {});
      },
      child: Text(language.name.toUpperCase(), style: TextStyle(fontSize: 25)),
    );
  }
}

