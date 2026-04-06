import 'package:flutter/material.dart';
import 'speaker_button.dart';
import 'tts_service.dart';

class PlanetPage extends StatefulWidget {
  final String planetName;
  final String spanishName;
  final String backgroundImage;
  final List<String> englishFacts;
  final List<String> spanishFacts;

  const PlanetPage({
    super.key,
    required this.planetName,
    required this.spanishName,
    required this.backgroundImage,
    required this.englishFacts,
    required this.spanishFacts,
  });

  @override
  State<PlanetPage> createState() => _PlanetPageState();
}

class _PlanetPageState extends State<PlanetPage> {
  bool isSpanish = false;
  int currentSentenceIndex = -1;
  int currentWordIndex = -1;
  bool isSpeaking = false;

  @override
  Widget build(BuildContext context) {
    final facts = isSpanish ? widget.spanishFacts : widget.englishFacts;
    final title = isSpanish ? widget.spanishName : widget.planetName;

    return Scaffold(
      body: Stack(
        children: [
          /// 🌌 Background
          Positioned.fill(
            child: Image.asset(
              widget.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),

          /// 🌐 Language toggle + back button
          SafeArea(
            child: Column(
              children: [
                /// Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🔙 Back
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),

                    // 🌐 Toggle
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'EN',
                              style: TextStyle(
                                color: isSpeaking
                                    ? Colors.white24
                                    : (isSpanish ? Colors.white54 : Colors.white),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Switch(
                              value: isSpanish,
                              onChanged: isSpeaking
                              ? null  // disables the switch while speaking
                              : (value) {
                                  setState(() {
                                    isSpanish = value;
                                  });
                              },
                              activeColor: Colors.orange,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey,
                            ),
                            Text(
                              'ES',
                              style: TextStyle(
                                color: isSpeaking
                                    ? Colors.white24
                                    : (isSpanish ? Colors.white : Colors.white54),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// 🪐 Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                /// 📌 Facts
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView.builder(
                      itemCount: facts.length,
                      itemBuilder: (context, index) {
                        final sentence = facts[index];
                        final words = sentence.split(' ');

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("• ", style: TextStyle(color: Colors.white, fontSize: 32)),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: words.asMap().entries.map((entry){
                                      final i = entry.key;
                                      final word = entry.value;
                                      final isHighlighted = index == currentSentenceIndex && i == currentWordIndex;

                                      return TextSpan(
                                        text: '$word ',
                                        style: TextStyle(
                                          color: isHighlighted ? Colors.orange : Colors.white,
                                          fontSize: 32,
                                          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      );
                                    }).toList(),
                                  )
                                  //facts[index],
                                  //style: const TextStyle(color: Colors.white, fontSize: 32),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SpeakerButton(
            textSegments: isSpanish ? widget.spanishFacts : widget.englishFacts,
            isSpanish: isSpanish,
            onSegmentSpoken: (index) {
              if (index == -1) {
                setState(() {
                  currentSentenceIndex = -1;
                  currentWordIndex = -1;
                });
              } else {
                // Calculate which sentence and word index the flat index corresponds to
                int sentence = 0;
                int wordCount = 0;

                final facts = isSpanish ? widget.spanishFacts : widget.englishFacts;

                for (int i = 0; i < facts.length; i++) {
                  final wordList = facts[i].split(' ');
                  if (index < wordCount + wordList.length) {
                    setState(() {
                      currentSentenceIndex = i;
                      currentWordIndex = index - wordCount;
                    });
                    return;
                  }
                  wordCount += wordList.length;
                }
              }
            },
            onSpeakingChanged: (value) {
              setState(() {
                isSpeaking = value;
              });
            },
          ),
          // Positioned(
          //   bottom: 20,
          //   right: 20,
          //   child: IconButton(
          //     icon: const Icon(Icons.volume_up, color: Colors.white, size: 36),
          //     onPressed: () async {
          //       if (isSpeaking) {
          //         await TTSService.stop();
          //         setState(() {
          //           isSpeaking = false;
          //           currentSentenceIndex = -1;
          //           currentWordIndex = -1;
          //         });
          //         return;
          //       }

          //       setState(() => isSpeaking = true);
          //       final facts = isSpanish ? widget.spanishFacts : widget.englishFacts;

          //       for (int i = 0; i < facts.length; i++) {
          //         final sentence = facts[i];
          //         final words = sentence.split(' ');

          //         // 🔊 Speak full sentence at once
          //         await TTSService.speak(sentence, language: isSpanish ? 'es-ES' : 'en-US');

          //         // 🔦 Word-by-word highlight using timer
          //         for (int j = 0; j < words.length; j++) {
          //           if (!isSpeaking) break;
          //           setState(() {
          //             currentSentenceIndex = i;
          //             currentWordIndex = j;
          //           });
          //           await Future.delayed(const Duration(milliseconds: 300)); // adjust timing
          //         }

          //         if (!isSpeaking) break;
          //         await Future.delayed(const Duration(milliseconds: 400)); // short gap between sentences
          //       }

          //       setState(() {
          //         isSpeaking = false;
          //         currentSentenceIndex = -1;
          //         currentWordIndex = -1;
          //       });
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
