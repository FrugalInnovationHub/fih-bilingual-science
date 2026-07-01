// This class is for different enums in the game.
enum ShapeType { none, rectangle, triangle, circle, square, hexagon, diamond }

enum Difficulty { easy, medium, hard }

enum Language { english, spanish }

// Define 3 levels of difficulty, and an extension 'settings' for easy access.
extension DifficultyExtension on Difficulty {
  DifficultySettings get settings {
    switch (this) {
      case Difficulty.easy:
        return const DifficultySettings(
          speed: 360,
          jumpSpeed: -640,
          gravity: 690,
          shapeInterval: 4.0,
          scorePerObstacle: 5,
        );
      case Difficulty.medium:
        return const DifficultySettings(
          speed: 430,
          jumpSpeed: -690,
          gravity: 740,
          shapeInterval: 3.0,
          scorePerObstacle: 7,
        );
      case Difficulty.hard:
        return const DifficultySettings(
          speed: 500,
          jumpSpeed: -730,
          gravity: 880,
          shapeInterval: 2.0,
          scorePerObstacle: 10,
        );
    }
  }
}

// Structure of difficulty.
class DifficultySettings {
  final double speed;
  final double jumpSpeed;
  final double gravity;
  final double shapeInterval;
  final int scorePerObstacle;

  const DifficultySettings({
    required this.speed,
    required this.jumpSpeed,
    required this.gravity,
    required this.shapeInterval,
    required this.scorePerObstacle,
  });
}
