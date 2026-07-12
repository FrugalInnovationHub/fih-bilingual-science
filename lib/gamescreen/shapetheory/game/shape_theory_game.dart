import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/components/background.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/components/dino.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/components/ground.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/components/jump_button.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/components/shape.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/assets.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/game_storage.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/types.dart';

// Game logic.
class ShapeTheoryGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  late Dino dino;
  late ShapeType activeType;
  late TextComponent score;
  late Ground ground;
  bool isPlaying = false;

  // For the 3 buttons group alone with each shape.
  PositionComponent? buttonContainer;
  Timer interval = Timer(
    Configuration.currentDifficulty.settings.shapeInterval,
    repeat: true,
  );

  @override
  Future<void> onLoad() async {
    // Set custom asset prefixes for ShapeTheory game
    images.prefix = 'assets/shapetheory/images/';
    FlameAudio.audioCache.prefix = 'assets/shapetheory/audio/';

    // Preload all images to prevent network loading latency
    await images.loadAll([
      Assets.background,
      Assets.ground,
      Assets.dino,
      Assets.icon,
    ]);

    // debugMode = true;
    Configuration.currentDifficulty = await GameStorage.loadDifficulty();
    Configuration.soundEnabled = await GameStorage.loadSoundPreference();
    Configuration.currentLanguage = await GameStorage.loadLanguage();
    add(Background());

    await FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      Assets.bgm,
      'circleEnglish.mp3',
      'diamondEnglish.mp3',
      'hexagonEnglish.mp3',
      'rectangleEnglish.mp3',
      'squareEnglish.mp3',
      'triangleEnglish.mp3',
    ]);

    if (Configuration.soundEnabled) {
      startBgm();
    }
  }

  void startBgm() {
    FlameAudio.bgm.play(Assets.bgm, volume: 0.5);
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  @override
  void onRemove() {
    FlameAudio.bgm.dispose();
    super.onRemove();
  }

  // Start the game. This is only called when user starts the game from main menu.
  void startGame() {
    addAll([ground = Ground(), dino = Dino(), score = buildScore()]);
    interval.stop();
    interval.reset();
    interval.onTick = () => _spawnRandomShape();
    interval.start();
    isPlaying = true;
  }

  TextComponent buildScore() {
    return TextComponent(
      text: 'Score: 0',
      position: Vector2(size.x / 10, (size.y / 2) * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Add the group of shape and buttons to the game.
  Future<void> spawnShapeAndButtons(ShapeType type) async {
    // Add shape
    activeType = type;
    debugPrint('Shape Type: $type');

    // Add buttons
    buttonContainer?.removeFromParent();
    buttonContainer = PositionComponent();
    add(buttonContainer!);

    final types = generateRandomButtonTypes(activeType);
    double startX = (size.x - Configuration.totalWidth) / 2;

    for (int i = 0; i < types.length; i++) {
      buttonContainer!.add(
        JumpButton(
          label: types[i].name,
          position: Vector2(
            startX + (Configuration.buttonWidth + Configuration.spacing) * i,
            620,
          ),
          type: types[i],
        ),
      );
    }

    add(Shape(type: type));
  }

  // Pick a shape randomly and call spawnShape to spwan it with the buttons.
  void _spawnRandomShape() {
    final randomType = ShapeType.values[1 + Random().nextInt(6)];
    spawnShapeAndButtons(randomType);
  }

  // Generate 3 buttons, 1 correct and 2 incorrect
  List<ShapeType> generateRandomButtonTypes(ShapeType activeType) {
    // Get all possible types except the active one
    List<ShapeType> others = ShapeType.values
        .where((t) => t != activeType && t != ShapeType.none)
        .toList();
    others.shuffle();

    // Pick 2 incorrect and 1 correct buttons
    List<ShapeType> results = [activeType, others[0], others[1]];

    results.shuffle();
    return results;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isPlaying) {
      interval.update(dt);
      score.text = 'Score: ${dino.score}';
    }
  }
}

