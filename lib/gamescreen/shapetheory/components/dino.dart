import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/assets.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/game_storage.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/types.dart';

// Dino is the character of the game.
class Dino extends SpriteComponent
    with HasGameReference<ShapeTheoryGame>, CollisionCallbacks {
  Dino();

  int score = 0;
  double velocityY = 0;
  // groundY is used to position Dino in Y axis.
  late double groundY;

  @override
  Future<void> onLoad() async {
    final dino = await Flame.images.load(Assets.dino);
    size = Vector2(200, 240);
    groundY = game.size.y - size.y - Configuration.groundHeight;
    position = Vector2(70, groundY);
    sprite = Sprite(dino);

    // hitbox for collision
    add(RectangleHitbox(size: size * 0.72, position: size * 0.1));
  }

  // Method for Dino to jump. Set the vertical velocity to the jump speed of the game.
  void jump() {
    if (position.y >= groundY) {
      velocityY = Configuration.currentDifficulty.settings.jumpSpeed;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    game.stopBgm();
    debugPrint("Collision Detected");
    gameOver();
  }

  // Showing game over page.
  void gameOver() {
    game.overlays.add('gameOver');
    game.pauseEngine();
    GameStorage.saveScore(score);
  }

  // Reset Dino position for the new game to start.
  void reset() {
    groundY = game.size.y - size.y - Configuration.groundHeight;
    position = Vector2(70, groundY);
    score = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update vertical velocity and position using physics with gravity.
    velocityY += Configuration.currentDifficulty.settings.gravity * dt;
    position.y += velocityY * dt;

    // Stop updating when Dino back to ground.
    if (position.y >= groundY) {
      position.y = groundY;
      velocityY = 0;
    }
  }
}

