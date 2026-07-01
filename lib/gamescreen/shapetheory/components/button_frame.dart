import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// This class is the frame of jump buttons in the game. Its job is to change the button's color once the button is clicked, which indicates if the button clicked is correct or not.
class ButtonFrame extends PositionComponent with HasPaint {
  final Color color;
  final double borderRadius;

  ButtonFrame({
    required Vector2 size,
    required this.color,
    this.borderRadius = 10.0,
  }) : super(size: size) {
    paint.color = color;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), Radius.circular(borderRadius)),
      paint,
    );
  }
}
