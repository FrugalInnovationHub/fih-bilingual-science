import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/translation_service.dart';
import '../services/progress_service.dart';

class CompostScreen extends StatefulWidget {
  const CompostScreen({super.key});

  @override
  State<CompostScreen> createState() => _CompostScreenState();
}

class _CompostScreenState extends State<CompostScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TranslationService _translationService = TranslationService();

  void _navigateToDetailScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompostDetailScreen(pageIndex: index),
      ),
    ).then((_) {
      setState(() {}); // Trigger rebuild when returning from detail screen
    });
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int index,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => _navigateToDetailScreen(index),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                _translationService.translate(title),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'ComicNeue',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _translationService.translate(subtitle),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'ComicNeue',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _translationService.translate('Composting 🌱'),
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
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: Colors.green.shade900,
            ),
            onPressed: () {
              _translationService.toggleLanguage();
              setState(() {}); // Force rebuild of the entire screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 40.0,
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildCard(
                            context,
                            title: "What is Composting?",
                            subtitle: "Learn about composting in a fun way! 🌟",
                            icon: Icons.eco_outlined,
                            color: Colors.green,
                            index: 0,
                          ),
                          _buildCard(
                            context,
                            title: "What Can Be Composted?",
                            subtitle: "Discover compostable items! 🔍",
                            icon: Icons.category_outlined,
                            color: Colors.brown,
                            index: 1,
                          ),
                          _buildCard(
                            context,
                            title: "Why Should We Compost?",
                            subtitle: "Meet Wally the Worm! 🐛",
                            icon: Icons.eco_outlined,
                            color: Colors.orange,
                            index: 2,
                          ),
                          _buildCard(
                            context,
                            title: "Compost Quiz",
                            subtitle: "Test your knowledge! 🎯",
                            icon: Icons.quiz_outlined,
                            color: Colors.purple,
                            index: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompostDetailScreen extends StatefulWidget {
  final int pageIndex;

  const CompostDetailScreen({super.key, required this.pageIndex});

  @override
  State<CompostDetailScreen> createState() => _CompostDetailScreenState();
}

class _CompostDetailScreenState extends State<CompostDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isSpeaking = false;

  late final PageController pageController;
  late final ValueNotifier<int> currentPageNotifier;
  final TranslationService _translationService = TranslationService();

  final List<Map<String, dynamic>> compostableItems = [
    {
      'name': 'Fruit and Vegetable Scraps',
      'image': 'assets/tidytown/images/compost/CompostLearning1.png',
      'isCompostable': true,
      'story':
          "Wheee! I'm a banana peel and I love joining my veggie and fruit friends in the compost pot! Together, we turn into super soil that helps new plants grow. Composting is our happy dance for the Earth!",
    },
    {
      'name': 'Coffee Grounds',
      'image': 'assets/tidytown/images/compost/CompostLearning2.png',
      'isCompostable': true,
      'story':
          "Hey there! I'm coffee grounds, and I'm not just for making you energetic! I'm full of nitrogen that makes worms dance with joy!",
    },
    {
      'name': 'Eggshells',
      'image': 'assets/tidytown/images/compost/CompostLearning3.png',
      'isCompostable': true,
      'story':
          "Crack! I'm an eggshell, and I'm not just a breakfast leftover! I add calcium to the soil, making plants grow as strong as superheroes!",
    },
    {
      'name': 'Yard Trimmings',
      'image': 'assets/tidytown/images/compost/CompostLearning4.png',
      'isCompostable': true,
      'story':
          "Yo! I'm yard trimmings, and I'm not just garden waste! I'm like a cozy blanket for worms and a buffet for helpful bacteria! ",
    },
    {
      'name': 'Plastic Bags',
      'image': 'assets/tidytown/images/compost/CompostLearning5.png',
      'isCompostable': false,
      'story':
          "Oops! I'm a plastic bag, and I'm not compostable! I'm like a party crasher at the compost party - I just don't belong here!",
    },
    {
      'name': 'Meat and Dairy',
      'image': 'assets/tidytown/images/compost/CompostLearning6.png',
      'isCompostable': false,
      'story':
          "Hey! I'm meat and dairy, and I'm not compostable! I'm like a stinky guest that nobody wants at the compost party!",
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupTts();
    _setupAudio();
    pageController = PageController();
    currentPageNotifier = ValueNotifier<int>(0);

    // Add completion handler for TTS
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage(
      _translationService.isSpanish ? 'es-ES' : 'en-US',
    );
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _setupAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    flutterTts.stop();
    audioPlayer.dispose();
    pageController.dispose();
    currentPageNotifier.dispose();
    super.dispose();
  }

  Widget _buildGradientButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B3B2B), Color(0xFF7B4B35)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 35,
            color: const Color.fromARGB(255, 255, 250, 250),
          ),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    Widget content;

    switch (widget.pageIndex) {
      case 0:
        title = "What is Composting?";
        content = _buildWhatIsCompostingContent();
        break;
      case 1:
        title = "What Can Be Composted?";
        content = _buildWhatCanBeCompostedContent();
        break;
      case 2:
        title = "Why Should We Compost?";
        content = _buildWhyCompostContent();
        break;
      case 3:
        title = "Compost Quiz";
        content = _buildCompostQuizContent();
        break;
      default:
        title = "Composting";
        content = const Center(child: Text("Content not found"));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _translationService.translate(title),
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 117, 113, 113),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: Color.fromARGB(255, 117, 113, 113),
            ),
            onPressed: () {
              _translationService.toggleLanguage();
              setState(() {});
            },
          ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildWhatIsCompostingContent() {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/tidytown/images/compost/whatisc.gif',
            fit: BoxFit.cover,
          ),
        ),
        // Content in white paper
        Positioned(
          top: 200,
          left: 80,
          right: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                _translationService.translate(
                  "Hi! I'm Captain Compost! Composting is like making a special recipe for the Earth! We take food scraps and yard waste and turn them into rich soil that helps plants grow. It's like magic that helps our Earth stay healthy and happy!",
                ),
                style: const TextStyle(
                  fontSize: 39,
                  height: 1.5,
                  fontFamily: 'ComicNeue',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Menu buttons at bottom
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGradientButton(
                icon: Icons.person,
                onPressed: () => _showLogoutDialog(),
              ),
              _buildGradientButton(
                icon: Icons.home,
                onPressed: () => Navigator.pop(context),
              ),
              _buildGradientButton(icon: Icons.settings, onPressed: () {}),
              _buildGradientButton(
                icon: isSpeaking ? Icons.stop : Icons.volume_up,
                onPressed: () async {
                  if (isSpeaking) {
                    await flutterTts.stop();
                    setState(() {
                      isSpeaking = false;
                    });
                  } else {
                    String text = _translationService.translate(
                      "Hi! I'm Captain Compost! Composting is like making a special recipe for the Earth! We take food scraps and yard waste and turn them into rich soil that helps plants grow. It's like magic that helps our Earth stay healthy and happy! 🌍✨",
                    );
                    await flutterTts.speak(text);
                    setState(() {
                      isSpeaking = true;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhatCanBeCompostedContent() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/tidytown/images/recycle/whatcanbe.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: compostableItems.length,
                    onPageChanged: (index) {
                      currentPageNotifier.value = index;
                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 180),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: SizedBox(
                              height: 350,
                              child: Image.asset(
                                compostableItems[index]['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _translationService.translate(
                                    compostableItems[index]['name'],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'ComicNeue',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () async {
                                    String story =
                                        _translationService.translate(
                                      compostableItems[index]['story'],
                                    );
                                    if (isSpeaking) {
                                      await flutterTts.stop();
                                      setState(() {
                                        isSpeaking = false;
                                      });
                                    } else {
                                      await flutterTts.speak(story);
                                      setState(() {
                                        isSpeaking = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.green.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isSpeaking
                                              ? Icons.stop
                                              : Icons.volume_up,
                                          color: Colors.green.shade700,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _translationService.translate(
                                            isSpeaking
                                                ? 'Stop Story'
                                                : 'Tap to hear my story!',
                                          ),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'ComicNeue',
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
                // Page Indicator
                ValueListenableBuilder<int>(
                  valueListenable: currentPageNotifier,
                  builder: (context, currentPage, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(compostableItems.length, (
                          index,
                        ) {
                          return Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPage == index
                                  ? Colors.green.shade700
                                  : Colors.green.shade200,
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
                // Navigation Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 20,
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: currentPageNotifier,
                    builder: (context, currentPage, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: currentPage > 0
                                ? () {
                                    pageController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,
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
                            onPressed: currentPage < compostableItems.length - 1
                                ? () {
                                    pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: Text(_translationService.translate('Next')),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildWhyCompostContent() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/tidytown/images/recycle/learning.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      _translationService.translate(
                        "Choose a story to learn why composting is important!",
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                        color: Colors.black,
                        letterSpacing: 1.2,
                        height: 1.5,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Color.fromRGBO(255, 255, 255, 0.7),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Story Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildStoryCard(
                          title: "Wally the Worm's Adventure",
                          icon: Icons.eco,
                          colors: [
                            Colors.green.shade300,
                            Colors.green.shade600,
                          ],
                          onTap: () => _showWallyStory(),
                        ),
                        const SizedBox(height: 30),
                        _buildStoryCard(
                          title: "The Magic Garden",
                          icon: Icons.forest,
                          colors: [
                            Colors.brown.shade300,
                            Colors.brown.shade600,
                          ],
                          onTap: () => _showMagicGardenStory(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompostQuizContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(80),
      child: Column(
        children: [
          Text(
            _translationService.translate(
              "Tap the items that can be composted!",
            ),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: compostableItems.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () async {
                    final isCorrect = compostableItems[index]['isCompostable'];

                    // Get current progress
                    int currentProgress = await ProgressService.getProgress(
                      'Compost',
                    );

                    if (isCorrect) {
                      // Only increment progress if answer is correct and item hasn't been correctly identified before
                      if (currentProgress < index + 1) {
                        await ProgressService.updateProgress(
                          'Compost',
                          index + 1,
                        );
                      }
                    }

                    // Show feedback
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _translationService.translate(
                            isCorrect
                                ? "Yes! This can be composted! ⭐"
                                : "Oops! This cannot be composted. Try again! 💫",
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        backgroundColor:
                            isCorrect ? Colors.green : Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );

                    // If all compostable items have been correctly identified
                    if (isCorrect && currentProgress < index + 1) {
                      int totalCompostableItems = compostableItems
                          .where((item) => item['isCompostable'])
                          .length;
                      int newProgress = await ProgressService.getProgress(
                        'Compost',
                      );

                      if (newProgress >= totalCompostableItems) {
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('🎉 Congratulations! 🎉'),
                            content: Text(
                              _translationService.translate(
                                'You\'ve successfully identified all compostable items!',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  _translationService.translate('Continue'),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            compostableItems[index]['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _translationService.translate(
                            compostableItems[index]['name'],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard({
    required String title,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  _translationService.translate(title),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWallyStory() {
    // Implement Wally's story dialog
  }

  void _showMagicGardenStory() {
    // Implement Magic Garden story dialog
  }

  void _showLogoutDialog() {
    // Implement logout dialog
  }

  Future<void> _speakLines(int pageIndex) async {
    // Implement text-to-speech functionality
  }
}
