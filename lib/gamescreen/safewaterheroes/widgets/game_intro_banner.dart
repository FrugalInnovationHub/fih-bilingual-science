import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_settings_provider.dart'; // Ensure correct import
import '../services/audio_controller.dart'; // Ensure correct import

class GameIntroBanner extends ConsumerStatefulWidget {
  final String textEn;
  final String textEs;

  const GameIntroBanner({super.key, required this.textEn, required this.textEs});

  @override
  ConsumerState<GameIntroBanner> createState() => _GameIntroBannerState();
}

class _GameIntroBannerState extends ConsumerState<GameIntroBanner> {
  @override
  void initState() {
    super.initState();
    // Speak once on load (safe post-frame)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speak();
    });
  }

  void _speak() {
    final lang = ref.read(appSettingsProvider).languageCode;
    final text = lang == 'es' ? widget.textEs : widget.textEn;
    ref.read(audioControllerProvider).requestSpeak(text);
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    final text = lang == 'es' ? widget.textEs : widget.textEn;

    return Container(
      width: double.infinity,
      color: Colors.yellow.shade100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: _speak,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, color: Colors.orange),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.volume_up, size: 20, color: Colors.brown),
          ],
        ),
      ),
    );
  }
}