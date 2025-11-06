import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../services/translation_service.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:lottie/lottie.dart';

abstract class BaseWasteSortingGame extends StatefulWidget {
  const BaseWasteSortingGame({super.key});
}

abstract class BaseWasteSortingGameState<T extends BaseWasteSortingGame>
    extends State<T> with TickerProviderStateMixin {
  late FlutterTts _tts;
  final TranslationService _translationService = TranslationService();
  int score = 0;
  int totalItems = 0;
  bool isGameComplete = false;
  bool showCelebration = false;
  bool showSad = false;
  String? poppingMessage;
  String? sadMessage;
  late final AnimationController _celebrationController;
  late final AnimationController _shakeController;
  late final AnimationController _currentItemController;

  // Track which items have been correctly sorted
  final Set<String> correctlySortedItems = {};

  // Abstract methods to be implemented by each theme
  String get gameTitle;
  String get welcomeMessage;
  List<Map<String, dynamic>> get wasteItems;
  Map<String, String> get binImages;
  List<String> get binOrder;
  Color get primaryColor;
  Color get secondaryColor;
  List<Color> get backgroundGradient;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    totalItems = wasteItems.length;
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _currentItemController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _currentItemController.forward();
    // Play welcome instructions
    _playWelcomeInstructions();
  }

  Future<void> _initializeTts() async {
    _tts = FlutterTts();
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      print('TTS initialized successfully');
    } catch (e) {
      print('Error initializing TTS: $e');
    }
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _shakeController.dispose();
    _currentItemController.dispose();
    super.dispose();
  }

  void _checkGameCompletion() {
    if (correctlySortedItems.length == totalItems) {
      setState(() {
        isGameComplete = true;
      });
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'You\'ve successfully sorted all the waste items!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score/$totalItems',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back to Home'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                score = 0;
                isGameComplete = false;
                correctlySortedItems.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _showCelebrationAnimation() async {
    setState(() {
      showCelebration = true;
      poppingMessage = 'Correct!';
    });
    _celebrationController.forward(from: 0.0);
    await SystemSound.play(SystemSoundType.click);
    await _tts.setLanguage('en-US');
    await _tts.speak('Correct!');
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      showCelebration = false;
      poppingMessage = null;
    });
  }

  void _showSadAnimation() async {
    setState(() {
      showSad = true;
      sadMessage = 'Oops wrong!!';
    });
    _shakeController.forward(from: 0.0);
    await SystemSound.play(SystemSoundType.alert);
    await _tts.setLanguage('en-US');
    await _tts.speak('Oops wrong!!');
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      showSad = false;
      sadMessage = null;
    });
  }

  void _showFeedback(bool isCorrect, String description) {
    if (isCorrect) {
      _showCelebrationAnimation();
    } else {
      _showSadAnimation();
    }
  }

  void _speakItemName(String itemName) async {
    try {
      await _tts.speak('I am $itemName');
      print('Speaking: I am $itemName');
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  Future<void> _playWelcomeInstructions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _speakText(welcomeMessage);
  }

  Future<void> _speakText(String text) async {
    try {
      await _tts.speak(text);
    } catch (e) {
      // Error speaking text
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show unsorted items
    final unsortedItems = wasteItems
        .where((item) => !correctlySortedItems.contains(item['name']))
        .toList();
    final currentItem = unsortedItems.isNotEmpty ? unsortedItems.first : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _translationService.translate(gameTitle),
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor.withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: primaryColor.withOpacity(0.8),
            ),
            onPressed: () {
              _translationService.toggleLanguage();
              setState(() {});
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: backgroundGradient,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 100),
                // Show only one draggable item at a time
                if (currentItem != null)
                  Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 3000),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: AnimatedBuilder(
                        key: ValueKey(currentItem['name']),
                        animation: _shakeController,
                        builder: (context, child) {
                          double offset = 0;
                          if (showSad) {
                            offset = 10 *
                                (1 - _shakeController.value) *
                                (math.sin(
                                  _shakeController.value * 10 * math.pi,
                                ));
                          }
                          return Transform.translate(
                            offset: Offset(offset, 0),
                            child: child,
                          );
                        },
                        child: Draggable<Map<String, dynamic>>(
                          data: currentItem,
                          feedback: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: 320,
                              height: 320,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Image.asset(
                                currentItem['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: Container(
                              width: 320,
                              height: 320,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey.shade200,
                              ),
                              child: Image.asset(
                                currentItem['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              _speakItemName(currentItem['name']);
                            },
                            child: Container(
                              width: 320,
                              height: 320,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                currentItem['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (currentItem == null)
                  const Center(
                    child: Text(
                      'All items sorted! 🎉',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                  ),
                const Spacer(),
                // Row of bins
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: binOrder.map((binType) {
                      return DragTarget<Map<String, dynamic>>(
                        builder: (context, candidateItems, rejectedItems) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Larger bin image, no border or box
                              Image.asset(
                                binImages[binType]!,
                                width: 250,
                                height: 380,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _translationService.translate(
                                  binType == 'recycle'
                                      ? 'Recycle'
                                      : binType == 'compost'
                                          ? 'Compost'
                                          : 'Landfill',
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicNeue',
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          );
                        },
                        onWillAccept: (item) => true,
                        onAccept: (item) {
                          if (!correctlySortedItems.contains(
                            item['name'],
                          )) {
                            if (item['correctBin'] == binType) {
                              // Correct answer: increment score and move to next item
                              setState(() {
                                score++;
                                correctlySortedItems.add(item['name']);
                              });
                              _showFeedback(true, item['description']);
                            } else {
                              // Wrong answer: don't increment score but still move to next item
                              setState(() {
                                correctlySortedItems.add(item['name']);
                              });
                              _showFeedback(false, item['description']);
                            }
                            _checkGameCompletion();
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
                // Score and reset
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _translationService.translate(
                          'Score: $score/$totalItems',
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            score = 0;
                            isGameComplete = false;
                            correctlySortedItems.clear();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(_translationService.translate('Reset')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Fullscreen celebration overlay
          if (showCelebration && poppingMessage != null)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedScale(
                        scale: showCelebration ? 1.2 : 0.0,
                        duration: const Duration(milliseconds: 8000),
                        curve: Curves.elasticOut,
                        child: SizedBox.expand(
                          child: Lottie.asset(
                            'assets/tidytown/animations/confetti.json',
                            fit: BoxFit.cover,
                            repeat: false,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      AnimatedScale(
                        scale: showCelebration ? 1.2 : 0.0,
                        duration: const Duration(milliseconds: 8000),
                        curve: Curves.elasticOut,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Correct!',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'ComicNeue',
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Fullscreen sad overlay
          if (showSad && sadMessage != null)
            Positioned.fill(
              child: Container(
                color: Colors.red.shade400.withOpacity(0.95),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/tidytown/animations/sad.json',
                        width: 380,
                        height: 380,
                        fit: BoxFit.contain,
                        repeat: false,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Oops wrong!!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'ComicNeue',
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
