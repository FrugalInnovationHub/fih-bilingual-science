// Configuration of the game.
import 'package:supersetfirebase/gamescreen/shapetheory/game/types.dart';

class Configuration {
  static const backgroundSpeed = 120.0;
  static const groundHeight = 260.0;

  static Difficulty currentDifficulty = Difficulty.easy;
  static bool soundEnabled = true;

  static Language currentLanguage = Language.english;

  // Game button settings
  static const buttonWidth = 150.0;
  static const spacing = 100.0;
  static const totalWidth = buttonWidth * 3 + spacing * 2;
}

