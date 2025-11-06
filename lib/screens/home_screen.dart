import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

import 'package:supersetfirebase/services/firestore_score.dart';
import 'package:supersetfirebase/provider/user_pin_provider.dart';
import '../gamescreen/tidy_town/wrapper.dart';
import '../gamescreen/bioapp/wrapper.dart';
import '../gamescreen/colortheory_wrapper.dart';

// import 'package:supersetfirebase/services/test_score.dart';
class HomeScreen extends StatefulWidget {
  final String pin;

  const HomeScreen({required this.pin, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _wallpaperController;
  late Animation<double> _wallpaperAnimation;
  Timer? _wallpaperTimer;
  int _currentWallpaperIndex = 0;

  int totalScore = 0;
  final FirestoreService _scoreService = FirestoreService();
  Timer? scoreUpdateTimer;

  // Animation controllers for tile hover effects
  late List<AnimationController> _tileControllers;
  late List<Animation<double>> _tileScaleAnimations;
  late List<Animation<double>> _tileElevationAnimations;

  // Auto-scroll controller
  late ScrollController _scrollController;
  Timer? _autoScrollTimer;

  final List<String> _backgroundImages = [
    "assets/images/wallpapers/wallpaper1.png",
    "assets/images/wallpapers/wallpaper2.png",
    "assets/images/wallpapers/wallpaper3.png",
    "assets/images/wallpapers/wallpaper4.png",
  ];

  @override
  void initState() {
    super.initState();

    // Set PIN in provider when HomeScreen loads
    Provider.of<UserPinProvider>(context, listen: false).setPin(widget.pin);

    _wallpaperController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _wallpaperAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _wallpaperController,
      curve: Curves.easeInOut,
    ));

    // Initialize tile animations
    _tileControllers = List.generate(
      games.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _tileScaleAnimations = _tileControllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    _tileElevationAnimations = _tileControllers.map((controller) {
      return Tween<double>(
        begin: 6.0,
        end: 12.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // Initialize scroll controller
    _scrollController = ScrollController();

    // Auto-scroll disabled - only manual scrolling
    // _startAutoScroll();

    _startWallpaperRotation();
    refreshTotalScore();

    // Automatically update score every minute
    scoreUpdateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      refreshTotalScore();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      refreshTotalScore();
    });
  }

  @override
  void dispose() {
    _wallpaperController.dispose();
    _wallpaperTimer?.cancel();
    scoreUpdateTimer?.cancel();
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    // Dispose tile controllers
    for (var controller in _tileControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void refreshTotalScore() async {
    final scores = await _scoreService.getUserScores(widget.pin);
    setState(() {
      totalScore = scores['TotalBestScore'] ?? 0;
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + 220, // Move by one tile width + margin
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startWallpaperRotation() {
    _wallpaperTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _changeWallpaper();
    });
  }

  void _changeWallpaper() {
    if (mounted) {
      setState(() {
        _currentWallpaperIndex =
            (_currentWallpaperIndex + 1) % _backgroundImages.length;
      });
      _wallpaperController.forward().then((_) {
        _wallpaperController.reset();
      });
    }
  }

  void _setWallpaper(int index) {
    if (mounted && index != _currentWallpaperIndex) {
      setState(() {
        _currentWallpaperIndex = index;
      });
      _wallpaperController.forward().then((_) {
        _wallpaperController.reset();
      });
      _wallpaperTimer?.cancel();
      _startWallpaperRotation();
    }
  }

  final List<Map<String, dynamic>> games = [
    {
      'title': 'Tidy Town',
      'backgroundImage': 'assets/images/icon1.png',
      'description': 'Fun with Lab!',
      'icon': Icons.calculate,
      'route': (String pin) => TidyTownWrapper(userPin: pin),
    },
    {
      'title': 'Color Theory',
      'backgroundImage': 'assets/images/icon2.png',
      'description': 'Master Chemistry!',
      'icon': Icons.functions,
      'route': (String pin) => ColorTheoryWrapper(userPin: pin),
    },
    {
      'title': 'Bio App',
      'backgroundImage': 'assets/images/icon3.png',
      'description': 'Learn new compounds & more!',
      'icon': Icons.show_chart,
      'route': (String pin) => BioAppWrapper(userPin: pin),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Text(
                  'Score: $totalScore',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Galindo',
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: refreshTotalScore,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
            child: GestureDetector(
              onTap: () async {
                // Clear saved PIN from SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('user_pin');

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Rotating Background Wallpapers
          AnimatedSwitcher(
            duration: Duration(milliseconds: 800),
            child: Container(
              key: ValueKey(_currentWallpaperIndex),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Fallback color
                image: DecorationImage(
                  image: AssetImage(_backgroundImages[_currentWallpaperIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.pin)
                        .get(),
                    builder: (context, snapshot) {
                      String displayName = widget.pin;
                      if (snapshot.hasData && snapshot.data != null) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        if (data != null &&
                            data['name'] != null &&
                            data['name'].toString().isNotEmpty) {
                          displayName = data['name'];
                        }
                      }
                      return Text(
                        "Hi, $displayName!",
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Honk-Regular-VariableFont_MORF,SHLN',
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                  // Horizontal scrolling tiles with original size
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double maxWidth = constraints.maxWidth;
                      double tileSize = maxWidth > 1000
                          ? maxWidth / 4 - 20
                          : maxWidth > 800
                              ? maxWidth / 3 - 20
                              : maxWidth > 500
                                  ? maxWidth / 2 - 20
                                  : maxWidth - 40;

                      return SizedBox(
                        height: tileSize + 120, // Original height + text space
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: games.length *
                              1000, // Infinite scroll by repeating 1000 times
                          itemBuilder: (context, index) {
                            final game = games[
                                index % games.length]; // Use modulo to repeat
                            return Container(
                              width: tileSize + 20, // Original width + margin
                              margin: const EdgeInsets.only(right: 20),
                              child: MouseRegion(
                                cursor: game['route'] != null
                                    ? SystemMouseCursors.click
                                    : SystemMouseCursors.basic,
                                onEnter: (_) {
                                  _tileControllers[index % games.length]
                                      .forward();
                                },
                                onExit: (_) {
                                  _tileControllers[index % games.length]
                                      .reverse();
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    if (game['route'] != null) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              game['route'](widget.pin),
                                        ),
                                      );
                                      refreshTotalScore();
                                    }
                                  },
                                  child: AnimatedBuilder(
                                    animation:
                                        _tileControllers[index % games.length],
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _tileScaleAnimations[
                                                index % games.length]
                                            .value,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: tileSize,
                                              height: tileSize,
                                              alignment: Alignment.center,
                                              child: Container(
                                                width: tileSize * 0.9,
                                                height: tileSize * 0.9,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(game[
                                                        'backgroundImage']),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius:
                                                          _tileElevationAnimations[
                                                                  index %
                                                                      games
                                                                          .length]
                                                              .value,
                                                      offset: Offset(
                                                          0,
                                                          _tileElevationAnimations[
                                                                      index %
                                                                          games
                                                                              .length]
                                                                  .value /
                                                              2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              game['title'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
