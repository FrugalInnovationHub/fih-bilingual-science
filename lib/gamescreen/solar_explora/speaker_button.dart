import 'package:flutter/material.dart';
import 'tts_service.dart';

class SpeakerButton extends StatefulWidget {
  final List<String> textSegments; // List of words or phrases to read
  final bool isSpanish; // Language toggle
  final Function(int)? onSegmentSpoken; // Callback to highlight current index
  final void Function(bool isSpeaking)? onSpeakingChanged;

  const SpeakerButton({
    super.key,
    required this.textSegments,
    required this.isSpanish,
    this.onSegmentSpoken,
    this.onSpeakingChanged,
  });

  @override
  State<SpeakerButton> createState() => _SpeakerButtonState();
}

class _SpeakerButtonState extends State<SpeakerButton> {
  bool _isSpeaking = false;

  Future<void> _startSpeaking() async {
  setState(() => _isSpeaking = true);
  widget.onSpeakingChanged?.call(true);

  final languageCode = widget.isSpanish ? 'es-ES' : 'en-US';
  int globalWordIndex = 0;

  for (int i = 0; i < widget.textSegments.length; i++) {
    if (!_isSpeaking) break;

    final sentence = widget.textSegments[i];
    final words = sentence.split(' ');

    // Start highlighting in parallel with TTS
    final highlightFuture = _highlightWords(words, globalWordIndex);
    final ttsFuture = TTSService.speak(sentence, language: languageCode);

    await Future.wait([highlightFuture, ttsFuture]);

    globalWordIndex += words.length;
    if (!_isSpeaking) break;

    await Future.delayed(const Duration(milliseconds: 300)); // brief pause between sentences
  }

    widget.onSegmentSpoken?.call(-1); // clear highlight
    setState(() => _isSpeaking = false);
    widget.onSpeakingChanged?.call(false);
  }

  Future<void> _highlightWords(List<String> words, int startIndex) async {
    for (int i = 0; i < words.length; i++) {
      if (!_isSpeaking) break;
      widget.onSegmentSpoken?.call(startIndex + i);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }




  void _stopSpeaking() {
    TTSService.stop();
    setState(() => _isSpeaking = false);
    widget.onSegmentSpoken?.call(-1);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        backgroundColor: Colors.white24,
        onPressed: _isSpeaking ? _stopSpeaking : _startSpeaking,
        child: Icon(
          _isSpeaking ? Icons.stop : Icons.volume_up,
          color: Colors.white,
        ),
      ),
    );
  }
}
