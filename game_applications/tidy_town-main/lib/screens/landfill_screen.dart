import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/translation_service.dart';
import '../services/progress_service.dart';

class LandfillScreen extends StatefulWidget {
  const LandfillScreen({super.key});

  @override
  State<LandfillScreen> createState() => _LandfillScreenState();
}

class _LandfillScreenState extends State<LandfillScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TranslationService _translationService = TranslationService();

  void _navigateToDetailScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandfillDetailScreen(pageIndex: index),
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
          _translationService.translate('Landfill Education 🏭'),
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: Colors.grey.shade900,
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
                            title: "What is a Landfill?",
                            subtitle: "Learn about landfills! 🌟",
                            icon: Icons.delete_outline,
                            color: Colors.grey,
                            index: 0,
                          ),
                          _buildCard(
                            context,
                            title: "What Goes to Landfill?",
                            subtitle: "Discover landfill items! 🔍",
                            icon: Icons.category_outlined,
                            color: Colors.brown,
                            index: 1,
                          ),
                          _buildCard(
                            context,
                            title: "Why Reduce Landfill?",
                            subtitle: "Meet Larry the Landfill! 🏭",
                            icon: Icons.eco_outlined,
                            color: Colors.orange,
                            index: 2,
                          ),
                          _buildCard(
                            context,
                            title: "Landfill Quiz",
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

class LandfillDetailScreen extends StatefulWidget {
  final int pageIndex;

  const LandfillDetailScreen({super.key, required this.pageIndex});

  @override
  State<LandfillDetailScreen> createState() => _LandfillDetailScreenState();
}

class _LandfillDetailScreenState extends State<LandfillDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isSpeaking = false;

  late final PageController pageController;
  late final ValueNotifier<int> currentPageNotifier;
  final TranslationService _translationService = TranslationService();

  final List<Map<String, dynamic>> landfillItems = [
    {
      'name': 'Plastic Bags',
      'image': 'assets/tidytown/images/landfill/LandfillLearning1.png',
      'isLandfill': true,
      'story':
          "Hi! I'm a plastic bag, and I'm one of the biggest problems in landfills! I take hundreds of years to break down and can harm wildlife. Please reuse me or use cloth bags instead! 🛍️",
    },
    {
      'name': 'Styrofoam',
      'image': 'assets/tidytown/images/landfill/LandfillLearning2.png',
      'isLandfill': true,
      'story':
          "Hey there! I'm Styrofoam, and I'm not biodegradable! I take up lots of space in landfills and can break into tiny pieces that harm animals. Try to avoid using me! 🚫",
    },
    {
      'name': 'Batteries',
      'image': 'assets/tidytown/images/landfill/LandfillLearning3.png',
      'isLandfill': true,
      'story':
          "Zap! I'm a battery, and I'm dangerous in landfills! I can leak harmful chemicals. Please recycle me at special collection points! 🔋",
    },
    {
      'name': 'Food Waste',
      'image': 'assets/tidytown/images/landfill/LandfillLearning4.png',
      'isLandfill': false,
      'story':
          "Yum! I'm food waste, and I don't belong in landfills! I can be composted to make rich soil for plants! 🍎",
    },
    {
      'name': 'Paper',
      'image': 'assets/tidytown/images/landfill/LandfillLearning5.png',
      'isLandfill': false,
      'story':
          "Hi! I'm paper, and I can be recycled many times! Please put me in the recycling bin instead of the landfill! 📄",
    },
    {
      'name': 'Glass',
      'image': 'assets/tidytown/images/landfill/LandfillLearning6.png',
      'isLandfill': false,
      'story':
          "Clink! I'm glass, and I can be recycled forever! Please recycle me instead of sending me to the landfill! 🍶",
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupTts();
    _setupAudio();
    pageController = PageController();
    currentPageNotifier = ValueNotifier<int>(0);

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
        title = "What is a Landfill?";
        content = _buildWhatIsLandfillContent();
        break;
      case 1:
        title = "What Goes to Landfill?";
        content = _buildWhatGoesToLandfillContent();
        break;
      case 2:
        title = "Why Reduce Landfill?";
        content = _buildWhyReduceLandfillContent();
        break;
      case 3:
        title = "Landfill Quiz";
        content = _buildLandfillQuizContent();
        break;
      default:
        title = "Landfill";
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
            color: Color.fromARGB(255, 73, 72, 72),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: Color.fromARGB(255, 73, 72, 72),
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

  Widget _buildWhatIsLandfillContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/tidytown/images/landfill/whatisl.gif',
            fit: BoxFit.cover,
          ),
        ),
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
                  "Hi! I'm Larry the Landfill! A landfill is a place where our trash goes when it can't be recycled or composted. But landfills can be harmful to our environment, so it's important to reduce, reuse, and recycle!",
                ),
                style: const TextStyle(
                  fontSize: 39,
                  height: 1.5,
                  fontFamily: 'ComicNeue',
                  color: Color.fromARGB(255, 250, 249, 249),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
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
                      "Hi! I'm Larry the Landfill! A landfill is a place where our trash goes when it can't be recycled or composted. But landfills can be harmful to our environment, so it's important to reduce, reuse, and recycle! 🌍",
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

  Widget _buildWhatGoesToLandfillContent() {
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
                    itemCount: landfillItems.length,
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
                              child: GestureDetector(
                                onTap: () async {
                                  String itemName = _translationService
                                      .translate(landfillItems[index]['name']);
                                  if (isSpeaking) {
                                    await flutterTts.stop();
                                    setState(() {
                                      isSpeaking = false;
                                    });
                                  } else {
                                    await flutterTts.speak('I am $itemName');
                                    setState(() {
                                      isSpeaking = true;
                                    });
                                  }
                                },
                                child: Image.asset(
                                  landfillItems[index]['image'],
                                  fit: BoxFit.contain,
                                ),
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
                                    landfillItems[index]['name'],
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
                                    String story = _translationService
                                        .translate(
                                          landfillItems[index]['story'],
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
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
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
                                          color: Colors.grey.shade700,
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
                                            color: Colors.grey.shade700,
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
                ValueListenableBuilder<int>(
                  valueListenable: currentPageNotifier,
                  builder: (context, currentPage, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(landfillItems.length, (index) {
                          return Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  currentPage == index
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade200,
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
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
                            onPressed:
                                currentPage > 0
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
                              backgroundColor: const Color.fromARGB(
                                255,
                                62,
                                61,
                                61,
                              ),
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
                                currentPage < landfillItems.length - 1
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
                              backgroundColor: Colors.grey.shade300,
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
            // Bottom volume button
            Positioned(
              bottom: 20,
              right: 20,
              child: ValueListenableBuilder<int>(
                valueListenable: currentPageNotifier,
                builder: (context, currentPage, _) {
                  return _buildGradientButton(
                    icon: isSpeaking ? Icons.stop : Icons.volume_up,
                    onPressed: () async {
                      if (isSpeaking) {
                        await flutterTts.stop();
                        setState(() {
                          isSpeaking = false;
                        });
                      } else {
                        String itemName = _translationService.translate(
                          landfillItems[currentPage]['name'],
                        );
                        await flutterTts.speak('I am $itemName');
                        setState(() {
                          isSpeaking = true;
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWhyReduceLandfillContent() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/tidytown/images/recycle/learning.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      _translationService.translate(
                        "Choose a story to learn why reducing landfill waste is important!",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildStoryCard(
                          title: "Larry's Landfill Adventure",
                          icon: Icons.delete_outline,
                          colors: [Colors.grey.shade300, Colors.grey.shade600],
                          onTap: () => _showLarryStory(),
                        ),
                        const SizedBox(height: 30),
                        _buildStoryCard(
                          title: "The Recycling Heroes",
                          icon: Icons.recycling,
                          colors: [Colors.blue.shade300, Colors.blue.shade600],
                          onTap: () => _showRecyclingHeroesStory(),
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

  Widget _buildLandfillQuizContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            _translationService.translate(
              "Tap the items that should go to landfill!",
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
            itemCount: landfillItems.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () async {
                    final isCorrect = landfillItems[index]['isLandfill'];

                    int currentProgress = await ProgressService.getProgress(
                      'Landfill',
                    );

                    if (isCorrect) {
                      if (currentProgress < index + 1) {
                        await ProgressService.updateProgress(
                          'Landfill',
                          index + 1,
                        );
                      }
                    }

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _translationService.translate(
                            isCorrect
                                ? "Yes! This should go to landfill! ⭐"
                                : "Oops! This can be recycled or composted! 💫",
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        backgroundColor:
                            isCorrect ? Colors.grey : Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );

                    if (isCorrect && currentProgress < index + 1) {
                      int totalLandfillItems =
                          landfillItems
                              .where((item) => item['isLandfill'])
                              .length;
                      int newProgress = await ProgressService.getProgress(
                        'Landfill',
                      );

                      if (newProgress >= totalLandfillItems) {
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('🎉 Congratulations! 🎉'),
                                content: Text(
                                  _translationService.translate(
                                    'You\'ve successfully identified all landfill items!',
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
                            landfillItems[index]['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _translationService.translate(
                            landfillItems[index]['name'],
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

  void _showLarryStory() {
    // Implement Larry's story dialog
  }

  void _showRecyclingHeroesStory() {
    // Implement Recycling Heroes story dialog
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_translationService.translate('😢 Logout?')),
          content: Text(
            _translationService.translate(
              'Hey Western! Are you sure you want to logout?',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(_translationService.translate('Cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(_translationService.translate('Logout')),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/'); // Back to welcome
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _speakLines(int pageIndex) async {
    // Implement text-to-speech functionality
  }
}
