import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import '../provider/language_provider.dart';
import '../widgets/language_toggle.dart';

import 'package:supersetfirebase/services/firestore_score.dart';
import 'package:supersetfirebase/provider/user_pin_provider.dart';
import '../gamescreen/tidy_town/wrapper.dart';
import '../gamescreen/bioapp/wrapper.dart';
import '../gamescreen/colortheory_wrapper.dart';
import '../gamescreen/solar_explora_wrapper.dart';
import '../gamescreen/measurements_wrapper.dart';
import '../gamescreen/safe_water_heroes_wrapper.dart';

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

  // Page controller for carousel
  late PageController _pageController;
  int _currentPage = 0;

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

    // Initialize page controller for carousel
    _pageController = PageController(
      viewportFraction: 0.35,
      initialPage:
          (games.length * 1000) ~/ 2, // Start in the middle for infinite scroll
    );

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
    _pageController.dispose();
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
    {
      'title': 'Solar Explora',
      'backgroundImage': 'assets/images/icon4.png',
      'description': 'Explore the Solar System!',
      'icon': Icons.rocket_launch,
      'route': (String pin) => SolarExploraWrapper(userPin: pin),
    },
    {
      'title': 'Measurements',
      'backgroundImage': 'assets/images/icon5.png',
      'description': 'Learn Measurements!',
      'icon': Icons.straighten,
      'route': (String pin) => MeasurementsWrapper(userPin: pin),
    },
    {
      'title': 'Safe Water Heroes',
      'backgroundImage': 'assets/images/icon6.png',
      'description': 'Become a Safe Water Hero!',
      'icon': Icons.water_drop,
      'route': (String pin) => SafeWaterHeroesWrapper(userPin: pin),
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
        leading: Container(
          margin: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: GestureDetector(
            onTap: () async {
              // Clear saved PIN and timestamp from SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_pin');
              await prefs.remove('user_pin_timestamp');

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            child: Container(
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
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
                size: 28,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
            child: const LanguageToggle(),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: FutureBuilder<DocumentSnapshot>(
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
                        return Consumer<LanguageProvider>(
                          builder: (context, languageProvider, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${languageProvider.translate('Hi')} $displayName",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 62,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        'Honk-Regular-VariableFont_MORF,SHLN',
                                    color: Colors.red,
                                  ),
                                ),
                                const Text(
                                  " | ",
                                  style: TextStyle(
                                    fontSize: 48,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${languageProvider.translate('Score')}: $totalScore',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Galindo',
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: refreshTotalScore,
                                  child: const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Carousel with centered large tile and smaller side tiles
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double maxWidth = constraints.maxWidth;
                      double centerTileSize = maxWidth > 1000
                          ? maxWidth * 0.35
                          : maxWidth > 800
                              ? maxWidth * 0.4
                              : maxWidth > 500
                                  ? maxWidth * 0.45
                                  : maxWidth * 0.5;

                      return SizedBox(
                        height: centerTileSize +
                            120, // Height for center tile + text
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index % games.length;
                            });
                          },
                          itemCount: games.length * 1000, // Infinite scroll
                          itemBuilder: (context, index) {
                            final gameIndex = index % games.length;
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double value = 1.0;
                                double scale = 1.0;

                                if (_pageController.position.haveDimensions) {
                                  value = (_pageController.page! - index);
                                  double absValue = value.abs();
                                  value =
                                      (1 - (absValue * 0.9)).clamp(0.5, 1.0);
                                  scale =
                                      (0.55 + (value * 0.45)).clamp(0.55, 1.0);
                                } else {
                                  // Initial state: show first tile as center, others as side tiles
                                  if (gameIndex == 0) {
                                    scale = 1.0;
                                    value = 1.0;
                                  } else {
                                    scale = 0.55;
                                    value = 0.5;
                                  }
                                }

                                final game = games[gameIndex];
                                final isCenter = scale >=
                                    0.95; // Consider center if scale is close to 1.0

                                return Center(
                                  child: Transform.scale(
                                    scale: scale,
                                    child: Opacity(
                                      opacity: value.clamp(0.5, 1.0),
                                      child: MouseRegion(
                                        cursor: game['route'] != null
                                            ? SystemMouseCursors.click
                                            : SystemMouseCursors.basic,
                                        onEnter: (_) {
                                          _tileControllers[gameIndex].forward();
                                        },
                                        onExit: (_) {
                                          _tileControllers[gameIndex].reverse();
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
                                                _tileControllers[gameIndex],
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scale: _tileScaleAnimations[
                                                        gameIndex]
                                                    .value,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: centerTileSize,
                                                      height: centerTileSize,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        width: centerTileSize *
                                                            0.9,
                                                        height: centerTileSize *
                                                            0.9,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(game[
                                                                'backgroundImage']),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              blurRadius:
                                                                  _tileElevationAnimations[
                                                                          gameIndex]
                                                                      .value,
                                                              offset: Offset(
                                                                  0,
                                                                  _tileElevationAnimations[
                                                                              gameIndex]
                                                                          .value /
                                                                      2),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if (isCenter) ...[
                                                      const SizedBox(
                                                          height: 10),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.2),
                                                              blurRadius: 4,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          game['title'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
