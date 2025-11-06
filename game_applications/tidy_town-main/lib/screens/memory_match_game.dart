import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class MemoryMatchGame extends StatefulWidget {
  const MemoryMatchGame({super.key});

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame>
    with TickerProviderStateMixin {
  late FlutterTts _tts;
  int score = 0;
  int moves = 0;
  bool isGameComplete = false;
  bool showCelebration = false;
  String? celebrationMessage;
  late final AnimationController _celebrationController;
  late final AnimationController _flipController;

  // Game cards data
  final List<Map<String, dynamic>> gameCards = [
    {
      'id': 'plastic_bottle',
      'image': 'assets/tidytown/images/game/plastic_bottle.png',
      'bin': 'recycle',
      'binColor': Colors.blue,
      'binIcon': Icons.recycling,
    },
    {
      'id': 'apple_core',
      'image': 'assets/tidytown/images/game/apple_core.png',
      'bin': 'compost',
      'binColor': Colors.green,
      'binIcon': Icons.eco,
    },
    {
      'id': 'newspaper',
      'image': 'assets/tidytown/images/game/newspaper.png',
      'bin': 'recycle',
      'binColor': Colors.blue,
      'binIcon': Icons.recycling,
    },
    {
      'id': 'broken_glass',
      'image': 'assets/tidytown/images/game/broken_glass.png',
      'bin': 'landfill',
      'binColor': Colors.grey,
      'binIcon': Icons.delete_outline,
    },
    {
      'id': 'banana_peel',
      'image': 'assets/tidytown/images/game/banana_peel.png',
      'bin': 'compost',
      'binColor': Colors.green,
      'binIcon': Icons.eco,
    },
    {
      'id': 'plastic_bag',
      'image': 'assets/tidytown/images/game/plastic_bag.png',
      'bin': 'landfill',
      'binColor': Colors.grey,
      'binIcon': Icons.delete_outline,
    },
    {
      'id': 'aluminum_can',
      'image': 'assets/tidytown/images/game/aluminum_can.png',
      'bin': 'recycle',
      'binColor': Colors.blue,
      'binIcon': Icons.recycling,
    },
    {
      'id': 'coffee_grounds',
      'image': 'assets/tidytown/images/game/coffee_grounds.png',
      'bin': 'compost',
      'binColor': Colors.green,
      'binIcon': Icons.eco,
    },
  ];

  List<Map<String, dynamic>> shuffledCards = [];
  List<int> flippedCards = [];
  List<int> matchedCards = [];
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _initializeGame();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
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
      // TTS initialized successfully
    } catch (e) {
      // Error initializing TTS
    }
  }

  void _initializeGame() {
    // Create pairs of cards
    List<Map<String, dynamic>> cardPairs = [];
    for (var card in gameCards) {
      cardPairs.add(Map<String, dynamic>.from(card));
      cardPairs.add(Map<String, dynamic>.from(card));
    }

    // Shuffle the cards
    shuffledCards = List.from(cardPairs);
    shuffledCards.shuffle();

    flippedCards.clear();
    matchedCards.clear();
    score = 0;
    moves = 0;
    isGameComplete = false;
    showCelebration = false;
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _onCardTap(int index) {
    if (isProcessing ||
        flippedCards.contains(index) ||
        matchedCards.contains(index)) {
      return;
    }

    setState(() {
      flippedCards.add(index);
      moves++;
    });

    if (flippedCards.length == 2) {
      isProcessing = true;
      _checkMatch();
    }
  }

  void _checkMatch() {
    final firstCard = shuffledCards[flippedCards[0]];
    final secondCard = shuffledCards[flippedCards[1]];

    if (firstCard['id'] == secondCard['id']) {
      // Match found!
      setState(() {
        matchedCards.addAll(flippedCards);
        score++;
        showCelebration = true;
        celebrationMessage =
            'Great match! ${firstCard['id'].replaceAll('_', ' ').toUpperCase()} goes to ${firstCard['bin']}!';
      });

      _speakText(celebrationMessage!);
      _celebrationController.forward().then((_) {
        _celebrationController.reset();
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          flippedCards.clear();
          isProcessing = false;
          showCelebration = false;
        });
        _checkGameCompletion();
      });
    } else {
      // No match - tell player it's wrong (no celebration animation)
      _speakText('Wrong! Try again!');

      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          flippedCards.clear();
          isProcessing = false;
        });
      });
    }
  }

  void _checkGameCompletion() {
    if (matchedCards.length == shuffledCards.length) {
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
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/tidytown/animations/confetti.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '🎉 Congratulations! 🎉',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3728),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You completed the Memory Match Game!\nScore: $score pairs\nMoves: $moves',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4A3728),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _initializeGame();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Play Again'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Home'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _playWelcomeInstructions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _speakText("Welcome to the Memory Match Game!");
    await Future.delayed(const Duration(milliseconds: 1000));
    await _speakText("Match the waste items with their correct disposal bins!");
    await Future.delayed(const Duration(milliseconds: 1000));
    await _speakText("Tap two cards to flip them and find matching pairs!");
  }

  Future<void> _speakText(String text) async {
    try {
      await _tts.speak(text);
    } catch (e) {
      // Error speaking text
    }
  }

  Widget _buildCard(int index) {
    final card = shuffledCards[index];
    final isFlipped = flippedCards.contains(index);
    final isMatched = matchedCards.contains(index);

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color:
                  isFlipped || isMatched
                      ? card['binColor'].withOpacity(0.3)
                      : Colors.white,
              border: Border.all(
                color:
                    isFlipped || isMatched
                        ? card['binColor']
                        : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child:
                isFlipped || isMatched
                    ? Stack(
                      children: [
                        // Full card image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            card['image'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: card['binColor'].withOpacity(0.3),
                                child: Icon(
                                  card['binIcon'],
                                  color: card['binColor'],
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),
                        // Bin type label at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: card['binColor'].withOpacity(0.8),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              card['bin'].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )
                    : const Icon(
                      Icons.help_outline,
                      size: 30,
                      color: Colors.grey,
                    ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Memory Match Game',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeGame,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE1BEE7), Color(0xFFF3E5F5)],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Score and moves display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Score',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A3728),
                            ),
                          ),
                          Text(
                            '$score',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Moves',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A3728),
                            ),
                          ),
                          Text(
                            '$moves',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Game instructions
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: const Text(
                    'Match the waste items with their correct disposal bins!\nTap two cards to flip them and find matching pairs.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A3728),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // Game grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: shuffledCards.length,
                      itemBuilder: (context, index) => _buildCard(index),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Celebration animation
          if (showCelebration)
            Positioned.fill(
              child: Lottie.asset(
                'assets/tidytown/animations/confetti.json',
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
