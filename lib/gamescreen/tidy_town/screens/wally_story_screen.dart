import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/translation_service.dart';

class WallyStoryScreen extends StatefulWidget {
  final TranslationService translationService;

  const WallyStoryScreen({super.key, required this.translationService});

  @override
  State<WallyStoryScreen> createState() => _WallyStoryScreenState();
}

class _WallyStoryScreenState extends State<WallyStoryScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  int currentPage = 0;
  int conversationsPerPage = 2;
  Map<String, String> wallyVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> mayaVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> binVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> robotVoice = {'name': 'default', 'locale': 'en-US'};
  bool isPlaying = false;
  late final TranslationService _translationService;

  final List<String> storyContent = [
    "I was once shiny and full of fresh water. But now? I lay crumpled under a park bench, forgotten.",
    "I wish I had a purpose again...",
    "Suddenly, a little girl named Maya picked me up!",
    "Don't worry, Wally! You're going in the recycling bin!",
    "I was nervous... What's going to happen to me?",
    "You'll see—it's the beginning of something amazing!",
    "At the recycling center, I met tons of new friends—Cans, newspapers, yogurt cups, even a cereal box!",
    "We were all getting sorted on loud conveyor belts.",
    "Plastic over here! called a robotic arm, scooping me up.",
    "I got cleaned, squished, melted, and stretched! At first, it tickled.",
    "I felt different. I'm... I'm not a bottle anymore!",
    "I had become a part of a shiny new backpack!",
    "Maya wore the new backpack to school proudly.",
    "Recycling gives things like Wally a second chance, I told my class.",
    "And I? I beamed with joy. I'm back in the world—better and braver than ever!",
  ];

  final List<String> moralContent = [
    "Even the smallest items we recycle can become something awesome again!",
    "Recycling gives second chances—to the Earth and everything on it",
  ];

  final List<String> speakers = [
    "wally",
    "wally",
    "wally",
    "maya",
    "wally",
    "bin",
    "wally",
    "wally",
    "robot",
    "wally",
    "wally",
    "wally",
    "narrator",
    "maya",
    "wally",
  ];

  final List<String> moralSpeakers = ["narrator", "narrator"];

  @override
  void initState() {
    super.initState();
    _translationService = widget.translationService;
    _setupTts();
  }

  @override
  void didUpdateWidget(WallyStoryScreen oldWidget) {
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
      // Look for a friendly male voice for Wally
      final wallyVoiceData = voices.firstWhere(
        (voice) =>
            voice.name.toLowerCase().contains('male') ||
            voice.name.toLowerCase().contains('man') ||
            voice.name.toLowerCase().contains('michael') ||
            voice.name.toLowerCase().contains('daniel'),
        orElse: () => voices.first,
      );
      wallyVoice = {
        'name': wallyVoiceData.name,
        'locale': wallyVoiceData.locale,
      };
      await flutterTts.setPitch(0.9);
      await flutterTts.setSpeechRate(0.2);

      // Look for a child-like voice for Maya
      final mayaVoiceData = voices.firstWhere(
        (voice) =>
            voice.name.toLowerCase().contains('child') ||
            voice.name.toLowerCase().contains('kid') ||
            voice.name.toLowerCase().contains('samantha'),
        orElse: () => voices.first,
      );
      mayaVoice = {'name': mayaVoiceData.name, 'locale': mayaVoiceData.locale};
      await flutterTts.setPitch(1.2);
      await flutterTts.setSpeechRate(0.1);

      // Look for a deep voice for the bin
      final binVoiceData = voices.firstWhere(
        (voice) =>
            voice.name.toLowerCase().contains('male') ||
            voice.name.toLowerCase().contains('man') ||
            voice.name.toLowerCase().contains('david'),
        orElse: () => voices.first,
      );
      binVoice = {'name': binVoiceData.name, 'locale': binVoiceData.locale};
      await flutterTts.setPitch(0.7);
      await flutterTts.setSpeechRate(0.2);

      // Look for a robotic voice for the robot
      final robotVoiceData = voices.firstWhere(
        (voice) =>
            voice.name.toLowerCase().contains('male') ||
            voice.name.toLowerCase().contains('man'),
        orElse: () => voices.first,
      );
      robotVoice = {
        'name': robotVoiceData.name,
        'locale': robotVoiceData.locale,
      };
      await flutterTts.setPitch(0.1);
      await flutterTts.setSpeechRate(0.5);
    }
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

    final isMoralPage =
        currentPage >= (storyContent.length / conversationsPerPage).ceil();
    final linesToSpeak = isMoralPage ? moralContent : storyContent;
    final speakersForLines = isMoralPage ? moralSpeakers : speakers;
    final currentStartIndex = isMoralPage ? 0 : startIndex;

    String lastSpeaker = "";
    for (
      int i = currentStartIndex;
      i <
              (isMoralPage
                  ? moralContent.length
                  : currentStartIndex + conversationsPerPage) &&
          i < linesToSpeak.length;
      i++
    ) {
      if (!isPlaying) break;

      final line = linesToSpeak[i];
      final speaker = speakersForLines[i];
      final translatedLine = _translationService.translate(line);

      if (lastSpeaker != "" && lastSpeaker != speaker) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      if (speaker == "wally") {
        await flutterTts.setVoice(wallyVoice);
        await flutterTts.setPitch(0.7); // male voice
        await flutterTts.setSpeechRate(
          0.1,
        ); // Slightly faster for more natural speaking pace
        await flutterTts.speak(translatedLine);
      } else if (speaker == "maya") {
        await flutterTts.setVoice(mayaVoice);
        await flutterTts.setPitch(1.8); // Higher pitch for small girl voice
        await flutterTts.setSpeechRate(
          0.15,
        ); // Slightly faster but still child-like
        await flutterTts.speak(translatedLine);
      } else if (speaker == "bin") {
        await flutterTts.setVoice(binVoice);
        await flutterTts.setPitch(0.5); // Lower pitch for male voice
        await flutterTts.setSpeechRate(
          0.15,
        ); // Slightly slower for natural male speech
        await flutterTts.speak(translatedLine);
      } else if (speaker == "robot") {
        // Create robotic effect by breaking speech into segments
        await flutterTts.setVoice(robotVoice);
        final words = translatedLine.split(' ');
        for (final word in words) {
          if (!isPlaying) break;
          await flutterTts.setPitch(0.1);
          await flutterTts.setSpeechRate(1.5);
          await flutterTts.speak(word);
          await Future.delayed(const Duration(milliseconds: 200));
        }
      } else if (speaker == "narrator") {
        await flutterTts.setVoice({
          'name': 'default',
          'locale': _translationService.isSpanish ? 'es-ES' : 'en-US',
        });
        await flutterTts.setPitch(0.8);
        await flutterTts.setSpeechRate(0.2);
        await flutterTts.speak(translatedLine);
      }

      final length = translatedLine.length;
      final basePause = 2000;
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
      currentPage < ((storyContent.length - 1) / conversationsPerPage).ceil();
  bool get hasPreviousPage => currentPage > 0;

  @override
  Widget build(BuildContext context) {
    final isMoralPage =
        currentPage >= (storyContent.length / conversationsPerPage).ceil();
    final currentLines = isMoralPage ? moralContent : getCurrentPageLines();
    final isFirstPage = currentPage == 0;
    final isSecondPage = currentPage == 1;
    final isThirdPage = currentPage == 2;
    final isFourthPage = currentPage == 3;
    final isFifthPage = currentPage == 4;
    final isSixthPage = currentPage == 5;
    final isSeventhPage = currentPage == 6;
    final isEighthPage = currentPage == 7;

    return WillPopScope(
      onWillPop: () async {
        await flutterTts.stop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isMoralPage
                ? _translationService.translate("Moral of the Story")
                : _translationService.translate(
                    "Wally the Water Bottle's Second Chance",
                  ),
            style: const TextStyle(
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue.shade100,
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
                color: Colors.blue.shade900,
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
              if (isFirstPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/wally1.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSecondPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/wally2.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isThirdPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/wally3.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isFourthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/wally4.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isFifthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/wally5.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSixthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/wally6.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSeventhPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/wally7.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isEighthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/wally8.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isMoralPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/tidytown/images/recycle/moral.png',
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentLines.length,
                        itemBuilder: (context, index) {
                          final speaker = isMoralPage
                              ? moralSpeakers[index]
                              : speakers[currentPage * conversationsPerPage +
                                    index];
                          final line = currentLines[index];
                          final isWally = speaker == "wally";
                          final isMaya = speaker == "maya";
                          final isBin = speaker == "bin";
                          final isRobot = speaker == "robot";
                          final isNarrator = speaker == "narrator";

                          return Align(
                            alignment: isNarrator
                                ? Alignment.center
                                : (isWally
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: isNarrator
                                    ? MediaQuery.of(context).size.width * 0.9
                                    : MediaQuery.of(context).size.width * 0.75,
                              ),
                              margin: EdgeInsets.only(
                                bottom: 30,
                                left: isWally ? 0 : 40,
                                right: isWally ? 40 : 0,
                                top: index == 0 ? 20 : 0,
                              ),
                              child: isNarrator
                                  ? Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200.withOpacity(
                                          0.9,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        _translationService.translate(line),
                                        style: TextStyle(
                                          fontSize: isMoralPage ? 32 : 24,
                                          fontFamily: 'ComicNeue',
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          height: 1.5,
                                          color: isMoralPage
                                              ? Colors.black87
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : CustomPaint(
                                      painter: CloudBubblePainter(
                                        color: isWally
                                            ? Colors.blue.shade50.withOpacity(
                                                0.95,
                                              )
                                            : isMaya
                                            ? Colors.pink.shade50.withOpacity(
                                                0.95,
                                              )
                                            : isBin
                                            ? Colors.grey.shade50.withOpacity(
                                                0.95,
                                              )
                                            : isRobot
                                            ? Colors.cyan.shade50.withOpacity(
                                                0.95,
                                              )
                                            : Colors.green.shade50.withOpacity(
                                                0.95,
                                              ),
                                        isLeftAligned: isWally,
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
                                backgroundColor: Colors.blue.shade300,
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
                            onPressed: () => _speakLines(
                              isMoralPage
                                  ? 0
                                  : currentPage * conversationsPerPage,
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
                              backgroundColor: isPlaying
                                  ? Colors.red.shade300
                                  : Colors.blue.shade300,
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
                          if (hasNextPage || !isMoralPage)
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
                                backgroundColor: Colors.blue.shade300,
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
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final radius = 20.0;

    path.moveTo(radius, 0);
    path.quadraticBezierTo(size.width / 4, -10, size.width / 2, 0);
    path.quadraticBezierTo(size.width * 3 / 4, 10, size.width - radius, 0);
    path.quadraticBezierTo(
      size.width + 5,
      size.height / 3,
      size.width - radius,
      size.height - radius,
    );
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
    path.quadraticBezierTo(-5, size.height / 3, radius, 0);

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

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
