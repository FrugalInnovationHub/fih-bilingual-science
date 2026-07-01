import 'package:flutter/material.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/components/shape.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/components/shape.dart';

// Game over page. Once the game over, display the score and buttons to restart the game or back to main menu.
class GameOverPage extends StatelessWidget {
  final ShapeTheoryGame game;
  static const String id = 'gameOver';
  const GameOverPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: onRestart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D92F5),
                foregroundColor: Colors.white,
                minimumSize: const Size(230, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Restart', style: TextStyle(fontSize: 30)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D92F5),
                foregroundColor: Colors.white,
                minimumSize: const Size(230, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: backToMain,
              child: Text('Back to Menu', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }

  void onRestart() {
    if (Configuration.soundEnabled) {
      game.startBgm();
    }
    game.dino.reset();
    game.children.query<Shape>().forEach((p) => p.removeFromParent());
    game.buttonContainer?.removeFromParent();
    game.interval.stop(); // Stop the current ticking
    game.interval.reset(); // Put it back to 0:00
    game.interval.start();
    game.overlays.remove('gameOver');
    game.resumeEngine();
  }

  void backToMain() {
    if (Configuration.soundEnabled) {
      game.startBgm();
    }
    game.isPlaying = false;
    game.children.query<Shape>().forEach((p) => p.removeFromParent());
    game.buttonContainer?.removeFromParent();
    game.dino.removeFromParent();
    game.ground.removeFromParent();
    game.score.removeFromParent();
    game.overlays.remove('gameOver');
    game.overlays.add('mainMenu');
    game.resumeEngine();
  }
}

