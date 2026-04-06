import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  Completer<void>? _speechCompleter;

  TtsService() {
    _init();
  }

  void _init() async {
    // Improved voice clarity settings
    await _flutterTts.setSpeechRate(0.45); // Slightly faster for clarity (0.3 was too slow)
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.1); // Slightly higher pitch for clearer voice

    // Log available voices for debugging
    var voices = await _flutterTts.getVoices;
    var languages = await _flutterTts.getLanguages;
    debugPrint('TTS Available languages: $languages');
    
    // KEY FIX: Listen for completion
    _flutterTts.setCompletionHandler(() {
      if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
        _speechCompleter!.complete();
      }
    });

    _flutterTts.setErrorHandler((msg) {
      debugPrint('TTS Error: $msg');
      if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
        _speechCompleter!.complete(); // Don't hang on error
      }
    });
  }

  /// Returns a Future that completes when speech finishes
  Future<void> speak(String text, String languageCode) async {
    // Cancel previous if running
    if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
      _speechCompleter!.complete(); 
    }
    
    _speechCompleter = Completer<void>();

    // Use es-US (Latin American Spanish) which is more commonly available on browsers
    String locale = languageCode == 'es' ? 'es-US' : 'en-US';
    debugPrint('TTS: Speaking "$text" in language: $languageCode -> locale: $locale');
    var langResult = await _flutterTts.setLanguage(locale);
    debugPrint('TTS setLanguage result: $langResult');
    
    // Web requires explicit await on speak, mobile relies on handler
    var result = await _flutterTts.speak(text);
    debugPrint('TTS speak result: $result');

    // Safety timeout: If TTS hangs (common on Web), complete anyway after estimated time
    // Approx 150 words/min = 2.5 words/sec. 
    int estimatedSecs = (text.split(' ').length / 2.0).ceil() + 2;
    return _speechCompleter!.future.timeout(Duration(seconds: estimatedSecs), onTimeout: () {
      return; // Just continue
    });
  }

  Future<void> stop() async {
    if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
      _speechCompleter!.complete();
    }
    await _flutterTts.stop();
  }
}