import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_controller.dart';

class TappableText extends ConsumerWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const TappableText({
    super.key, 
    required this.text, 
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioCtrl = ref.read(audioControllerProvider);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      // Hover logic: Trigger speak if needed, or remove if you want tap-only
      onEnter: (_) => audioCtrl.requestSpeak(text), 
      child: GestureDetector(
        // Tap logic
        onTap: () => audioCtrl.requestSpeak(text),
        child: Text(
          text,
          style: style,
          textAlign: textAlign,
        ),
      ),
    );
  }
}