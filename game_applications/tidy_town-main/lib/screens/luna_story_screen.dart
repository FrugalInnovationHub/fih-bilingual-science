import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/translation_service.dart';

class LunaStoryScreen extends StatefulWidget {
  final TranslationService translationService;

  const LunaStoryScreen({super.key, required this.translationService});

  @override
  State<LunaStoryScreen> createState() => _LunaStoryScreenState();
}

class _LunaStoryScreenState extends State<LunaStoryScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  int currentPage = 0;
  int conversationsPerPage = 1; // One dialogue per page
  Map<String, String> lunaVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> bobbyVoice = {'name': 'default', 'locale': 'en-US'};
  bool isPlaying = false;
  late final TranslationService _translationService;

  final List<String> storyContent = [
    "Hi friends! I'm Luna. I live in a big, happy forest.",
    "But my forest friends are in danger because too many trees are being cut down.",
    "Hey Luna! If kids recycle paper, we don't need to cut so many trees!",
    "That's right! Recycling paper saves homes for birds, bugs, and bears too!",
    "Plus, it saves energy and keeps our Earth cool and clean.",
    "Let's be Earth heroes and recycle every day!",
  ];

  final List<String> speakers = [
    "luna",
    "luna",
    "bobby",
    "luna",
    "bobby",
    "luna",
  ];

  @override
  void initState() {
    super.initState();
    _translationService = widget.translationService;
    _setupTts();
    _setupAudio();
  }

  @override
  void didUpdateWidget(LunaStoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.translationService != widget.translationService) {
      _translationService = widget.translationService;
      _setupTts();
      setState(() {});
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage(
      _translationService.isSpanish ? "es-ES" : "en-US",
    );
    await flutterTts.setSpeechRate(0.3);

    final voices = await flutterTts.getVoices;

    if (voices != null) {
      // Look for a gentle female voice for Luna
      final lunaVoiceData = voices.firstWhere(
        (voice) =>
            voice.name.toLowerCase().contains('female') ||
            voice.name.toLowerCase().contains('woman') ||
            voice.name.toLowerCase().contains('samantha') ||
            voice.name.toLowerCase().contains('karen') ||
            voice.name.toLowerCase().contains('child') ||
            voice.name.toLowerCase().contains('girl'),
        orElse: () => voices.first,
      );
      lunaVoice = {'name': lunaVoiceData.name, 'locale': lunaVoiceData.locale};
      await flutterTts.setPitch(1.2); // Higher pitch for kid-like voice
      await flutterTts.setSpeechRate(
        0.4,
      ); // Slightly faster for more energetic kid voice

      // Look for a friendly male voice for Bobby
      final bobbyVoiceData = voices.firstWhere(
        (voice) =>
            voice.name.toLowerCase().contains('male') ||
            voice.name.toLowerCase().contains('man') ||
            voice.name.toLowerCase().contains('michael') ||
            voice.name.toLowerCase().contains('daniel'),
        orElse: () => voices.first,
      );
      bobbyVoice = {
        'name': bobbyVoiceData.name,
        'locale': bobbyVoiceData.locale,
      };
      await flutterTts.setPitch(0.1); // Slightly lower pitch for Bobby
      await flutterTts.setSpeechRate(0.1); // Slower speech rate for clarity
    }
  }

  Future<void> _setupAudio() async {
    await audioPlayer.setSource(AssetSource('sounds/high-five.mp3'));
    await audioPlayer.setVolume(1.0);
  }

  Future<void> _playHighFive() async {
    await audioPlayer.stop();
    await audioPlayer.play(AssetSource('sounds/high-five.mp3'));
  }

  Future<void> _speakLines(int startIndex) async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
      return;
    }

    setState(() {
      isPlaying = true;
    });

    String lastSpeaker = "";
    for (
      int i = startIndex;
      i < startIndex + conversationsPerPage && i < storyContent.length;
      i++
    ) {
      if (!isPlaying) break;

      final line = storyContent[i];
      final speaker = speakers[i];
      final translatedLine = _translationService.translate(line);

      if (lastSpeaker != "" && lastSpeaker != speaker) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      if (speaker == "luna") {
        await flutterTts.setVoice(lunaVoice);
        await flutterTts.setPitch(2.8); // Slightly lower pitch for Bobby
        await flutterTts.setSpeechRate(0.1);
      } else if (speaker == "bobby") {
        await flutterTts.setVoice(bobbyVoice);
        await flutterTts.setPitch(0.1); // Slightly lower pitch for Bobby
        await flutterTts.setSpeechRate(0.1);
      }

      await flutterTts.speak(translatedLine);

      final length = translatedLine.length;
      final basePause = 1000;
      final charPause = (length * 50).clamp(500, 2000);
      await Future.delayed(Duration(milliseconds: charPause + basePause));

      lastSpeaker = speaker;
    }

    setState(() {
      isPlaying = false;
    });
  }

  List<String> getCurrentPageLines() {
    final startIndex = currentPage * conversationsPerPage;
    final endIndex = (startIndex + conversationsPerPage).clamp(
      0,
      storyContent.length,
    );
    return storyContent.sublist(startIndex, endIndex);
  }

  bool get hasNextPage =>
      (currentPage + 1) * conversationsPerPage < storyContent.length;
  bool get hasPreviousPage => currentPage > 0;

  @override
  Widget build(BuildContext context) {
    final currentLines = getCurrentPageLines();
    final isFirstPage = currentPage == 0;
    final isSecondPage = currentPage == 1;
    final isThirdPage = currentPage == 2;
    final isFourthPage = currentPage == 3;
    final isFifthPage = currentPage == 4;
    final isLastPage = currentPage == 5;

    return WillPopScope(
      onWillPop: () async {
        await flutterTts.stop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _translationService.translate("Luna the Leaf's Big Idea"),
            style: const TextStyle(
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green.shade100,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _translationService.isSpanish
                    ? Icons.language
                    : Icons.translate,
                color: Colors.green.shade900,
              ),
              onPressed: () {
                _translationService.toggleLanguage();
                setState(() {});
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              // Background image based on page
              if (isFirstPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/luna1.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSecondPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/luna2.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isThirdPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/luna3.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isFourthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/luna4.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isFifthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/luna5.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isLastPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/lunalast.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentLines.length,
                        itemBuilder: (context, index) {
                          final startIndex = currentPage * conversationsPerPage;
                          final line = currentLines[index];
                          final speaker = speakers[startIndex + index];
                          final isLuna = speaker == "luna";

                          return Align(
                            alignment:
                                isLuna
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75,
                              ),
                              margin: EdgeInsets.only(
                                bottom: 30,
                                left: isLuna ? 0 : 40,
                                right: isLuna ? 40 : 0,
                                top: index == 0 ? 20 : 0,
                              ),
                              child: CustomPaint(
                                painter: CloudBubblePainter(
                                  color:
                                      isLuna
                                          ? Colors.green.shade50.withOpacity(
                                            0.95,
                                          )
                                          : Colors.blue.shade50.withOpacity(
                                            0.95,
                                          ),
                                  isLeftAligned: isLuna,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    16,
                                    20,
                                    24,
                                  ),
                                  child: Text(
                                    _translationService.translate(line),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Navigation Buttons at bottom
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (hasPreviousPage)
                            ElevatedButton.icon(
                              onPressed: () async {
                                await flutterTts.stop();
                                setState(() {
                                  isPlaying = false;
                                  currentPage--;
                                });
                              },
                              icon: const Icon(Icons.arrow_back),
                              label: Text(
                                _translationService.translate('Previous'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade300,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ElevatedButton.icon(
                            onPressed:
                                () => _speakLines(
                                  currentPage * conversationsPerPage,
                                ),
                            icon: Icon(
                              isPlaying ? Icons.stop : Icons.volume_up,
                              color: Colors.white,
                            ),
                            label: Text(
                              _translationService.translate(
                                isPlaying ? 'Stop' : 'Listen',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isPlaying
                                      ? Colors.red.shade300
                                      : Colors.green.shade300,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          if (hasNextPage)
                            ElevatedButton.icon(
                              onPressed: () async {
                                await flutterTts.stop();
                                setState(() {
                                  isPlaying = false;
                                  currentPage++;
                                });
                              },
                              icon: const Icon(Icons.arrow_forward),
                              label: Text(
                                _translationService.translate('Next'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade300,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for cloud-like speech bubbles
class CloudBubblePainter extends CustomPainter {
  final Color color;
  final bool isLeftAligned;

  CloudBubblePainter({required this.color, required this.isLeftAligned});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    final radius = 20.0;

    // Main bubble
    path.moveTo(radius, 0);

    // Top edge with bumps
    path.quadraticBezierTo(size.width / 4, -10, size.width / 2, 0);
    path.quadraticBezierTo(size.width * 3 / 4, 10, size.width - radius, 0);

    // Right edge
    path.quadraticBezierTo(
      size.width + 5,
      size.height / 3,
      size.width - radius,
      size.height - radius,
    );

    // Bottom edge with bumps
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height + 5,
      size.width / 2,
      size.height - radius / 2,
    );
    path.quadraticBezierTo(
      size.width / 4,
      size.height - 10,
      radius,
      size.height - radius,
    );

    // Left edge
    path.quadraticBezierTo(-5, size.height / 3, radius, 0);

    // Add tail
    if (isLeftAligned) {
      path.moveTo(30, size.height - radius);
      path.quadraticBezierTo(10, size.height + 10, 0, size.height + 20);
      path.quadraticBezierTo(
        20,
        size.height - radius + 10,
        30,
        size.height - radius,
      );
    } else {
      path.moveTo(size.width - 30, size.height - radius);
      path.quadraticBezierTo(
        size.width - 10,
        size.height + 10,
        size.width,
        size.height + 20,
      );
      path.quadraticBezierTo(
        size.width - 20,
        size.height - radius + 10,
        size.width - 30,
        size.height - radius,
      );
    }

    canvas.drawPath(path, paint);

    // Add subtle shadow
    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
