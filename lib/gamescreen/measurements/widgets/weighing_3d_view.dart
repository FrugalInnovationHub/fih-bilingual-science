import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A 2D fallback for the weighing scale visualization.
/// Displays a balance scale with the item on one side and blocks on the other,
/// tilting based on how many blocks vs the target weight.
class Weighing3DView extends StatelessWidget {
  final String emoji;
  final int blocks;
  final int target;

  const Weighing3DView({
    super.key,
    required this.emoji,
    required this.blocks,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate tilt: negative = left heavy (item), positive = right heavy (blocks)
    final diff = (blocks - target).clamp(-3, 3);
    final tiltAngle = -diff * 0.08; // radians

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3c1d78), Color(0xFF5b2fb8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Scale visualization
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: _ScalePainter(
                tiltAngle: tiltAngle,
                emoji: emoji,
                blocks: blocks,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Status text
          Text(
            blocks == target
                ? '⚖️ Balanced!'
                : blocks < target
                    ? '📦 Need more blocks!'
                    : '📦 Too many blocks!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScalePainter extends CustomPainter {
  final double tiltAngle;
  final String emoji;
  final int blocks;

  _ScalePainter({
    required this.tiltAngle,
    required this.emoji,
    required this.blocks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.7);

    // Base
    final basePaint = Paint()..color = const Color(0xFFf7a344);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, size.height - 15), width: 100, height: 20),
        const Radius.circular(4),
      ),
      basePaint,
    );

    // Pillar
    final pillarPaint = Paint()..color = const Color(0xFFffc06b);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy + 20), width: 16, height: 80),
        const Radius.circular(4),
      ),
      pillarPaint,
    );

    // Beam (tilted)
    canvas.save();
    canvas.translate(center.dx, center.dy - 20);
    canvas.rotate(tiltAngle);

    final beamPaint = Paint()
      ..color = const Color(0xFFe0e0e0)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(-100, 0), const Offset(100, 0), beamPaint);

    // Left plate (item)
    final platePaint = Paint()..color = const Color(0xFFb0b0b0);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-100, 15), width: 70, height: 12),
      platePaint,
    );

    // Right plate (blocks)
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 15), width: 70, height: 12),
      platePaint,
    );

    // Draw blocks on right plate
    final blockPaint = Paint()..color = const Color(0xFFff9f43);
    final blockBorder = Paint()
      ..color = const Color(0xFFe8893a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (int i = 0; i < blocks && i < 6; i++) {
      final blockRect = Rect.fromCenter(
        center: Offset(100, 15 - (i * 14) - 10),
        width: 28,
        height: 12,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(blockRect, const Radius.circular(2)),
        blockPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(blockRect, const Radius.circular(2)),
        blockBorder,
      );
    }

    // Draw emoji on left plate
    final textPainter = TextPainter(
      text: TextSpan(text: emoji, style: const TextStyle(fontSize: 36)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-100 - textPainter.width / 2, -textPainter.height + 5),
    );

    canvas.restore();

    // Pivot point
    final pivotPaint = Paint()..color = const Color(0xFFffc06b);
    canvas.drawCircle(Offset(center.dx, center.dy - 20), 8, pivotPaint);
    final pivotBorder = Paint()
      ..color = const Color(0xFFe0a030)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(center.dx, center.dy - 20), 8, pivotBorder);
  }

  @override
  bool shouldRepaint(covariant _ScalePainter oldDelegate) =>
      oldDelegate.tiltAngle != tiltAngle ||
      oldDelegate.emoji != emoji ||
      oldDelegate.blocks != blocks;
}
