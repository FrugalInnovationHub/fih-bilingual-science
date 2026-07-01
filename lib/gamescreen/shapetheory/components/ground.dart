import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/assets.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/types.dart';

class Ground extends ParallaxComponent<ShapeTheoryGame> {
  Ground();

  @override
  Future<void> onLoad() async {
    final ground = await Flame.images.load(Assets.ground);
    parallax = Parallax([
      ParallaxLayer(ParallaxImage(ground, fill: LayerFill.none)),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = Configuration.currentDifficulty.settings.speed;
  }
}

