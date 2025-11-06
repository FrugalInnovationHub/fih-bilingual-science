import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class BeachWasteSortingGame extends StatefulWidget {
  const BeachWasteSortingGame({super.key});

  @override
  State<BeachWasteSortingGame> createState() => _BeachWasteSortingGameState();
}

class _BeachWasteSortingGameState extends State<BeachWasteSortingGame>
    with TickerProviderStateMixin {
  FlutterTts _tts = FlutterTts();
  int score = 0;
  int currentItemIndex = 0;
  bool isGameComplete = false;
  bool showFeedback = false;
  bool isCorrectAnswer = false;
  bool showCelebration = false;
  bool showSad = false;
  String? poppingMessage;
  String? sadMessage;
  late final AnimationController _celebrationController;
  late final AnimationController _shakeController;

  // Beach waste items using your actual beach-specific images
  final List<Map<String, dynamic>> beachItems = [
    // Compost items (3 beach-specific items)
    {
      'name': 'Fresh Seaweed',
      'image': 'assets/tidytown/images/compost/fresh_seaweed.png',
      'correctBin': 'compost',
      'description':
          'I\'m natural seaweed that washed ashore! Alex knows I can decompose naturally and become rich soil for plants.',
    },
    {
      'name': 'Driftwood',
      'image': 'assets/tidytown/images/compost/driftwood.png',
      'correctBin': 'compost',
      'description':
          'I\'m natural driftwood that floated to the beach! Alex picked me up because I can break down and enrich the earth.',
    },
    {
      'name': 'Coconut Shells',
      'image': 'assets/tidytown/images/compost/coconut_shells.png',
      'correctBin': 'compost',
      'description':
          'I\'m coconut shells that fell naturally on the beach! Alex knows I can decompose and feed the soil with nutrients.',
    },

    // Recycle items (4 beach-specific items)
    {
      'name': 'Ocean Plastic Bottles',
      'image': 'assets/tidytown/images/recycle/ocean_plastic_bottles.png',
      'correctBin': 'recycle',
      'description':
          'Alex rescued me from the ocean waves! I was threatening sea turtles who might mistake me for food. I can be made into new products!',
    },
    {
      'name': 'Beach Cans',
      'image': 'assets/tidytown/images/recycle/beach_cans.png',
      'correctBin': 'recycle',
      'description':
          'I\'m aluminum cans left by beach visitors! Alex picked me up because I can be recycled into new cans forever.',
    },
    {
      'name': 'Glass Bottles',
      'image': 'assets/tidytown/images/recycle/glass_bottles.png',
      'correctBin': 'recycle',
      'description':
          'Alex found me buried in the beach sand! I\'m glass bottles that can be melted down and made into new glass products.',
    },

    // Landfill items (5 beach-specific items)
    {
      'name': 'Dangerous Plastic Bags',
      'image': 'assets/tidytown/images/landfill/dangerous_plastic_bags.png',
      'correctBin': 'landfill',
      'description':
          'I\'m torn plastic bags that could harm sea turtles who mistake me for jellyfish! Alex wants to dispose of me safely.',
    },
    {
      'name': 'Waterlogged Papers',
      'image': 'assets/tidytown/images/landfill/waterlogged_papers.png',
      'correctBin': 'landfill',
      'description':
          'I\'m papers that got soaked by seawater! Alex knows I\'m too damaged to recycle and need special disposal.',
    },
    {
      'name': 'Styrofoam Containers',
      'image': 'assets/tidytown/images/landfill/styrofoam_containers.png',
      'correctBin': 'landfill',
      'description':
          'I\'m styrofoam food containers left by beachgoers! Alex picked me up because I don\'t break down naturally.',
    },
    {
      'name': 'Broken Flip Flops',
      'image': 'assets/tidytown/images/landfill/broken_flip_flops.png',
      'correctBin': 'landfill',
      'description':
          'I\'m old flip flops that washed up on shore! Alex found me and knows I need to go to landfill safely.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _speakWelcomeMessage();
    // Randomize item order each session
    beachItems.shuffle();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> _initializeTts() async {
    _tts = FlutterTts();
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.35);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      try {
        await _tts.awaitSpeakCompletion(true);
      } catch (_) {}
    } catch (e) {
      print('Error initializing TTS: $e');
    }
  }

  void _speakWelcomeMessage() {
    _speakText("");
  }

  Future<void> _speakText(String text) async {
    try {
      await _tts.speak(text);
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  void _handleAnswer(String selectedBin) {
    final currentItem = beachItems[currentItemIndex];
    final correctBin = currentItem['correctBin'];

    setState(() {
      showFeedback = true;
      isCorrectAnswer = selectedBin == correctBin;
      if (isCorrectAnswer) {
        score++;
        showCelebration = true;
        poppingMessage = 'Hurray right!';
        _celebrationController.forward(from: 0.0);
      } else {
        showSad = true;
        sadMessage = 'Oops wrong!!';
        _shakeController.forward(from: 0.0);
      }
    });

    // Play sound and speak feedback
    if (isCorrectAnswer) {
      SystemSound.play(SystemSoundType.click);
      _speakText('That\'s right!');
    } else {
      SystemSound.play(SystemSoundType.alert);
      _speakText('Oops wrong!');
    }

    // Move to next item after feedback
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        showFeedback = false;
        showCelebration = false;
        showSad = false;
        poppingMessage = null;
        sadMessage = null;
        currentItemIndex++;

        if (currentItemIndex >= beachItems.length) {
          isGameComplete = true;
          _showCompletionDialog();
        }
      });
    });
  }

  void _showCompletionDialog() {
    _speakText("");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🏖️ Beach Cleanup Complete!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/tidytown/images/beach_alex_happy.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.sentiment_very_satisfied,
                    size: 60,
                    color: Colors.green,
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Amazing! You helped Alex clean up the beach!\n\nScore: $score/${beachItems.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to game selection
              },
              child: const Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Back to Games'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _celebrationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isGameComplete) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentItem = beachItems[currentItemIndex];
    // Bin images and order (match original game sizes/logic)
    final binImages = {
      'compost': 'assets/tidytown/images/game/bin_green.png',
      'recycle': 'assets/tidytown/images/game/bin_yellow.png',
      'landfill': 'assets/tidytown/images/game/bin_red.png',
    };
    final binOrder = ['compost', 'recycle', 'landfill'];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              // Beach background image covering full screen
              image: DecorationImage(
                image: AssetImage('assets/tidytown/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              // Semi-transparent overlay for better text readability
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.cyan.withOpacity(0.1),
                    Colors.blue.withOpacity(0.2),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Top bar with score and progress
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Back button
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.3),
                            ),
                          ),
                          const Spacer(),
                          // Score
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Score: $score/${beachItems.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Progress indicator
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: LinearProgressIndicator(
                        value: currentItemIndex / beachItems.length,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                        minHeight: 6,
                      ),
                    ),

                    // Main game area - Alex on left, item on right
                    Expanded(
                      child: Row(
                        children: [
                          // Left side - Alex character
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Alex image
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          showFeedback
                                              ? (isCorrectAnswer
                                                  ? 'assets/tidytown/images/beach_alex_happy.png'
                                                  : 'assets/tidytown/images/beach_alex_sad.png')
                                              : 'assets/tidytown/images/beach_alex_neutral.png',
                                          fit: BoxFit.contain,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: showFeedback
                                                    ? (isCorrectAnswer
                                                        ? Colors.green
                                                        : Colors.orange)
                                                    : Colors.cyan,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Icon(
                                                showFeedback
                                                    ? (isCorrectAnswer
                                                        ? Icons
                                                            .sentiment_very_satisfied
                                                        : Icons
                                                            .sentiment_dissatisfied)
                                                    : Icons.person,
                                                size: 80,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Alex's speech bubble
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.95),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      showFeedback
                                          ? (isCorrectAnswer
                                              ? "Hurray right! That's exactly where it belongs!"
                                              : "Sorry it is wrong! But don't worry, let's try the next one!")
                                          : "Guess this one! Help me sort this item I found on the beach!",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Right side - Current item
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Item image (Draggable)
                                    Expanded(
                                      flex: 4,
                                      child: Draggable<Map<String, dynamic>>(
                                        data: currentItem,
                                        dragAnchorStrategy:
                                            pointerDragAnchorStrategy,
                                        feedback: Material(
                                          elevation: 4,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Image.asset(
                                                currentItem['image'],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        childWhenDragging: Opacity(
                                          opacity: 0.3,
                                          child: Container(
                                            width: 320,
                                            height: 320,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Image.asset(
                                                currentItem['image'],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          width: 320,
                                          height: 320,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.asset(
                                              currentItem['image'],
                                              fit: BoxFit.contain,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.eco,
                                                      size: 60,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      currentItem['name'],
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Item name
                                    Text(
                                      currentItem['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    // No extra content below: removed description and feedback block
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom - Three bins as DragTargets (match original sizes)
                    if (!showFeedback) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: binOrder.map((binType) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                ),
                                child: DragTarget<Map<String, dynamic>>(
                                  builder: (
                                    context,
                                    candidateItems,
                                    rejectedItems,
                                  ) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          binImages[binType]!,
                                          width: 250,
                                          height: 380,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          binType == 'recycle'
                                              ? 'Recycle'
                                              : binType == 'compost'
                                                  ? 'Compost'
                                                  : 'Landfill',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  onWillAccept: (item) => true,
                                  onAccept: (item) {
                                    // Delegate scoring and progression to _handleAnswer
                                    _handleAnswer(binType);
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // Fullscreen celebration overlay
          if (showCelebration && poppingMessage != null)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Cheering animation
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
                      // Alex happy + popping message
                      AnimatedScale(
                        scale: showCelebration ? 1.2 : 0.0,
                        duration: const Duration(milliseconds: 8000),
                        curve: Curves.elasticOut,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Alex happy image
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                'assets/tidytown/images/beach_alex_happy.png',
                                width: 380,
                                height: 380,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Message
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade400.withOpacity(0.95),
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
                                'Hurray right!',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Fullscreen sad overlay
          if (showSad && sadMessage != null)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.red.shade400.withOpacity(0.95),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Alex sad image
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/tidytown/images/beach_alex_sad.png',
                          width: 380,
                          height: 380,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Sad animation
                      Lottie.asset(
                        'assets/tidytown/animations/sad.json',
                        width: 300,
                        height: 300,
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
