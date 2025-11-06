import 'package:flutter_tts/flutter_tts.dart';

class StoryDetailScreen extends StatefulWidget {
  // ... (existing code)
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  // ... (existing code)

  Future<void> _setupTts() async {
    await flutterTts.setLanguage(_translationService.isSpanish ? "es-ES" : "en-US");
    await flutterTts.setSpeechRate(0.3);
    
    // Get available voices
    final voices = await flutterTts.getVoices;
    
    // Find appropriate voices for characters
    if (voices != null) {
      // Look for a deep male voice for Tommy
      final tommyVoiceData = voices.firstWhere(
        (voice) => voice.name.toLowerCase().contains('male') || 
                   voice.name.toLowerCase().contains('man') ||
                   voice.name.toLowerCase().contains('michael') ||
                   voice.name.toLowerCase().contains('daniel') ||
                   voice.name.toLowerCase().contains('david')
      );
      tommyVoice = {'name': tommyVoiceData.name, 'locale': tommyVoiceData.locale};
      await flutterTts.setPitch(0.5); // Lower pitch for deeper male voice
      await flutterTts.setSpeechRate(0.3); // Slower speech rate for clarity

      // Look for a higher pitched female voice for the bottle
      final bottleVoiceData = voices.firstWhere(
        (voice) => voice.name.toLowerCase().contains('female') || 
                   voice.name.toLowerCase().contains('woman') ||
                   voice.name.toLowerCase().contains('samantha') ||
                   voice.name.toLowerCase().contains('karen')
      );
      bottleVoice = {'name': bottleVoiceData.name, 'locale': bottleVoiceData.locale};
      await flutterTts.setPitch(0.5); // Higher pitch for female voice
      await flutterTts.setSpeechRate(0.3); // Slower speech rate for clarity
    }
  }

  // ... (rest of the existing code)
} 