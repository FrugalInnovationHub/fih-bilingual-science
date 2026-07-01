import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/pages/difficulty_page.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/pages/game_over_page.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/pages/high_score_page.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/pages/main_menu_page.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/pages/language_page.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/pages/sound_page.dart';

class ShapeTheoryWrapper extends StatefulWidget {
  final String userPin;

  const ShapeTheoryWrapper({super.key, required this.userPin});

  @override
  State<ShapeTheoryWrapper> createState() => _ShapeTheoryWrapperState();
}

class _ShapeTheoryWrapperState extends State<ShapeTheoryWrapper> {
  late final ShapeTheoryGame _game;

  @override
  void initState() {
    super.initState();
    _game = ShapeTheoryGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget(
        game: _game,
        initialActiveOverlays: const [MainMenuPage.id],
        overlayBuilderMap: {
          'mainMenu': (context, _) => MainMenuPage(game: _game),
          'gameOver': (context, _) => GameOverPage(game: _game),
          'difficulty': (context, _) => DifficultyPage(game: _game),
          'highScore': (context, _) => HighScorePage(game: _game),
          'sound': (context, _) => SoundPage(game: _game),
          'language': (context, _) => LanguagePage(game: _game),
        },
      ),
    );
  }
}
