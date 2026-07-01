import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/types.dart';
import 'package:flutter/material.dart';

class Shape extends PositionComponent with HasGameReference<ShapeTheoryGame> {
  final ShapeType type;
  late final Paint _paint;
  late final Paint _borderPaint;
  late double groundY;

  Shape({required this.type}) : super(size: Vector2.all(160));

  @override
  Future<void> onLoad() async {
    _paint = Paint()..color = _getColor();
    _borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    groundY = game.size.y - size.y - 33 - Configuration.groundHeight;
    position = Vector2(game.size.x, groundY);

    _addHitbox();
  }

  Color _getColor() {
    switch (type) {
      case ShapeType.none:
        return Colors.black;
      case ShapeType.circle:
        return Colors.blue;
      case ShapeType.rectangle:
        return Colors.red;
      case ShapeType.triangle:
        return Colors.pink;
      case ShapeType.square:
        return Colors.yellow;
      case ShapeType.hexagon:
        return Colors.purple;
      case ShapeType.diamond:
        return Colors.lightGreen;
    }
  }

  void _addHitbox() {
    switch (type) {
      case ShapeType.none:
        throw UnimplementedError();
      case ShapeType.circle:
        add(CircleHitbox());
        break;
      case ShapeType.rectangle:
        add(
          PolygonHitbox.relative([
            Vector2(-1.0, -0.4),
            Vector2(1.0, -0.4),
            Vector2(1.0, 1.0),
            Vector2(-1.0, 1.0),
          ], parentSize: size),
        );
        break;
      case ShapeType.triangle:
        add(
          PolygonHitbox.relative([
            Vector2(0, -1), // Top Center
            Vector2(-1, 1), // Bottom Left
            Vector2(1, 1), // Bottom Right
          ], parentSize: size),
        );
      case ShapeType.square:
        add(RectangleHitbox());
      case ShapeType.hexagon:
        add(
          PolygonHitbox.relative([
            Vector2(-0.5, -1.0), // Top Left
            Vector2(0.5, -1.0), // Top Right
            Vector2(1.0, 0.0), // Middle Right (Pointy side)
            Vector2(0.5, 1.0), // Bottom Right
            Vector2(-0.5, 1.0), // Bottom Left
            Vector2(-1.0, 0.0), // Middle Left (Pointy side)
          ], parentSize: size),
        );
        break;
      case ShapeType.diamond:
        add(
          PolygonHitbox.relative([
            Vector2(0, -1.0), // Top Point
            Vector2(1.0, 0), // Right Point
            Vector2(0, 1.0), // Bottom Point
            Vector2(-1.0, 0), // Left Point
          ], parentSize: size),
        );
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final w = size.x;
    final h = size.y;

    switch (type) {
      case ShapeType.none:
        throw UnimplementedError();
      case ShapeType.circle:
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2, _paint);
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2, _borderPaint);
        break;
      case ShapeType.rectangle:
        final path = Path()
          ..moveTo(0, h * 0.35)
          ..lineTo(w, h * 0.35)
          ..lineTo(w, h)
          ..lineTo(0, h);
        canvas.drawPath(path, _paint);
        canvas.drawPath(path, _borderPaint);
        break;
      case ShapeType.triangle:
        final path = Path()
          ..moveTo(w * 0.5, 0)
          ..lineTo(0, h)
          ..lineTo(w, h)
          ..close();
        canvas.drawPath(path, _paint);
        canvas.drawPath(path, _borderPaint);
        break;
      case ShapeType.square:
        canvas.drawRect(size.toRect(), _paint);
        canvas.drawRect(size.toRect(), _borderPaint);
        break;
      case ShapeType.hexagon:
        final path = Path()
          ..moveTo(w * 0.25, 0) // Top Left
          ..lineTo(w * 0.75, 0) // Top Right
          ..lineTo(w, h * 0.5) // Middle Right
          ..lineTo(w * 0.75, h) // Bottom Right
          ..lineTo(w * 0.25, h) // Bottom Left
          ..lineTo(0, h * 0.5) // Middle Left
          ..close();

        canvas.drawPath(path, _paint);
        canvas.drawPath(path, _borderPaint);
        break;
      case ShapeType.diamond:
        final path = Path()
          ..moveTo(w * 0.5, 0) // Top Center
          ..lineTo(w, h * 0.5) // Middle Right
          ..lineTo(w * 0.5, h) // Bottom Center
          ..lineTo(0, h * 0.5) // Middle Left
          ..close();

        canvas.drawPath(path, _paint);
        canvas.drawPath(path, _borderPaint);
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Configuration.currentDifficulty.settings.speed * dt;

    // Remove if off screen and update score.
    if (position.x < -size.x) {
      game.activeType = ShapeType.none;
      removeFromParent();
      updateScore();
      debugPrint('Shape ${type.name} Removed');
    }
  }

  void updateScore() {
    game.dino.score +=
        Configuration.currentDifficulty.settings.scorePerObstacle;
  }
}

