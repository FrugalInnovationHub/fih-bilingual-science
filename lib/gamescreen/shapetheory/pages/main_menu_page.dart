import 'package:flutter/material.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/assets.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';

// Main Menu of the game. It has a button to start the game, and other buttons to different pages to set the difficulty, language, sound, and view the score history.
class MainMenuPage extends StatelessWidget {
  final ShapeTheoryGame game;
  static const String id = 'mainMenu';
  const MainMenuPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Transform.scale(
                    scale: 2.0,
                    child: Image.asset(
                      'assets/shapetheory/images/${Assets.icon}',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            Text(
              'DIFFICULTY',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              Configuration.currentDifficulty.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 30),
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
                game.overlays.remove('mainMenu');
                game.startGame();
              },
              child: Text('START GAME', style: TextStyle(fontSize: 25)),
            ),
            const SizedBox(height: 20),
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
                game.overlays.remove('mainMenu');
                game.overlays.add('difficulty');
              },
              child: Text('DIFFICULTY', style: TextStyle(fontSize: 25)),
            ),
            const SizedBox(height: 20),
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
                game.overlays.remove('mainMenu');
                game.overlays.add('highScore');
              },
              child: Text('HIGH SCORE', style: TextStyle(fontSize: 25)),
            ),
            const SizedBox(height: 20),
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
                game.overlays.remove('mainMenu');
                game.overlays.add('sound');
              },
              child: Text('SOUND', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    ],
  ),
);
  }
}

