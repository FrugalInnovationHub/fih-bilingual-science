import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class AudioRepeaterOverlay extends StatefulWidget {
  final Widget child;
  // In a real implementation, we'd pass the specific text content to repeat.
  // For this scope, we'll simulate the button appearing.
  const AudioRepeaterOverlay({super.key, required this.child});

  @override
  State<AudioRepeaterOverlay> createState() => _AudioRepeaterOverlayState();
}

class _AudioRepeaterOverlayState extends State<AudioRepeaterOverlay> {
  Timer? _timer;
  bool _showRepeatBtn = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _showRepeatBtn = false;
    // Spec: appears every 30s
    _timer = Timer(const Duration(seconds: 30), () {
      if (mounted) setState(() => _showRepeatBtn = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showRepeatBtn)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Action: Re-trigger the main audio for this screen.
                // Implementation depends on how screen audio is tracked.
                debugPrint("Repeat Audio Requested");
                setState(() => _showRepeatBtn = false);
                _startTimer(); // Restart cycle
              },
              backgroundColor: AppTheme.accentOrange,
              icon: const Icon(Icons.replay_rounded),
              label: const Text("Repeat"),
            ).animate().fadeIn().scale(),
          ),
      ],
    );
  }
}