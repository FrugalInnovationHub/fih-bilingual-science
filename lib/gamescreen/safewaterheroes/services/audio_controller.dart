import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/strings.dart';
import '../providers/app_settings_provider.dart';
import '../providers/repeat_button_provider.dart';
import 'tts_service.dart';

final audioControllerProvider = Provider<AudioController>((ref) {
  return AudioController(ref);
});

class AudioController {
  final Ref _ref;
  final TtsService _ttsService = TtsService();

  // We keep timers for the repeat button logic, but NOT for speech duration
  Timer? _repeatTimer; 
  String? _lastSpokenText;

  AudioController(this._ref);

  // Read fresh settings each time to get current audio language
  String get _currentLang {
    final lang = _ref.read(appSettingsProvider).audioLanguageCode;
    debugPrint('AudioController: Current audio language is: $lang');
    return lang;
  }
  bool get _isMuted => _ref.read(appSettingsProvider).isMuted;

  /// Fire-and-forget (for UI clicks)
  void requestSpeak(String text) {
    if (_isMuted) return;
    speakAndWait(text);
  }

  /// Awaitable speak (For Game Flow)
  Future<void> speakAndWait(String text) async {
    if (_isMuted) return;

    // 1. Hide Repeat Button
    _ref.read(repeatButtonVisibleProvider.notifier).state = false;
    _repeatTimer?.cancel();

    _lastSpokenText = text;

    // 2. Translate text if speaking in Spanish
    final lang = _currentLang;
    final textToSpeak = AppStrings.translateForAudio(text, lang);
    debugPrint('AudioController: Original="$text" -> Translated="$textToSpeak" (lang=$lang)');

    // 3. Speak and Wait for Completion Signal
    await _ttsService.speak(textToSpeak, lang);

    // 4. Show Repeat Button after delay
    _repeatTimer = Timer(const Duration(seconds: 5), () {
      _ref.read(repeatButtonVisibleProvider.notifier).state = true;
    });
  }

  void repeatLast() {
    if (_lastSpokenText != null) {
      requestSpeak(_lastSpokenText!);
    }
  }

  void stop() {
    _repeatTimer?.cancel();
    _ttsService.stop();
  }
}