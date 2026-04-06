import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/level_data.dart';
import '../utils/app_localizations.dart';
import '../utils/game_enums.dart';
import 'game_screen.dart';

class PathwayScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;
  final AgeGroup ageGroup;
  final MeasurementSystem system;
  
  const PathwayScreen({
    super.key, 
    this.onLanguageChanged, 
    required this.ageGroup,
    required this.system,
  });

  @override
  State<PathwayScreen> createState() => _PathwayScreenState();
}

class _PathwayScreenState extends State<PathwayScreen> with SingleTickerProviderStateMixin {
  int _unlockedLevel = 1; 
  late List<Offset> _levelPositions;
  late final AnimationController _mascotController;
  
  // Track progress: LevelID -> {learn: bool, game: bool}
  final Map<int, Map<String, bool>> _levelProgress = {};

  @override
  void initState() {
    super.initState();
    _mascotController = AnimationController(
      vsync: this,
      duration: 2.seconds,
    )..repeat(reverse: true);

    // Initialize unlocked level to the first level of this age group
    final levels = LevelData.getLevels(age: widget.ageGroup, system: widget.system);
    if (levels.isNotEmpty) {
      _unlockedLevel = levels.first.id;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate positions based on screen width to center the path
    final width = MediaQuery.of(context).size.width;
    final centerX = width / 2;
    // greater amplitude for zigzag
    final offset = width * 0.25; 
    
    // Filter levels for this age group and system
    final levels = LevelData.getLevels(age: widget.ageGroup, system: widget.system);
    final int totalLevels = levels.length;
    _levelPositions = [];
    
    // Dynamic generation of zigzag path
    for (int i = 0; i < totalLevels; i++) {
        double dx;
        if (i == 0) dx = centerX;
        else if (i % 2 != 0) dx = centerX - offset; // Odd = Left
        else dx = centerX + offset; // Even = Right
        
        // Vertical spacing
        double dy = 100.0 + (i * 180.0);
        
        _levelPositions.add(Offset(dx, dy));
    }
    
    // Safety check
    if (_levelPositions.isEmpty) {
        _levelPositions = [Offset(centerX, 100)];
    }
  }

  @override
  void dispose() {
    _mascotController.dispose();
    super.dispose();
  }

  Color _getWorldColor() {
    switch (widget.ageGroup) {
      case AgeGroup.earlyLearners:
        return const Color(0xFF4CAF50); // Green
      case AgeGroup.foundationLearners:
        return const Color(0xFF2196F3); // Blue
      case AgeGroup.advancedLearners:
        return const Color(0xFF673AB7); // Purple
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currentWorldColor = _getWorldColor();
    final levels = LevelData.getLevels(age: widget.ageGroup, system: widget.system);

    return Scaffold(
      body: AnimatedContainer(
        duration: 1.seconds,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              currentWorldColor.withOpacity(0.8),
              currentWorldColor,
              currentWorldColor.withBlue(255).withOpacity(0.9), // Slight variation
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(localizations, levels),
              Expanded(
                child: _buildMap(localizations, levels),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, List<Level> levels) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              _getCurrentWorldTitle(localizations, levels),
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(offset: const Offset(2, 2), blurRadius: 4, color: Colors.black26),
                ],
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  String _getCurrentWorldTitle(AppLocalizations localizations, List<Level> levels) {
      // Just take the first level's world title since we grouped them
      if (levels.isEmpty) return 'Adventure';
      final lang = localizations.isEnglish ? 'en' : 'es';
      return levels.first.getWorldTitle(lang);
  }

  IconData _getIconForLevel(String emoji) {
    switch (emoji) {
      case '🐜': return Icons.bug_report;
      case '🐞': return Icons.pest_control;
      case '🧸': return Icons.smart_toy;
      case '📏': return Icons.straighten;
      case '🌳': return Icons.park;
      case '🌲': return Icons.forest;
      case '🌻': return Icons.local_florist;
      case '🦊': return Icons.pets;
      case '🧪': return Icons.science;
      case '🚀': return Icons.rocket_launch;
      case '🪐': return Icons.public;
      case '🌍': return Icons.public;
      case '🎓': return Icons.school;
      case '⚖️': return Icons.balance; // Scale
      case '🪣': return Icons.water; // Bucket
      case '☀️': return Icons.wb_sunny;
      case '🔥': return Icons.local_fire_department;
      case '🥛': return Icons.coffee;
      case '💰': return Icons.monetization_on;
      case '⬛': return Icons.crop_square;
      case '🚧': return Icons.fence;
      case '🏎️': return Icons.directions_car;
      case '🌡️': return Icons.thermostat;
      case '📊': return Icons.bar_chart;
      default: return Icons.star;
    }
  }

  Widget _buildMascot(Offset position) {
    return Positioned(
      left: position.dx - 40, 
      top: position.dy - 100, 
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _mascotController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -10 * _mascotController.value),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Text(
                      'GO!', 
                      style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.orange),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipPath(
                    clipper: _TriangleClipper(),
                    child: Container(color: Colors.white, width: 10, height: 8),
                  ),
                  const Icon(Icons.pets, size: 60, color: Colors.orange), 
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLevelNode(Level level, bool isUnlocked, bool isNext) {
    final lang = AppLocalizations.of(context).isEnglish ? 'en' : 'es';
    return GestureDetector(
      onTap: isUnlocked ? () => _startLevel(level) : null,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: isNext ? Colors.yellow : Colors.white, 
                width: isNext ? 6 : 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isNext ? Colors.yellow : Colors.black).withOpacity(0.3), 
                  blurRadius: 15, 
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: isUnlocked 
                ? Icon(_getIconForLevel(level.icon), size: 45, color: _getWorldColor())
                : const Icon(Icons.lock, size: 40, color: Colors.grey),
            ),
          ).animate(target: isNext ? 1.0 : 0.0)
           .shimmer(duration: 2.seconds)
           .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1.seconds, curve: Curves.easeInOut),
          
          const SizedBox(height: 10),
          SizedBox(
            width: 120,
            child: Text(
              level.getTitle(lang),
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
              ),
            ),
            ),

          
          // Progress Indicators
          if (isUnlocked)
             Padding(
               padding: const EdgeInsets.only(top: 4),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   // Learn Indicator
                   if (_levelProgress[level.id]?['learn'] == true)
                     const Icon(Icons.menu_book, size: 16, color: Colors.blueAccent)
                   else
                     const Icon(Icons.check_box_outline_blank, size: 16, color: Colors.white30),
                     
                   const SizedBox(width: 4),
                   
                   // Game Indicator
                   if (_levelProgress[level.id]?['game'] == true)
                     const Icon(Icons.sports_esports, size: 16, color: Colors.orangeAccent)
                   else
                     const Icon(Icons.check_box_outline_blank, size: 16, color: Colors.white30),
                 ],
               ),
             ),
          
          if (_levelProgress[level.id]?['learn'] == true && _levelProgress[level.id]?['game'] == true)
              Container(
                 margin: const EdgeInsets.only(top: 4),
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                 decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(10)),
                 child: const Text("MASTERED", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
              ).animate().shimmer(duration: 2.seconds),
        ],
      ),
    );
  }

  void _startLevel(Level level) async {
    // Navigate to GameScreen and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(levelId: level.id),
      ),
    );

    // If level returned valid result
    if (result != null && result is Map) {
       final bool learnDone = result['learn'] ?? false;
       final bool gameDone = result['game'] ?? false;
       
       setState(() {
         // Update progress
         _levelProgress[level.id] = {'learn': learnDone, 'game': gameDone};
         
         // Unlock next level logic: simplified for now, any completion unlocks next
         if (learnDone || gameDone) { // Relaxed to OR for easier progress
            // Find current index
            final levels = LevelData.getLevels(age: widget.ageGroup, system: widget.system);
            final currentIndex = levels.indexWhere((l) => l.id == level.id);
            if (currentIndex >= 0 && currentIndex < levels.length - 1) {
              final nextLevel = levels[currentIndex + 1];
              if (nextLevel.id > _unlockedLevel) {
                 _unlockedLevel = nextLevel.id;
              }
            }
         }
       });
    }
  }
      
  Widget _buildMap(AppLocalizations localizations, List<Level> levels) {
    final lang = localizations.isEnglish ? 'en' : 'es';
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // World indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🌎 ', style: TextStyle(fontSize: 24)),
                  Text(
                    _getCurrentWorldTitle(localizations, levels),
                    style: GoogleFonts.fredoka(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Map Area
            SizedBox(
              height: _levelPositions.isNotEmpty ? _levelPositions.last.dy + 150 : 300,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background Decorations
                  CustomPaint(
                    size: Size(double.infinity, _levelPositions.isNotEmpty ? _levelPositions.last.dy + 150 : 300),
                    painter: MapBackgroundPainter(),
                  ),

                  // Connecting path
                  if (_levelPositions.isNotEmpty)
                  CustomPaint(
                    size: Size(double.infinity, _levelPositions.last.dy + 150),
                    painter: MapPathPainter(
                      levelPositions: _levelPositions,
                      unlockedLevel: _unlockedLevel,
                    ),
                  ),
                  
                  // Level Nodes
                  ...levels.asMap().entries.map((entry) {
                    final index = entry.key;
                    final level = entry.value;
                    if (index >= _levelPositions.length) return const SizedBox();
                    final position = _levelPositions[index];
                    final isUnlocked = level.id <= _unlockedLevel;
                    // Logic for "Next" is simpler: it's the unlocked level
                    final isNext = level.id == _unlockedLevel; 
                    
                    return Positioned(
                      left: position.dx - 45,
                      top: position.dy - 45,
                      child: _buildLevelNode(level, isUnlocked, isNext),
                    );
                  }).toList(),
                  
                  // Progress Mascot
                  if (_unlockedLevel > 0 && levels.isNotEmpty && _levelPositions.isNotEmpty)
                    Builder(
                      builder: (context) {
                        try {
                           // Find index of unlocked level
                           final index = levels.indexWhere((l) => l.id == _unlockedLevel);
                           if (index != -1 && index < _levelPositions.length) {
                             return _buildMascot(_levelPositions[index]);
                           }
                        } catch(e) {}
                        return const SizedBox();
                      }
                    ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class MapPathPainter extends CustomPainter {
  final List<Offset> levelPositions;
  final int unlockedLevel;

  MapPathPainter({required this.levelPositions, required this.unlockedLevel});

  @override
  void paint(Canvas canvas, Size size) {
    if (levelPositions.length < 2) return;

    final path = Path();
    path.moveTo(levelPositions[0].dx, levelPositions[0].dy);

    for (int i = 0; i < levelPositions.length - 1; i++) {
        final p1 = levelPositions[i];
        final p2 = levelPositions[i + 1];
        
        final cp1 = Offset(p1.dx, p1.dy + 80);
        final cp2 = Offset(p2.dx, p2.dy - 80);
        
        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, borderPaint);

    final roadPaint = Paint()
      ..color = const Color(0xFFD7CCC8) // Light brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, roadPaint);

    final innerRoadPaint = Paint()
      ..color = const Color(0xFFEFEBE9) // Lighter brown center
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, innerRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawTrees(canvas, size, 0, size.height * 0.35, const Color(0xFF2E7D32)); 
    _drawClouds(canvas, size, size.height * 0.35, size.height * 0.7);
    _drawStars(canvas, size, size.height * 0.7, size.height);
  }

  void _drawTrees(Canvas canvas, Size size, double startY, double endY, Color color) {
    final paint = Paint()..color = color.withOpacity(0.4);
    final treePositions = [
      Offset(size.width * 0.1, startY + 50),
      Offset(size.width * 0.8, startY + 100),
      Offset(size.width * 0.2, startY + 200),
      Offset(size.width * 0.85, startY + 300),
      Offset(size.width * 0.15, startY + 450),
    ];

    for (var pos in treePositions) {
     if (pos.dy < endY) {
        final path = Path();
        path.moveTo(pos.dx, pos.dy - 40);
        path.lineTo(pos.dx - 25, pos.dy);
        path.lineTo(pos.dx + 25, pos.dy);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawClouds(Canvas canvas, Size size, double startY, double endY) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);
    final cloudPositions = [
      Offset(size.width * 0.8, startY + 50),
      Offset(size.width * 0.2, startY + 150),
      Offset(size.width * 0.7, startY + 280),
    ];

    for (var pos in cloudPositions) {
       if (pos.dy < endY) {
        canvas.drawCircle(pos, 30, paint);
        canvas.drawCircle(Offset(pos.dx + 25, pos.dy + 5), 35, paint);
        canvas.drawCircle(Offset(pos.dx - 20, pos.dy + 10), 25, paint);
      }
    }
  }

  void _drawStars(Canvas canvas, Size size, double startY, double endY) {
    final paint = Paint()..color = Colors.white.withOpacity(0.6);
    final starPositions = [
       Offset(size.width * 0.1, startY + 40),
       Offset(size.width * 0.5, startY + 80),
       Offset(size.width * 0.9, startY + 150),
       Offset(size.width * 0.3, startY + 220),
       Offset(size.width * 0.7, startY + 300),
    ];

    for (var pos in starPositions) {
      if (pos.dy < endY) {
        canvas.drawCircle(pos, 3, paint);
      }
    }
    
    final planetPaint = Paint()..color = Colors.purpleAccent.withOpacity(0.3);
    canvas.drawCircle(Offset(size.width * 0.8, startY + 180), 30, planetPaint);
    final ringPaint = Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * 0.8, startY + 180), width: 80, height: 20), ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
