import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<void> initTTS() async {
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.awaitSpeakCompletion(true);
  }

  static Future<void> speak(String text, {String language = 'en-US'}) async {
    await _flutterTts.setLanguage(language);
    await _flutterTts.stop();

    final completer = Completer<void>();

    _flutterTts.setCompletionHandler(() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    await _flutterTts.speak(text);
    await completer.future; // ✅ Wait until TTS is done
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
  }
}
