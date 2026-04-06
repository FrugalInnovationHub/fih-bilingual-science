import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional imports
import 'tts_helper_stub.dart'
    if (dart.library.html) 'tts_helper_web.dart'
    as tts_helper;

class TtsHelper {
  static Future<void> speak(String text, {String? language}) async {
    await tts_helper.speak(text, language: language);
  }
}

