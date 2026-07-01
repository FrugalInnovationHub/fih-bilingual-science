import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/components/button_frame.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/assets.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/types.dart';

// This class is the buttons for users to click in game.
class JumpButton extends HudButtonComponent {
  final String label;
  final ShapeType type;
  late final ButtonFrame bf;

  static final Vector2 buttonSize = Vector2(170, 70);

  JumpButton({
    required this.label,
    required Vector2 position,
    required this.type,
  }) : super(
         button: PositionComponent(size: buttonSize),
         position: position,
       );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Build this button with ButtonFrame and label
    button!.addAll([
      bf = ButtonFrame(size: buttonSize, color: const Color(0xFF9D92F5)),
      TextComponent(
        text: label.toUpperCase(),
        anchor: Anchor.center,
        position: buttonSize / 2,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'PixelFont',
          ),
        ),
      ),
    ]);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    final myGame = game as ShapeTheoryGame;
    // If this button is the correct one, light up the button and allow, or flash a red color to indicate this button is wrong. Dino can only jump when the button clicked is correct.
    if (myGame.activeType == type) {
      bf.add(
        ColorEffect(
          Color.fromARGB(255, 195, 188, 250),
          EffectController(duration: 0.2, reverseDuration: 0.3),
        ),
      );
      if (Configuration.soundEnabled) {
        FlameAudio.play('${type.name}English.mp3');
      }
      myGame.dino.jump();
    } else {
      debugPrint('Wrong Button');
      bf.add(
        ColorEffect(
          Colors.redAccent,
          EffectController(duration: 0.2, reverseDuration: 0.3),
        ),
      );
    }
  }
}

