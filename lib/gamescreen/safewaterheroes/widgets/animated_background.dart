import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';
import '../constants/assets.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.mainBgGradient,
          ),
        ),
        // Drifting bubbles layer
        ...List.generate(3, (index) => _buildDriftingBubble(index, context)),
        // Main content
        child,
      ],
    );
  }

  Widget _buildDriftingBubble(int index, BuildContext context) {
    final random = Random(index);
    final size = random.nextDouble() * 60 + 30; // 30-90px
    final startX = random.nextDouble() * MediaQuery.of(context).size.width;
    final duration = random.nextInt(10) + 15; // 15-25s drift

    return Positioned(
      left: startX,
      bottom: -100,
      child: Image.asset(
        AppAssets.bubble,
        width: size,
        height: size,
        color: Colors.white.withOpacity(0.2),
      )
      .animate(onPlay: (controller) => controller.repeat())
      .moveY(begin: 0, end: -MediaQuery.of(context).size.height - 200, duration: duration.seconds, curve: Curves.linear)
      .fadeIn(duration: 1.seconds)
      .fadeOut(delay: (duration - 2).seconds, duration: 2.seconds),
    );
  }
}