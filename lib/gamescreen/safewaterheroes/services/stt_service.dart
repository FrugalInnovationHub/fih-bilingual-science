import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';

class SttResult {
  final String recognizedWords;
  final bool isFinal;
  SttResult(this.recognizedWords, this.isFinal);
}

class SttService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;
  int _failureCount = 0;

  int get failureCount => _failureCount;

  Future<bool> init() async {
    try {
      _isAvailable = await _speech.initialize(
        onError: (val) => debugPrint('STT Error: $val'),
        onStatus: (val) => debugPrint('STT Status: $val'),
      );
    } catch (e) {
       debugPrint("STT init failed: $e");
       _isAvailable = false;
    }
    return _isAvailable;
  }

  void startListening({
    required Function(SttResult) onResult,
    required String languageCode,
    required VoidCallback onDone,
  }) {
    if (!_isAvailable) {
      onDone();
      return;
    }

    String localeId = languageCode == 'es' ? 'es_ES' : 'en_US';

    _speech.listen(
      onResult: (result) {
        onResult(SttResult(result.recognizedWords, result.finalResult));
         if (result.finalResult) {
            // Successful recognition resets failure count
            _failureCount = 0;
            onDone();
         }
      },
      localeId: localeId,
      listenFor: const Duration(seconds: 5),
      pauseFor: const Duration(seconds: 2),
      cancelOnError: true,
      partialResults: true,
    ).catchError((e) {
       _failureCount++;
       onDone();
    });
  }

  void stop() async {
    await _speech.stop();
  }

  void incrementFailure() {
    _failureCount++;
  }
}