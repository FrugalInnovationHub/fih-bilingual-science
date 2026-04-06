// Web implementation using browser's SpeechSynthesis API
import 'dart:html' as html;

bool _isSpeaking = false;

Future<void> speak(String text, {String? language}) async {
  try {
    final synth = html.window.speechSynthesis;
    if (synth != null && !_isSpeaking) {
      // Cancel any ongoing speech first
      synth.cancel();
      
      // Wait a tiny bit to ensure cancellation is processed
      await Future.delayed(const Duration(milliseconds: 50));
      
      _isSpeaking = true;
      final utterance = html.SpeechSynthesisUtterance(text);
      utterance.lang = language == 'es' ? 'es-ES' : 'en-US';
      utterance.rate = 0.8;
      utterance.pitch = 1.0;
      utterance.volume = 1.0;
      
      // Reset flag when speech ends using addEventListener
      utterance.addEventListener('end', (event) {
        _isSpeaking = false;
      });
      
      utterance.addEventListener('error', (event) {
        _isSpeaking = false;
        // Silently handle errors
      });
      
      synth.speak(utterance);
      
      // Also set a timeout to reset flag in case events don't fire
      Future.delayed(const Duration(seconds: 3), () {
        _isSpeaking = false;
      });
    }
  } catch (e) {
    _isSpeaking = false;
    // Silently handle errors
  }
}

