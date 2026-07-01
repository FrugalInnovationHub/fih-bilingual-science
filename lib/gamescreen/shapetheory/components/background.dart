import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/assets.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';

class Background extends ParallaxComponent<ShapeTheoryGame> {
  Background();

  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax(
      [ParallaxImageData(Assets.background)],
      baseVelocity: Vector2(Configuration.backgroundSpeed, 0),
      // velocityMultiplierDelta: Vector2(1.8, 0),
    );
  }
}

