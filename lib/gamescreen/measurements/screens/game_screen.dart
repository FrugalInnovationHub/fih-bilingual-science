import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:confetti/confetti.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;
import 'dart:async';

import '../utils/app_localizations.dart';
import '../utils/measurement_data.dart';
import '../utils/tts_helper.dart';
import '../utils/level_data.dart';
import '../utils/audio_guard.dart';
import '../widgets/weighing_3d_view.dart';

class GameScreen extends StatefulWidget {
  final String? initialMode;
  final int? levelId;
  final Function(Locale)? onLanguageChanged;
  
  const GameScreen({super.key, this.initialMode, this.levelId, this.onLanguageChanged});


  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  
  String _currentMode = 'learn';
  
  bool _ttsInitialized = false;
  bool _audioUnlocked = false;
  bool _showSoundPrompt = true;
  double? _lastSpokenSliceTarget;
  
  // Game animation controllers
  late AnimationController _characterController;
  late AnimationController _starController;
  late AnimationController _celebrationController;
  late AnimationController _objectFloatController;
  late AnimationController _particleController;
  late Animation<double> _starScale;
  late Animation<double> _celebrationRotation;
  late Animation<double> _floatAnimation;

  // Interactive Lesson State
  int _lessonStep = 0; // 0: Intro, 1: Action (Drag), 2: Success
  bool _lessonComplete = false;
  
  // Slicing Game Animation
  late AnimationController _knifeController;
  double _sliceOffset = 0.0; // Distance the sliced piece moves away
  int _selectedInches = 1;
  String _sliceFeedback = '';
  Color _sliceFeedbackColor = Colors.transparent;
  double _sliceDragAccumulator = 0.0;

  
  // Tape Measure State
  double _currentTapeLength = 50.0; // Starting width (housing only)
  final double _targetTapeLength = 250.0; // Target width to match object
  
  // Catching Game State
  List<ActiveBug> _activeBugs = [];
  Timer? _spawnTimer;
  int _caughtCount = 0;
  
  double _characterProgress = 0.0; // 0.0 to 1.0
  bool _showStar = false;
  bool _isAnimating = false;

  // New Progression State
  bool _learnCompleted = false;
  bool _gameCompleted = false;
  
  // Drag-and-Drop Matching Game state
  final math.Random _random = math.Random();
  List<MeasurementObject> _objects = [];
  List<MeasurementCard> _cards = [];
  MeasurementCard? _draggedCard;
  int _matchesFound = 0;
  int _totalMatches = 0;
  bool _gameComplete = false;
  int _score = 0;
  late ConfettiController _confettiController;

  // Weighing Game state (Ages 3-5)
  List<WeighingItem> _weighingItems = [];
  int _weighingIndex = 0;
  int _weighingSelected = 1;
  String _weighingFeedback = '';
  Color _weighingFeedbackColor = Colors.transparent;
  int _lastSpokenWeighingIndex = -1;

  // Weighing Learn state
  int _weighingLearnIndex = 0;
  int _weighingLearnSelected = 1;
  bool _weighingLearnDone = false;
  String _weighingLearnFeedback = '';
  Color _weighingLearnFeedbackColor = Colors.transparent;
  
  Future<void> _initializeTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _ttsInitialized = true;
    } catch (e) {
      print('TTS initialization error: $e');
      _ttsInitialized = false;
    }
  }
  
  bool _isSpeaking = false;
  
  Future<void> _speak(String text, {String? language, bool interrupt = false}) async {
    if (_isSpeaking && !interrupt) return; // Prevent multiple simultaneous calls
    
    try {
      final normalized = text.toLowerCase();
      final hasNumber = RegExp(r'[0-9]').hasMatch(normalized);
      final hasInchWord = normalized.contains('inch') || normalized.contains('pulgad');
      final hasCmWord = normalized.contains('cm') ||
          normalized.contains('centim') ||
          normalized.contains('centím');
      if (!hasNumber || !(hasInchWord || hasCmWord)) return;
      if (interrupt) {
        _isSpeaking = false;
        try {
          await _flutterTts.stop();
        } catch (e) {
          // Ignore stop errors - TTS is optional
        }
      }
      _isSpeaking = true;
      
      // Try web SpeechSynthesis first (more reliable on web)
      await TtsHelper.speak(text, language: language);
      
      // Wait a bit before allowing next speech
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      // Silently fail - TTS is optional
    } finally {
      _isSpeaking = false;
    }
  }

  Future<void> _speakPlain(String text, {String? language, bool interrupt = false}) async {
    if (_isSpeaking && !interrupt) return;
    try {
      if (interrupt) {
        _isSpeaking = false;
        try {
          await _flutterTts.stop();
        } catch (e) {
          // Ignore stop errors - TTS is optional
        }
      }
      _isSpeaking = true;
      await TtsHelper.speak(text, language: language);
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      // Silently fail - TTS is optional
    } finally {
      _isSpeaking = false;
    }
  }

  Future<void> _unlockAudio() async {
    if (_audioUnlocked) return;
    _audioUnlocked = true;
    _showSoundPrompt = false;
    try {
      if (!await AudioGuard.soundsValid()) return;
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('measurements/sounds/correct.mp3'));
    } catch (e) {
      // Ignore audio unlock errors
    }
  }
  
  Future<void> _speakUnit(double value, MeasurementUnit unit, AppLocalizations localizations) async {
    if (unit.symbol != 'in' && unit.symbol != 'cm') return;
    final unitName = localizations.isEnglish ? unit.nameEn : unit.nameEs;
    // Handle pluralization
    String pluralUnit;
    if (value == 1.0) {
      pluralUnit = unitName;
    } else {
      // Simple pluralization rules
      if (localizations.isEnglish) {
        if (unitName.endsWith('y')) {
          pluralUnit = unitName.substring(0, unitName.length - 1) + 'ies';
        } else if (unitName.endsWith('s') || unitName.endsWith('x') || unitName.endsWith('z') || 
                   unitName.endsWith('ch') || unitName.endsWith('sh')) {
          pluralUnit = unitName + 'es';
        } else {
          pluralUnit = unitName + 's';
        }
      } else {
        // Spanish pluralization
        if (unitName.endsWith('o')) {
          pluralUnit = unitName.substring(0, unitName.length - 1) + 'os';
        } else if (unitName.endsWith('a')) {
          pluralUnit = unitName.substring(0, unitName.length - 1) + 'as';
        } else {
          pluralUnit = unitName + 's';
        }
      }
    }
    final valueText = value.toStringAsFixed(value == value.roundToDouble() ? 0 : 2);
    final text = '$valueText $pluralUnit';
    await _speak(text, language: localizations.isEnglish ? 'en' : 'es');
  }

  Future<void> _speakInstruction(Level level) async {
    final localizations = AppLocalizations.of(context);
    final lang = localizations.isEnglish ? 'en' : 'es';
    final instruction = level.getInstruction(lang);
    await _speakPlain(instruction, language: lang, interrupt: true);
  }

  void _speakInchesValue(double value, AppLocalizations localizations) {
    final unit = MeasurementData.getUnitBySymbol('in');
    if (unit == null) return;
    _speakUnit(value, unit, localizations);
  }

  void _scheduleSliceTargetAnnouncement(double target, AppLocalizations localizations) {
    if (_lastSpokenSliceTarget == target) return;
    _lastSpokenSliceTarget = target;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakInchesValue(target, localizations);
    });
  }

  Future<void> _onSliceAttempt(double currentTarget, AppLocalizations localizations) async {
    await _knifeController.forward();
    _audioPlayer.play(AssetSource('measurements/sounds/chop.mp3'));

    final bool isCorrect = _selectedInches == currentTarget.toInt();
    if (isCorrect) {
      _playCorrectSound();
      _speak(
        localizations.isEnglish
            ? 'Correct. ${currentTarget.toInt()} inches.'
            : 'Correcto. ${currentTarget.toInt()} pulgadas.',
        language: localizations.isEnglish ? 'en' : 'es',
      );
      _confettiController.play();
      setState(() {
        _sliceFeedback = localizations.isEnglish ? 'Perfect slice!' : '¡Corte perfecto!';
        _sliceFeedbackColor = Colors.greenAccent;
      });
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          _caughtCount++;
        });
        if (_caughtCount >= 5) {
          _gameCompleted = true;
          _showLevelCompleteDialog();
        }
      });
    } else {
      _playWrongSound();
      _speak(
        localizations.isEnglish
            ? 'Wrong. ${currentTarget.toInt()} inches.'
            : 'Incorrecto. ${currentTarget.toInt()} pulgadas.',
        language: localizations.isEnglish ? 'en' : 'es',
      );
      setState(() {
        _sliceFeedback = localizations.isEnglish ? 'Try a different inch.' : 'Intenta otra pulgada.';
        _sliceFeedbackColor = Colors.orangeAccent;
      });
    }
    await _knifeController.reverse();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _sliceFeedback = '';
        _sliceFeedbackColor = Colors.transparent;
      });
    });
  }

  Widget _buildPizzaTopping({required double left, required double top, required double size, required Color color}) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
        ),
      ),
    );
  }

  // --- INTERACTIVE TAPE MEASURE METHODS ---
  Widget _buildInteractiveTapeArea(String unitSymbol) {
    // Only show if we actually need it
    
    // Auto-advance step if it's 0 (since we have text bubbles now)
    if (_lessonStep == 0) _lessonStep = 1;

    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.shade200, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fit content
          children: [
             // 1. The Worm Visual
             const Text("🐛", style: TextStyle(fontSize: 80)),
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
               decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
               child: Text(
                 "Mr. Worm (5 cm)",
                 style: GoogleFonts.comicNeue(fontSize: 18, fontWeight: FontWeight.bold),
               ),
             ),
             
             const SizedBox(height: 20),
             
             // 2. The Measure Zone (Visual Guide + Tape)
             Stack(
               alignment: Alignment.centerLeft,
               children: [
                  // Visual Guide (Where to pull to)
                  Container(
                     height: 60, width: 260, // 200px (5 bugs) + 60px housing offset
                     decoration: BoxDecoration(
                       border: Border(bottom: BorderSide(color: Colors.black12, width: 2, style: BorderStyle.solid))
                     ),
                     alignment: Alignment.centerRight,
                     child: Opacity(opacity: 0.3, child: Text("Pull to here! 🚩", style: GoogleFonts.comicNeue(fontSize: 14))),
                  ),
                  
                  // The Tape Measure
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       // Housing
                       Container(
                         width: 60, height: 60,
                         decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))],
                         ),
                         child: const Center(child: Icon(Icons.straighten, color: Colors.white, size: 30)),
                       ),
                       
                       // Yellow Tape
                       Container(
                         width: _currentTapeLength,
                         height: 45,
                         decoration: BoxDecoration(
                            color: Colors.yellow,
                            border: Border.symmetric(horizontal: BorderSide(color: Colors.black, width: 2)),
                         ),
                         alignment: Alignment.centerLeft,
                         child: ClipRect(
                            child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: List.generate(
                                  (_currentTapeLength / 40).floor(), 
                                  (index) => const Padding(
                                     padding: EdgeInsets.symmetric(horizontal: 2.0),
                                     child: Text('🐞', style: TextStyle(fontSize: 24)),
                                  )
                               ),
                            ),
                         ),
                       ),
                       
                       // Handle
                       GestureDetector(
                          onHorizontalDragUpdate: (details) {
                             if (_lessonStep == 1) {
                                setState(() {
                                   _currentTapeLength += details.delta.dx;
                                   if (_currentTapeLength < 10) _currentTapeLength = 10;
                                   if (_currentTapeLength > 240) _currentTapeLength = 240; 
                                });
                             }
                          },
                          onHorizontalDragEnd: (details) {
                             if ((_currentTapeLength - 200).abs() < 30) {
                                setState(() {
                                   _lessonStep = 2; // Success
                                   _currentTapeLength = 200;
                                   _confettiController.play();
                                   _playCorrectSound();
                                });
                                final unit = MeasurementData.getUnitBySymbol('cm');
                                if (unit != null) {
                                  _speakUnit(5, unit, AppLocalizations.of(context));
                                }
                             }
                          },
                          child: Container(
                             width: 50, height: 50,
                             decoration: BoxDecoration(color: Colors.grey.shade300, border: Border.all(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(5)),
                             child: const Icon(Icons.arrow_forward, color: Colors.black),
                          ),
                       ),
                    ],
                  ),
               ],
             ),
             
             const SizedBox(height: 20),
             
             // 3. Result Text
             Text(
                _lessonStep == 2 
                   ? "5 Ladybugs = 5 cm!" 
                   : (_currentTapeLength > 60) 
                       ? "${(_currentTapeLength / 40).floor()} Ladybugs..." 
                       : "Pull the tape!",
                style: GoogleFonts.fredoka(color: _lessonStep == 2 ? Colors.green : Colors.black54, fontSize: 24, fontWeight: FontWeight.bold),
             ),
          ],
        ),
      ),
    );
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Rebuild when locale changes
    if (_currentMode == 'practice') {
      _validatePracticeUnits();
    }
  }
  
  // Game mode variables (legacy - may not be used)
  int _level = 1;
  int _currentRound = 0;
  int _totalRounds = 5;
  
  // Treasure Gate Adventure game state
  List<Treasure> _treasures = [];
  Gate? _currentGate;
  List<Treasure> _collectedTreasures = [];
  bool _gateOpen = false;
  bool _roundComplete = false;
  
  // Practice mode variables
  final TextEditingController _practiceValueController = TextEditingController(text: '100');
  String _practiceFromUnit = 'cm';
  String _practiceToUnit = 'm';
  double _practiceResult = 1.0;
  bool _showSteps = false;
  
  // Validate and fix unit values on initialization
  void _validatePracticeUnits() {
    final units = MeasurementData.getAllUnits();
    final unitSymbols = units.map((u) => u.symbol).toSet();
    
    // Fix from unit if invalid
    if (!unitSymbols.contains(_practiceFromUnit)) {
      _practiceFromUnit = 'cm';
    }
    
    // Fix to unit if invalid
    if (!unitSymbols.contains(_practiceToUnit) || _practiceToUnit == _practiceFromUnit) {
      _practiceToUnit = units.firstWhere((u) => u.symbol != _practiceFromUnit).symbol;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _validatePracticeUnits();
    
    // Initialize animation controllers
    _characterController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _starController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _objectFloatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _knifeController = AnimationController(
        duration: const Duration(milliseconds: 300), 
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0, 
    );
    
    // Confetti controller
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Object floating animation
    _objectFloatController.addListener(() {
      if (mounted) {
        setState(() {}); // Update animations
      }
    });
    
    _starScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _starController, curve: Curves.elasticOut),
    );
    _celebrationRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.easeInOut),
    );
    _floatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _objectFloatController, curve: Curves.easeInOut),
    );
    
    if (widget.initialMode != null) {
      _currentMode = widget.initialMode!;
    }

    if (widget.levelId != null) {
      _currentMode = 'learn';
    }

    if (_currentMode == 'quiz') {
      // Will generate in build method
    } else if (_currentMode == 'practice') {
      _updatePracticeConversion();
    }
    _practiceValueController.addListener(_onPracticeValueChanged);
  }

  @override
  void dispose() {
    _characterController.dispose();
    _starController.dispose();
    _celebrationController.dispose();
    _objectFloatController.dispose();
    _particleController.dispose();
    _confettiController.dispose();
    _knifeController.dispose();
    _audioPlayer.dispose();
    _spawnTimer?.cancel(); // Cancel timer
    _practiceValueController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _onPracticeValueChanged() {
    final value = double.tryParse(_practiceValueController.text) ?? 100;
    setState(() {
      _practiceFromValue = value;
      _updatePracticeConversion();
    });
  }

  void _updatePracticeConversion() {
    final fromUnit = MeasurementData.getUnitBySymbol(_practiceFromUnit);
    final toUnit = MeasurementData.getUnitBySymbol(_practiceToUnit);
    if (fromUnit != null && toUnit != null) {
      final value = double.tryParse(_practiceValueController.text) ?? 100;
      setState(() {
        _practiceResult = MeasurementData.convert(value, fromUnit.symbol, toUnit.symbol);
      });
    }
  }

  double _practiceFromValue = 100;

  // Helper function to get image path for an object
  String _getImagePath(String objectName) {
    final imageMap = {
      'Ruler': 'assets/measurements/images/ruler.png',
      'Ball': 'assets/measurements/images/ball.png',
      'Book': 'assets/measurements/images/book.png',
      'Car': 'assets/measurements/images/car.png',
      'Apple': 'assets/measurements/images/apple.png',
      'House': 'assets/measurements/images/house.png',
      'Truck': 'assets/measurements/images/truck.png',
      'Road': 'assets/measurements/images/road.png',
      'Running Track': 'assets/measurements/images/track.png',
      'Tree': 'assets/measurements/images/tree.png',
    };
    return imageMap[objectName] ?? '';
  }

  void _generateNewRound() {
    final units = MeasurementData.getAllUnits();
    
    // Reset game state (but keep level and round progress)
    _objects.clear();
    _cards.clear();
    _draggedCard = null;
    _matchesFound = 0;
    _gameComplete = false;
    // Don't reset score - keep cumulative score across rounds
    
    // Visual objects with their realistic measurements - multiple unit options
    final objectTypes = [
      {
        'emoji': '📏', 
        'name': 'Ruler',
        'units': [
          {'symbol': 'cm', 'value': (20.0 + _random.nextInt(20))}, // 20-40 cm
          {'symbol': 'in', 'value': (8.0 + _random.nextInt(8))}, // 8-16 inches
        ],
      },
      {
        'emoji': '⚽', 
        'name': 'Ball',
        'units': [
          {'symbol': 'cm', 'value': (15.0 + _random.nextInt(10))}, // 15-25 cm
          {'symbol': 'in', 'value': (6.0 + _random.nextInt(4))}, // 6-10 inches
        ],
      },
      {
        'emoji': '📚', 
        'name': 'Book',
        'units': [
          {'symbol': 'cm', 'value': (20.0 + _random.nextInt(15))}, // 20-35 cm
          {'symbol': 'in', 'value': (8.0 + _random.nextInt(6))}, // 8-14 inches
        ],
      },
      {
        'emoji': '🚗', 
        'name': 'Car',
        'units': [
          {'symbol': 'm', 'value': (3.0 + _random.nextInt(3))}, // 3-6 m
          {'symbol': 'ft', 'value': (10.0 + _random.nextInt(10))}, // 10-20 feet
          {'symbol': 'yd', 'value': (3.0 + _random.nextInt(4))}, // 3-7 yards
        ],
      },
      {
        'emoji': '🍎', 
        'name': 'Apple',
        'units': [
          {'symbol': 'cm', 'value': (6.0 + _random.nextInt(4))}, // 6-10 cm
          {'symbol': 'in', 'value': (2.0 + _random.nextInt(2))}, // 2-4 inches
        ],
      },
      {
        'emoji': '🏠', 
        'name': 'House',
        'units': [
          {'symbol': 'm', 'value': (8.0 + _random.nextInt(7))}, // 8-15 m
          {'symbol': 'ft', 'value': (25.0 + _random.nextInt(20))}, // 25-45 feet
          {'symbol': 'yd', 'value': (8.0 + _random.nextInt(7))}, // 8-15 yards
        ],
      },
      {
        'emoji': '🚛', 
        'name': 'Truck',
        'units': [
          {'symbol': 'm', 'value': (5.0 + _random.nextInt(5))}, // 5-10 m
          {'symbol': 'ft', 'value': (15.0 + _random.nextInt(15))}, // 15-30 feet
          {'symbol': 'yd', 'value': (5.0 + _random.nextInt(5))}, // 5-10 yards
        ],
      },
      {
        'emoji': '🛣️', 
        'name': 'Road',
        'units': [
          {'symbol': 'km', 'value': (1.0 + _random.nextInt(4))}, // 1-5 km
          {'symbol': 'm', 'value': (500.0 + _random.nextInt(500))}, // 500-1000 m
          {'symbol': 'yd', 'value': (500.0 + _random.nextInt(500))}, // 500-1000 yards
        ],
      },
      {
        'emoji': '🏃', 
        'name': 'Running Track',
        'units': [
          {'symbol': 'm', 'value': (100.0 + _random.nextInt(100))}, // 100-200 m
          {'symbol': 'yd', 'value': (100.0 + _random.nextInt(100))}, // 100-200 yards
          {'symbol': 'ft', 'value': (300.0 + _random.nextInt(300))}, // 300-600 feet
        ],
      },
      {
        'emoji': '🌳', 
        'name': 'Tree',
        'units': [
          {'symbol': 'm', 'value': (5.0 + _random.nextInt(10))}, // 5-15 m
          {'symbol': 'ft', 'value': (15.0 + _random.nextInt(30))}, // 15-45 feet
          {'symbol': 'yd', 'value': (5.0 + _random.nextInt(10))}, // 5-15 yards
        ],
      },
    ];
    
    // Adjust difficulty based on level: more objects at higher levels
    final numObjects = 3 + (_level - 1); // Start with fewer (3) for small kids
    final objectsToCreate = numObjects.clamp(2, 6); // Max 6 for small kids
    
    // Shuffle object types to get different objects each level/round
    final shuffledObjectTypes = List<Map<String, dynamic>>.from(objectTypes);
    
    // Filter unit options by level allowed units if applicable
    List<String>? allowedUnits;
    if (widget.levelId != null) {
      allowedUnits = LevelData.getLevel(widget.levelId!).allowedUnitSymbols;
    }

    shuffledObjectTypes.shuffle(_random);
    
    // Create objects with realistic measurements from expanded list
    for (int i = 0; i < objectsToCreate; i++) {
      final objectType = shuffledObjectTypes[i % shuffledObjectTypes.length];
      var unitOptions = objectType['units'] as List<Map<String, dynamic>>;
      
    // ... loop content ...
    // Filter if level is specified
      if (allowedUnits != null) {
        unitOptions = unitOptions.where((u) => allowedUnits!.contains(u['symbol'])).toList();
      }

      // FALLBACK: If filtering removed all options, ignore the filter so we at least generate something.
      if (unitOptions.isEmpty && allowedUnits != null) {
           // Try again with original list
           unitOptions = objectType['units'] as List<Map<String, dynamic>>;
      }

      if (unitOptions.isEmpty) continue; // Skip if no valid units for this object in this level

      // Randomly choose one of the available units for this object
      final selectedUnit = unitOptions[_random.nextInt(unitOptions.length)];
      final unitSymbol = selectedUnit['symbol'] as String;
      final value = (selectedUnit['value'] as num).toDouble();
      
      // Find the unit object
      final unit = units.firstWhere(
        (u) => u.symbol == unitSymbol,
        orElse: () => units.first,
      );
      
      _objects.add(MeasurementObject(
        id: i,
        emoji: objectType['emoji'] as String,
        name: objectType['name'] as String,
        value: value,
        unit: unit,
        isMatched: false,
      ));
    }
    
    // Safety Net: If somehow still empty (e.g. no objects defined), add a dummy one
    if (_objects.isEmpty) {
       final dummyUnit = units.first;
       _objects.add(MeasurementObject(
         id: 0,
         emoji: '❓',
         name: 'Mystery',
         value: 10,
         unit: dummyUnit,
         isMatched: false, 
       ));
    }
    
    // Create measurement cards (some correct, some distractors)
    final correctCards = _objects.map((obj) => MeasurementCard(
      id: 'card_${obj.id}',
      value: obj.value,
      unit: obj.unit,
      isCorrect: true,
      matchedObjectId: obj.id,
      isMatched: false,
    )).toList();
    
    // Add wrong cards as distractors - more distractors at higher levels
    final numDistractors = 2 + (_level - 1); // Level 1: 2, Level 2: 3, etc. (max 5)
    final distractorsToAdd = numDistractors.clamp(2, 5);
    for (int i = 0; i < distractorsToAdd; i++) {
      final wrongUnit = units[_random.nextInt(units.length)];
      final wrongValue = (1 + _random.nextInt(10)).toDouble();
      correctCards.add(MeasurementCard(
        id: 'wrong_$i',
        value: wrongValue,
        unit: wrongUnit,
        isCorrect: false,
        matchedObjectId: -1,
        isMatched: false,
      ));
    }
    
    _cards = correctCards;
    _cards.shuffle(_random);
    _totalMatches = _objects.length;
    
    print('Generated ${_objects.length} objects and ${_cards.length} cards');
    print('First object: ${_objects.isNotEmpty ? "${_objects.first.name} - ${_objects.first.value} ${_objects.first.unit.symbol}" : "none"}');
    print('First card: ${_cards.isNotEmpty ? "${_cards.first.value} ${_cards.first.unit.symbol}" : "none"}');
    
    // Force rebuild
    if (mounted) {
      setState(() {});
    }
  }
  
  void _onCardDropped(MeasurementCard card, MeasurementObject object) {
    if (card.isMatched || object.isMatched || _gameComplete) return;
    
    setState(() {
      if (card.matchedObjectId == object.id) {
        // Correct match!
        card.isMatched = true;
        object.isMatched = true;
        _matchesFound++;
        _score += 20;
        _playCorrectSound();
        final localizations = AppLocalizations.of(context);
        _speakPlain(
          localizations.isEnglish ? 'Correct!' : '¡Correcto!',
          language: localizations.isEnglish ? 'en' : 'es',
          interrupt: true,
        );
        if (widget.levelId == 1) {
          final valueText = card.value.toStringAsFixed(card.value == card.value.roundToDouble() ? 0 : 1);
          _speakPlain(
            '$valueText ${card.unit.symbol}',
            language: localizations.isEnglish ? 'en' : 'es',
            interrupt: true,
          );
        } else {
          _speakUnit(card.value, card.unit, localizations);
        }
        
        if (_matchesFound >= _totalMatches) {
          _gameComplete = true;
          _gameCompleted = true; // Mark game section as done
          _confettiController.play();
          
          // Show Success Dialog then exit or next level
           Future.delayed(const Duration(milliseconds: 1000), () {
             _showLevelCompleteDialog();
           });
        }
      } else {
        // Wrong match
        _playWrongSound();
        final localizations = AppLocalizations.of(context);
        _speakPlain(
          localizations.isEnglish ? 'Try again!' : '¡Inténtalo de nuevo!',
          language: localizations.isEnglish ? 'en' : 'es',
          interrupt: true,
        );
      }
      _draggedCard = null;
    });
  }

  void _ensureWeighingItems() {
    if (_weighingItems.isNotEmpty) return;
    _generateWeighingItems();
  }

  void _generateWeighingItems() {
    final items = <WeighingItem>[
      WeighingItem(emoji: '🧸', nameEn: 'Teddy', nameEs: 'Osito', weightBlocks: 2),
      WeighingItem(emoji: '🍎', nameEn: 'Apple', nameEs: 'Manzana', weightBlocks: 1),
      WeighingItem(emoji: '🐘', nameEn: 'Elephant', nameEs: 'Elefante', weightBlocks: 5),
      WeighingItem(emoji: '🍉', nameEn: 'Watermelon', nameEs: 'Sandía', weightBlocks: 4),
      WeighingItem(emoji: '🚗', nameEn: 'Car', nameEs: 'Auto', weightBlocks: 3),
      WeighingItem(emoji: '📚', nameEn: 'Books', nameEs: 'Libros', weightBlocks: 3),
    ];

    items.shuffle(_random);
    _weighingItems = items.take(5).toList();
    _weighingIndex = 0;
    _weighingSelected = 1;
    _weighingFeedback = '';
    _weighingFeedbackColor = Colors.transparent;
    _gameComplete = false;
    _gameCompleted = false;
  }

  void _onWeighingSubmit(AppLocalizations localizations) {
    if (_weighingItems.isEmpty || _gameComplete) return;
    final item = _weighingItems[_weighingIndex];
    final isCorrect = _weighingSelected == item.weightBlocks;
    setState(() {
      if (isCorrect) {
        _playCorrectSound();
        _score += 10;
        _weighingFeedback = localizations.isEnglish ? 'Correct!' : '¡Correcto!';
        _weighingFeedbackColor = Colors.green;
        _speakPlain(
          localizations.isEnglish
              ? 'Great job! ${item.weightBlocks} blocks is correct.'
              : '¡Muy bien! ${item.weightBlocks} bloques es correcto.',
          language: localizations.isEnglish ? 'en' : 'es',
          interrupt: true,
        );
      } else {
        _playWrongSound();
        _weighingFeedback = localizations.isEnglish ? 'Try again!' : '¡Inténtalo de nuevo!';
        _weighingFeedbackColor = Colors.orange;
        _speakPlain(
          localizations.isEnglish ? 'Try a different number of blocks.' : 'Intenta con otra cantidad de bloques.',
          language: localizations.isEnglish ? 'en' : 'es',
          interrupt: true,
        );
      }
    });

    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          if (_weighingIndex >= _weighingItems.length - 1) {
            _gameCompleted = true;
            _confettiController.play();
            _showLevelCompleteDialog();
          } else {
            _weighingIndex++;
            _weighingSelected = 1;
            _weighingFeedback = '';
            _weighingFeedbackColor = Colors.transparent;
          }
        });
      });
    }
  }

  void _showGameOver() {
    // Handle game over
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final localizations = AppLocalizations.of(context);
        return AlertDialog(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
           backgroundColor: Colors.white,
           title: Column(
             children: [
               const Text('🌟 🌟 🌟', style: TextStyle(fontSize: 30)),
               const SizedBox(height: 10),
               Text(
                 localizations.isEnglish ? 'Level Complete!' : '¡Nivel Completado!',
                 style: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple),
                 textAlign: TextAlign.center,
               ),
             ],
           ),
           content: Text(
             localizations.isEnglish 
                ? 'You are a measuring master!' 
                : '¡Eres un maestro de las medidas!',
             textAlign: TextAlign.center,
             style: const TextStyle(fontSize: 18),
           ),
           actions: [
             Center(
               child: ElevatedButton(
                 onPressed: () {
                   Navigator.pop(context); // Close dialog
                   Navigator.pop(context, {'learn': _learnCompleted, 'game': true}); // Return result
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.green,
                   foregroundColor: Colors.white,
                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                 ),
                 child: Text(
                   localizations.isEnglish ? 'Continue' : 'Continuar',
                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                 ),
               ),
             )
           ],
        );
      }
    );
  }

  void _playCorrectSound() async {
    try {
      if (!await AudioGuard.soundsValid()) return;
      if (!_audioUnlocked) {
        await _unlockAudio();
        return;
      }
      await _audioPlayer.play(AssetSource('measurements/sounds/correct.mp3'));
    } catch (e) {
      // Handle audio error gracefully
    }
  }

  void _playWrongSound() async {
    try {
      if (!await AudioGuard.soundsValid()) return;
      if (!_audioUnlocked) {
        await _unlockAudio();
        return;
      }
      await _audioPlayer.play(AssetSource('measurements/sounds/wrong.mp3'));
    } catch (e) {
      // Handle audio error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      body: GestureDetector(
        onTapDown: (_) => setState(() {
          _unlockAudio();
        }),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6B46C1),
              Color(0xFF8B5CF6),
              Color(0xFFA78BFA),
              Color(0xFFC4B5FD),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button and mode selector
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                        _buildLanguageToggle(localizations),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildModeSelector(localizations),
                  ],
                ),
              ),
              
              // Scrollable content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildModeContent(localizations),
                ),
              ),
            ],
          ),
              ),
            ),
            if (_showSoundPrompt)
              Positioned(
                top: 80,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Text(
                    localizations.isEnglish ? 'Tap to enable sound' : 'Toca para activar sonido',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector(AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the two tabs
      children: [
        Expanded(child: _buildModeButton('learn', '📚 ${localizations.isEnglish ? "Learn" : "Aprender"}', localizations, isLocked: false)),
        const SizedBox(width: 15),
        Expanded(child: _buildModeButton('game', '🎮 ${localizations.isEnglish ? "Game" : "Juego"}', localizations, isLocked: !_learnCompleted)),
      ],
    );
  }

  Widget _buildLanguageToggle(AppLocalizations localizations) {
    final currentLanguage = Localizations.localeOf(context).languageCode;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageButton('en', '🇺🇸', currentLanguage),
          _buildLanguageButton('es', '🇪🇸', currentLanguage),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String languageCode, String flag, String currentLanguage) {
    final isSelected = currentLanguage == languageCode;
    
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          final locale = Locale(languageCode, '');
          widget.onLanguageChanged?.call(locale);
          setState(() {}); // Force rebuild to update UI
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          flag,
          style: TextStyle(
            fontSize: 20,
            color: isSelected ? Colors.blue : Colors.white,
          ),
        ),
      ),
    );
  }


  Widget _buildModeButton(String mode, String label, AppLocalizations localizations, {bool isLocked = false}) {
    // If we map 'game' mode to the actual level game mode
    bool isActive = _currentMode == mode;
    // Map internal 'game' mode to whatever the level mode is for checking active state
    if (mode == 'game' && _currentMode != 'learn') isActive = true;

    return GestureDetector(
      onTap: () {
        if (isLocked) {
             _playWrongSound();
             // Shake or show toast?
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: Text(localizations.isEnglish 
                   ? "Complete the Learn section first!" 
                   : "¡Completa la sección de Aprender primero!"),
                 backgroundColor: Colors.orange,
                 duration: 1.seconds,
               ),
             );
             return;
        }
        
        setState(() {
          if (mode == 'learn') {
            _currentMode = 'learn';
          } else {
            // Switch to the specific game mode defined by the level
            if (widget.levelId != null) {
               final level = LevelData.getLevel(widget.levelId!);
               _currentMode = level.gameMode; // 'matching', 'catching', 'lab'
            } else {
               _currentMode = 'matching';
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF8B5CF6) : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isActive ? [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0,4))] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isLocked ? Colors.white54 : Colors.white,
                fontSize: 18,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isLocked) ...[
              const SizedBox(width: 8),
              const Icon(Icons.lock, color: Colors.white54, size: 18),
            ],
            if (!isLocked && mode == 'learn' && _learnCompleted) ...[
               const SizedBox(width: 8),
               const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
            ]
          ],
        ),
      ),
    );
  }


  Widget _buildLearnMode(AppLocalizations localizations) {
    
    // Determine the unit being taught based on the level
    String unitSymbol = 'cm';
    if (widget.levelId != null) {
       final level = LevelData.getLevel(widget.levelId!);
       if (level.allowedUnitSymbols.isNotEmpty) unitSymbol = level.allowedUnitSymbols.first;
    }
    
    final unit = MeasurementData.getAllUnits().firstWhere((u) => u.symbol == unitSymbol, orElse: () => MeasurementData.getAllUnits().first);
    final unitName = localizations.isEnglish ? unit.nameEn : unit.nameEs;

    // Content for the lesson
    String introText = "Hi! I'm the $unitName! I help measure things.";
    String actionText = "Pull the handle ➡️ to measure!";
    String successText = "Perfect! It is 5 $unitSymbol long!";
    
    if (unitSymbol == 'cm') {
       introText = localizations.isEnglish ? "Hi! I'm a Centimeter! I'm tiny like a bug." : "¡Hola! ¡Soy un Centímetro! Soy pequeño como un bicho.";
    } else if (unitSymbol == 'm') {
       introText = localizations.isEnglish ? "Hi! I'm a Meter! I'm big like a bush." : "¡Hola! ¡Soy un Metro! Soy grande como un arbusto.";
    } else if (unitSymbol == 'ft') {
       introText = localizations.isEnglish ? "Hi! I'm a Foot! I'm... like a foot!" : "¡Hola! ¡Soy un Pie! Soy... ¡como un pie!";
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Mascot / Intro Bubble
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 3), // High contrast border
              boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0,4))],
            ),
            child: Row(
              children: [
                const Text('🦊', style: TextStyle(fontSize: 50)),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                     _lessonStep == 0 ? introText :
                     _lessonStep == 1 ? actionText :
                     successText,
                     style: GoogleFonts.comicNeue(
                       fontSize: 22, 
                       fontWeight: FontWeight.w900, // Extra bold
                       color: Colors.black87 // High contrast text
                     ),
                  ),
                ),
                if (_lessonStep == 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 30),
                    onPressed: () {
                      setState(() {
                         _lessonStep = 1;
                         _speakPlain(actionText, language: localizations.isEnglish ? 'en' : 'es', interrupt: true);
                      });
                    },
                  )
              ],
            ),
          ).animate().slideY(begin: -0.5, duration: 600.ms),
          
          const SizedBox(height: 40),
          
          // 2. Interactive Area
          if (_lessonStep > 0)
            Container(
              height: 350,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Light background for contrast
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // The Object to Measure (Top Center)
                  Positioned(
                    top: 20,
                    child: Column(
                      children: [
                        Icon(
                           unitSymbol == 'cm' ? Icons.bug_report : 
                           unitSymbol == 'm' ? Icons.forest :
                           unitSymbol == 'ft' ? Icons.pets : Icons.rocket_launch,
                           size: 120, // Bigger Icon
                           color: Colors.orangeAccent
                        ),
                        // The "Target Length" visual guide
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 200, 
                          height: 8, // Thicker guide
                          color: Colors.black26,
                        ),
                        Text(
                          "Target: 5 $unitSymbol",
                          style: GoogleFonts.fredoka(color: Colors.black54, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  
                  // The Tape Measure (Bottom)
                  Positioned(
                    bottom: 40,
                    left: 20, // Start from left
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Housing (Fixed)
                        Container(
                          width: 80, height: 80, // BIGGER Housing
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))],
                          ),
                          child: const Center(child: Icon(Icons.straighten, color: Colors.white, size: 40)),
                        ),
                        
                        // The Tape (Variable Width)
                        Container(
                          width: _currentTapeLength,
                          height: 60, // BIGGER Tape Height
                          margin: const EdgeInsets.only(bottom: 10), // Align with center of housing roughly
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            border: Border.symmetric(horizontal: BorderSide(color: Colors.black, width: 2)),
                          ),
                          alignment: Alignment.center,
                          child: _lessonStep == 1 
                            ? Text(
                                "${(_currentTapeLength / 40).toStringAsFixed(1)} $unitSymbol", 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black), // Bigger Text
                              )
                            : const SizedBox(),
                        ),
                        
                        // The Handle (Draggable)
                        GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (_lessonStep == 1) {
                              setState(() {
                                _currentTapeLength += details.delta.dx;
                                // Clamp length
                                if (_currentTapeLength < 10) _currentTapeLength = 10;
                                if (_currentTapeLength > 300) _currentTapeLength = 300;
                              });
                            }
                          },
                          onHorizontalDragEnd: (details) {
                             // Check if close to target (200px width + safety)
                             // Target visual width is 200.
                             if ((_currentTapeLength - 200).abs() < 30) {
                                // Success!
                                setState(() {
                                  _lessonStep = 2;
                                  _currentTapeLength = 200; // Snap to perfect
                                  _confettiController.play();
                                  _audioPlayer.play(AssetSource('measurements/sounds/match_success.mp3'));
                                  _speak(successText);
                                });
                             } else {
                                // Snap back a bit if wrong
                                // Optional: Feedback "Try again!"
                             }
                          },
                          child: Container(
                            width: 60, height: 80, // BIGGER Handle
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                              border: Border.all(color: Colors.black, width: 3),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2,2))],
                            ),
                            child: const Icon(Icons.drag_indicator, color: Colors.black54, size: 40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
          if (_lessonStep == 2)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () {
                   Navigator.pop(context, true); // Finish level with success
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green for go/success
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                ),
                child: const Text("Finish Level", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scaleXY(end: 1.1, duration: 600.ms, curve: Curves.easeInOut),
            ),
        ],
      ),
    );
  }
  
  // _buildRulerWidget is no longer needed but we can leave it or remove it safely if unused.
  // I will just not call it.

  Widget _buildSystemOverview(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.isEnglish ? 'Two Main Measurement Systems' : 'Dos Sistemas Principales de Medidas',
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildSystemCard(
                '📏 ${localizations.isEnglish ? "Metric System" : "Sistema Métrico"}',
                localizations.isEnglish 
                  ? 'Used worldwide, based on powers of 10. Easy to convert!'
                  : 'Usado mundialmente, basado en potencias de 10. ¡Fácil de convertir!',
                MeasurementData.getMetricUnits(),
                Color(0xFF8B5CF6),
                localizations,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildSystemCard(
                '🦶 ${localizations.isEnglish ? "Imperial System" : "Sistema Imperial"}',
                localizations.isEnglish 
                  ? 'Used in USA, based on historical measurements.'
                  : 'Usado en Estados Unidos, basado en medidas históricas.',
                MeasurementData.getImperialUnits(),
                Color(0xFFA78BFA),
                localizations,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSystemCard(String title, String description, List<MeasurementUnit> units, Color color, AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
            title,
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 10),
                Text(
            description,
                  style: GoogleFonts.comicNeue(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: units.map((unit) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.15)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  '${localizations.isEnglish ? unit.nameEn : unit.nameEs} (${unit.symbol})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableUnitCard(MeasurementUnit unit, AppLocalizations localizations) {
    return _ExpandableUnitCard(
      unit: unit, 
      localizations: localizations,
      onTap: () => _speakUnit(1.0, unit, localizations),
    );
  }

  Widget _buildComparisonTool(AppLocalizations localizations) {
    return _ComparisonToolWidget(
      localizations: localizations,
      onSpeakUnit: (value, unit) => _speakUnit(value, unit, localizations),
    );
  }

  Widget _buildFunFactsSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                Text(
          localizations.isEnglish ? 'Fun Measurement Facts!' : '¡Datos Divertidos sobre Medidas!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ..._getFunFacts(localizations).map((fact) => _buildFactCard(fact['title']!, fact['fact']!)).toList(),
      ],
    );
  }

  List<Map<String, String>> _getFunFacts(AppLocalizations localizations) {
    if (localizations.isEnglish) {
      return [
        {
          'title': 'Metric System',
          'fact': 'The metric system is used by 95% of the world\'s population! Only the USA, Liberia, and Myanmar still primarily use imperial units.'
        },
        {
          'title': 'Meter History',
          'fact': 'The meter was originally defined as one ten-millionth of the distance from the North Pole to the Equator through Paris.'
        },
        {
          'title': 'Foot Origin',
          'fact': 'The foot was originally based on the length of a human foot, but it varied between different countries until it was standardized.'
        },
        {
          'title': 'Centimeter Precision',
          'fact': 'A centimeter is about the width of a fingernail, making it perfect for measuring small objects like pencils and phones.'
        },
        {
          'title': 'Kilometer Scale',
          'fact': 'A kilometer is about the distance you can walk in 12-15 minutes at a normal pace.'
        },
        {
          'title': 'Inch Measurement',
          'fact': 'An inch is about the length of your thumb from the tip to the first joint.'
        },
      ];
    } else {
      return [
        {
          'title': 'Sistema Métrico',
          'fact': '¡El sistema métrico es usado por el 95% de la población mundial! Solo Estados Unidos, Liberia y Myanmar siguen usando principalmente unidades imperiales.'
        },
        {
          'title': 'Historia del Metro',
          'fact': 'El metro se definió originalmente como una diez millonésima parte de la distancia del Polo Norte al Ecuador a través de París.'
        },
        {
          'title': 'Origen del Pie',
          'fact': 'El pie se basó originalmente en la longitud de un pie humano, pero variaba entre diferentes países hasta que se estandarizó.'
        },
        {
          'title': 'Precisión del Centímetro',
          'fact': 'Un centímetro es aproximadamente el ancho de una uña, lo que lo hace perfecto para medir objetos pequeños como lápices y teléfonos.'
        },
        {
          'title': 'Escala del Kilómetro',
          'fact': 'Un kilómetro es aproximadamente la distancia que puedes caminar en 12-15 minutos a un ritmo normal.'
        },
        {
          'title': 'Medida de Pulgada',
          'fact': 'Una pulgada es aproximadamente la longitud de tu pulgar desde la punta hasta la primera articulación.'
        },
      ];
    }
  }

  Widget _buildFactCard(String title, String fact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                Text(
            title,
            style: GoogleFonts.fredoka(
              color: Color(0xFFFFD700),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
                Text(
            fact,
                  style: GoogleFonts.comicNeue(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                  ),
                ),
        ],
      ),
    );
  }

  // Main content builder based on game mode
  Widget _buildModeContent(AppLocalizations localizations) {
      if (widget.levelId != null) {
          final level = LevelData.getLevel(widget.levelId!);
          
          if (_currentMode == 'learn') {
             return _buildNewLearnSection(level, localizations);
          }
          
          // Game Modes
          if (_currentMode == 'matching' || level.gameMode == 'matching') return Stack(
            children: [
               _buildMatchingGame(localizations),
               _buildReviewButton(localizations),
            ],
          );
          if (_currentMode == 'weighing' || level.gameMode == 'weighing') return Stack(
            children: [
              _buildWeighingGame(localizations),
              _buildReviewButton(localizations),
            ],
          );
          if (_currentMode == 'lab' || level.gameMode == 'lab') return Stack(
            children: [
              _buildPracticeMode(localizations),
              _buildReviewButton(localizations),
            ],
          );
          if (_currentMode == 'slicing' || level.gameMode == 'slicing') return Stack(
            children: [
              _buildSlicingGame(localizations),
              _buildReviewButton(localizations),
            ],
          );
      }
      
      // Fallback
      return _buildMatchingGame(localizations);
  }
  
  Widget _buildReviewButton(AppLocalizations localizations) {
      return Positioned(
        top: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
             setState(() {
               _currentMode = 'learn';
             });
          },
          child: Container(
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
             margin: const EdgeInsets.only(top: 10, right: 10), // Add margin to avoid screen edge
             decoration: BoxDecoration(
               color: Colors.white.withOpacity(0.9),
               borderRadius: BorderRadius.circular(20),
               boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
             ),
             child: Row(
               children: [
                 const Icon(Icons.menu_book, size: 16, color: Colors.blue),
                 const SizedBox(width: 4),
                 Text(
                   localizations.isEnglish ? "Review" : "Repasar",
                   style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                 ),
               ],
             ),
          ),
        ),
      );
  }

  Widget _buildNewLearnSection(Level level, AppLocalizations localizations) {
      final lang = localizations.isEnglish ? 'en' : 'es';
      final content = level.getLearnContent(lang);
      final parts = content.split('\n\n');
      
      // Determine if we should show the interactive tape measure
      // We show it for Level 1 (Centimeter) and maybe others if needed
      bool showTapeMeasure = level.id == 1; // Explicitly for Level 1
      String unitSymbol = 'cm';
      if (level.allowedUnitSymbols.isNotEmpty) unitSymbol = level.allowedUnitSymbols.first;

      final bool isWeighingLevel = level.id == 2;
      final bool allowPlay = isWeighingLevel ? _weighingLearnDone : (!showTapeMeasure || _lessonStep == 2);

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Column(
             children: [
                const SizedBox(height: 20),
                // Mascot Animation
                GestureDetector(
                   onTap: () => _speakPlain(content, language: localizations.isEnglish ? 'en' : 'es', interrupt: true),
                   child: Container(
                     width: 120, height: 120,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.circle,
                       boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0,5))],
                       border: Border.all(color: Colors.orange, width: 4),
                     ),
                     child: Stack(
                       children: [
                         Center(
                           child: Text(level.icon, style: const TextStyle(fontSize: 60)),
                         ),
                         Positioned(
                           bottom: 6,
                           right: 6,
                           child: Container(
                             width: 26,
                             height: 26,
                             decoration: BoxDecoration(
                               color: Colors.orange,
                               shape: BoxShape.circle,
                               boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                             ),
                             child: const Icon(Icons.volume_up, color: Colors.white, size: 16),
                           ),
                         ),
                       ],
                     ),
                   ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(end: 1.1, duration: 2.seconds),
                ),
                
                const SizedBox(height: 30),
                
                // Content bubbles
                ...parts.map((part) => Container(
                   margin: const EdgeInsets.only(bottom: 20),
                   padding: const EdgeInsets.all(20),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(20).copyWith(topLeft: const Radius.circular(0)),
                     boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(2,2))], 
                   ),
                   child: Text(
                      part,
                      style: GoogleFonts.comicNeue(fontSize: 20, color: Colors.black87, height: 1.2),
                   ),
                ).animate().slideX(begin: -0.1, duration: 400.ms).fadeIn()),
                
                // INTERACTIVE PRACTICE AREA
                if (showTapeMeasure) ...[
                   // Visual Analogy
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Reduced padding
                     decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(20)),
                     child: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         const Text("1 cm = ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                         const Text("🐞", style: TextStyle(fontSize: 28)),
                       ],
                     ),
                   ),
                   const SizedBox(height: 10), // Reduced gap
                   _buildInteractiveTapeArea(unitSymbol),
                ],

                if (isWeighingLevel) ...[
                  const SizedBox(height: 10),
                  _buildWeighingLearnSection(localizations),
                ],
                
                const SizedBox(height: 20),
                
                // Interactive Button - Only enable if practice is done (or if no practice needed)
                if (allowPlay)
                ElevatedButton.icon(
                  onPressed: () {
                     // Mark Learn as done
                     setState(() {
                       _learnCompleted = true;
                       _currentMode = level.gameMode; // Unlock and go to game
                     });
                     _playCorrectSound();
                     _confettiController.play();
                  },
                  icon: const Icon(Icons.play_circle_fill, size: 30),
                  label: Text(
                    localizations.isEnglish ? "Got it! Let's play!" : "¡Entendido! ¡A jugar!",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700), // Gold
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 8,
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true))
                 .shimmer(duration: 2.seconds, color: Colors.white)
                 .scaleXY(end: 1.05, duration: 1.seconds),
             ],
          ),
        ),
      );
  }

  // --- SLICING GAME (Level 2) ---
  Widget _buildSlicingGame(AppLocalizations localizations) {
    if (_spawnTimer != null && _spawnTimer!.isActive) _spawnTimer!.cancel(); // Ensure no bug timers

    // Targets for slicing (in inches)
    final List<double> targets = [2.0, 4.0, 1.0, 3.0, 5.0];
    final double currentTarget = targets[_caughtCount % targets.length]; // Reuse _caughtCount as slice count
    _scheduleSliceTargetAnnouncement(currentTarget, localizations);
    final double progress = (_caughtCount / 5).clamp(0.0, 1.0);
    final int selectedInches = _selectedInches.clamp(1, 5);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
        // Title / Score
        Container(
           margin: const EdgeInsets.only(top: 20, bottom: 20),
           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(20),
             boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
           ),
           child: Column(
             children: [
               Text(
                 localizations.isEnglish ? "Pizza Slicing Challenge" : "Desafío de Pizza",
                 style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
               ),
               const SizedBox(height: 8),
               Text(
                 localizations.isEnglish ? "Slices: $_caughtCount/5" : "Cortes: $_caughtCount/5",
                 style: GoogleFonts.comicNeue(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
               ),
               const SizedBox(height: 8),
               ClipRRect(
                 borderRadius: BorderRadius.circular(10),
                 child: LinearProgressIndicator(
                   value: progress,
                   minHeight: 10,
                   backgroundColor: Colors.orange.shade100,
                   valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                 ),
               ),
             ],
           ),
        ),

        // Target Hint (Where to cut)
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
          child: Text(
             localizations.isEnglish
                 ? "Cut at ${currentTarget.toInt()} inches!"
                 : "¡Corta a ${currentTarget.toInt()} pulgadas!",
             style: GoogleFonts.comicNeue(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                       decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
                     child: Row(
            mainAxisSize: MainAxisSize.min,
                            children: [
              const Text("👨‍🍳", style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                localizations.isEnglish
                    ? "Order: ${currentTarget.toInt()} inches"
                    : "Pedido: ${currentTarget.toInt()} pulgadas",
                style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
        ),
        Text(
          localizations.isEnglish
              ? "Drag the knife to the inch mark, then slice."
              : "Arrastra el cuchillo a la pulgada y corta.",
          style: GoogleFonts.comicNeue(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final double trackWidth = constraints.maxWidth * 0.8;
            final double trackLeft = (constraints.maxWidth - trackWidth) / 2;
            final double handleX = trackLeft + (trackWidth * ((selectedInches - 1) / 4));
            return SizedBox(
              height: 70,
              child: Stack(
                children: [
                  Positioned(
                    left: trackLeft,
                    top: 30,
                    child: Container(
                      width: trackWidth,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  ...List.generate(5, (i) {
                    final double x = trackLeft + (trackWidth * (i / 4));
                    return Positioned(
                      left: x - 1,
                      top: 18,
                      child: Column(
                        children: [
                          Container(
                            width: 2,
                            height: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${i + 1}"',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }),
                  Positioned(
                    left: handleX - 14,
                    top: 14,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _sliceDragAccumulator += details.delta.dx;
                        const double stepThreshold = 32.0;
                        if (_sliceDragAccumulator.abs() < stepThreshold) return;
                        final int direction = _sliceDragAccumulator > 0 ? 1 : -1;
                        _sliceDragAccumulator = 0.0;
                        final int nextValue = (_selectedInches + direction).clamp(1, 5);
                        if (nextValue != _selectedInches) {
                          setState(() {
                            _selectedInches = nextValue;
                          });
                        }
                      },
                      onPanEnd: (_) {
                        _sliceDragAccumulator = 0.0;
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: const Icon(Icons.drag_indicator, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _onSliceAttempt(currentTarget, localizations),
          icon: const Icon(Icons.content_cut),
          label: Text(
            localizations.isEnglish ? 'Slice!' : '¡Corta!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
        const SizedBox(height: 10),
        if (_sliceFeedback.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _sliceFeedbackColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Text(
              _sliceFeedback,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),

        // THE GAME AREA
        SizedBox(
          height: 360,
          child: LayoutBuilder(
            builder: (context, constraints) {
               final double maxWidth = constraints.maxWidth;
               final double pizzaSize = math.min(maxWidth * 0.7, 260);
               final double pizzaLeft = (maxWidth - pizzaSize) / 2;
               final double pizzaTop = 20;
               final double cutX = pizzaLeft + (pizzaSize * (selectedInches / 5.0));
               
               return Stack(
                        children: [
                   // Pizza pan
                          Positioned(
                     left: pizzaLeft,
                     top: pizzaTop + 8,
                             child: Container(
                       width: pizzaSize,
                       height: pizzaSize,
                               decoration: BoxDecoration(
                         color: const Color(0xFF8B5E3C),
                         shape: BoxShape.circle,
                         boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 5))],
                               ),
                             ),
                          ),
                   // Pizza crust
                   Positioned(
                     left: pizzaLeft + 12,
                     top: pizzaTop + 20,
                             child: Container(
                       width: pizzaSize - 24,
                       height: pizzaSize - 24,
                               decoration: BoxDecoration(
                         gradient: const LinearGradient(
                           colors: [Color(0xFFFFC28A), Color(0xFFF4A460)],
                           begin: Alignment.topLeft,
                           end: Alignment.bottomRight,
                         ),
                         shape: BoxShape.circle,
                         border: Border.all(color: const Color(0xFFD87C3A), width: 4),
                               ),
                             ),
                          ),
                   // Toppings
                   _buildPizzaTopping(left: pizzaLeft + pizzaSize * 0.25, top: pizzaTop + pizzaSize * 0.30, size: 18, color: const Color(0xFFB71C1C)),
                   _buildPizzaTopping(left: pizzaLeft + pizzaSize * 0.55, top: pizzaTop + pizzaSize * 0.25, size: 16, color: const Color(0xFFB71C1C)),
                   _buildPizzaTopping(left: pizzaLeft + pizzaSize * 0.35, top: pizzaTop + pizzaSize * 0.55, size: 20, color: const Color(0xFFB71C1C)),
                   _buildPizzaTopping(left: pizzaLeft + pizzaSize * 0.65, top: pizzaTop + pizzaSize * 0.60, size: 16, color: const Color(0xFFB71C1C)),
                   _buildPizzaTopping(left: pizzaLeft + pizzaSize * 0.50, top: pizzaTop + pizzaSize * 0.45, size: 14, color: const Color(0xFF2E7D32)),

                   // Selected cut line
                   Positioned(
                     left: cutX - 2,
                     top: pizzaTop + 10,
                     child: Container(
                       width: 4,
                       height: pizzaSize - 20,
                       decoration: BoxDecoration(
                         color: Colors.redAccent,
                         borderRadius: BorderRadius.circular(2),
                       ),
                     ),
                   ),
                   // Cutter
                   AnimatedBuilder(
                     animation: _knifeController,
                     builder: (ctx, child) {
                       final double drop = 20 * _knifeController.value;
                        return Positioned(
                         left: cutX - 18,
                         top: pizzaTop - 10 + drop,
                         child: SizedBox(
                           width: 36,
                           height: 120,
                           child: CustomPaint(painter: _KnifePainter()),
                         ),
                        );
                     },
                   ),
                   // Target label
                   Positioned(
                     left: pizzaLeft + (pizzaSize * (currentTarget / 5.0)) - 18,
                     top: pizzaTop - 20,
                     child: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                       decoration: BoxDecoration(
                         color: Colors.redAccent,
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: Text(
                         "${currentTarget.toInt()}\"",
                         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
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
    );
  }

  Widget _buildPracticeMode(AppLocalizations localizations) {
    // Validate units before building
    _validatePracticeUnits();
    
    final allUnits = MeasurementData.getAllUnits();
    
    // Filter units based on the current Level's allowed symbols (if applicable)
    List<MeasurementUnit> allowedUnits = allUnits;
    if (widget.levelId != null) {
      final level = LevelData.getLevel(widget.levelId!);
      allowedUnits = allUnits.where((u) => level.allowedUnitSymbols.contains(u.symbol)).toList();
      
      // Safety check: if configuration is wrong, fallback to all units
      if (allowedUnits.isEmpty) allowedUnits = allUnits;
    }

    final allowedSymbols = allowedUnits.map((u) => u.symbol).toList();

    // Ensure current selections are valid
    if (!allowedSymbols.contains(_practiceFromUnit)) {
       _practiceFromUnit = allowedSymbols.first;
    }
    if (!allowedSymbols.contains(_practiceToUnit)) {
       // Try to find a different unit if possible
       _practiceToUnit = allowedSymbols.length > 1 ? allowedSymbols[1] : allowedSymbols.first;
    }

    // Use current selections as valid units since we already validated/corrected them at the start of the method
    var validFromUnit = _practiceFromUnit;
    var validToUnit = _practiceToUnit;

    // Create dropdown items
    final fromUnitItems = allowedSymbols.map((symbol) {
      final unit = allUnits.firstWhere((u) => u.symbol == symbol);
      return DropdownMenuItem<String>(
        key: ValueKey('from_$symbol'),
        value: symbol,
        child: Text(
          '${localizations.isEnglish ? unit.nameEn : unit.nameEs} ($symbol)',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }).toList();
    
    final toUnitItems = allowedSymbols.where((s) => s != _practiceFromUnit).map((symbol) {
      final unit = allUnits.firstWhere((u) => u.symbol == symbol);
      return DropdownMenuItem<String>(
        key: ValueKey('to_$symbol'),
        value: symbol,
        child: Text(
          '${localizations.isEnglish ? unit.nameEn : unit.nameEs} ($symbol)',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }).toList();
    
    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.isEnglish ? 'Practice Conversions' : 'Practica Conversiones',
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF8B5CF6), Color(0xFF6B46C1)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Input row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _practiceValueController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        labelText: localizations.isEnglish ? 'Value' : 'Valor',
                        labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white54),
                      ),
                      child: fromUnitItems.isEmpty 
                        ? const SizedBox(height: 48)
                        : DropdownButton<String>(
                            value: validFromUnit,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF6B46C1),
                            style: const TextStyle(color: Colors.white),
                            underline: const SizedBox(),
                            items: fromUnitItems,
                            onChanged: (value) {
                              if (value != null && value != _practiceFromUnit && allowedSymbols.contains(value) && value != _practiceToUnit) {
                                setState(() {
                                  _practiceFromUnit = value;
                                  _updatePracticeConversion();
                                });
                              }
                            },
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '=',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              const SizedBox(height: 20),
              // Output row with TTS
              GestureDetector(
                onTap: () {
                  final toUnit = MeasurementData.getUnitBySymbol(_practiceToUnit);
                  if (toUnit != null) {
                    _speakUnit(_practiceResult, toUnit, localizations);
                  }
                },
                child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                        '${_practiceResult.toStringAsFixed(4)} $_practiceToUnit',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.volume_up, color: Colors.white, size: 20),
                          ],
                      ),
                    ),
                  ),
                ],
                ),
              ),
              const SizedBox(height: 20),
              // To unit selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white54),
                ),
                child: toUnitItems.isEmpty
                  ? const SizedBox(height: 48)
                  : DropdownButton<String>(
                      value: toUnitItems.any((item) => item.value == validToUnit) ? validToUnit : toUnitItems.first.value,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF2E5B8A),
                      style: const TextStyle(color: Colors.white),
                      underline: const SizedBox(),
                      items: toUnitItems,
                      onChanged: (value) {
                        if (value != null && value != _practiceToUnit && value != _practiceFromUnit && toUnitItems.any((item) => item.value == value)) {
                          setState(() {
                            _practiceToUnit = value;
                            _updatePracticeConversion();
                          });
                        }
                      },
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Step-by-Step Explanation
        GestureDetector(
          onTap: () {
            setState(() {
              _showSteps = !_showSteps;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.isEnglish ? 'Step-by-Step Conversion' : 'Conversión Paso a Paso',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _showSteps ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (_showSteps) _buildStepByStepExplanation(localizations),
        const SizedBox(height: 20),
        
        // Visual Comparison
        _buildVisualComparison(localizations),
        const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStepByStepExplanation(AppLocalizations localizations) {
    final fromUnit = MeasurementData.getUnitBySymbol(_practiceFromUnit);
    final toUnit = MeasurementData.getUnitBySymbol(_practiceToUnit);
    if (fromUnit == null || toUnit == null) return const SizedBox();
    
    final value = double.tryParse(_practiceValueController.text) ?? 100.0;
    final meters = value * fromUnit.conversionToMeter;
    final result = meters / toUnit.conversionToMeter;
    
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          _buildStep(
            '1',
            localizations.isEnglish 
              ? 'Convert ${value.toStringAsFixed(2)} ${fromUnit.symbol} to meters'
              : 'Convertir ${value.toStringAsFixed(2)} ${fromUnit.symbol} a metros',
            '${value.toStringAsFixed(2)} ${fromUnit.symbol} × ${fromUnit.conversionToMeter} = ${meters.toStringAsFixed(4)} m',
            localizations,
          ),
          const SizedBox(height: 15),
          _buildStep(
            '2',
            localizations.isEnglish 
              ? 'Convert meters to ${toUnit.symbol}'
              : 'Convertir metros a ${toUnit.symbol}',
            '${meters.toStringAsFixed(4)} m ÷ ${toUnit.conversionToMeter} = ${result.toStringAsFixed(4)} ${toUnit.symbol}',
            localizations,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStep(String stepNum, String title, String calculation, AppLocalizations localizations) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNum,
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.fredoka(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                calculation,
                style: GoogleFonts.comicNeue(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildVisualComparison(AppLocalizations localizations) {
    final fromUnit = MeasurementData.getUnitBySymbol(_practiceFromUnit);
    final toUnit = MeasurementData.getUnitBySymbol(_practiceToUnit);
    if (fromUnit == null || toUnit == null) return const SizedBox();
    
    final value = double.tryParse(_practiceValueController.text) ?? 100.0;
    final result = _practiceResult;
    
    // Normalize for visual display (use percentage of max)
    final maxValue = value > result ? value : result;
    final fromWidth = (value / maxValue).clamp(0.1, 1.0);
    final toWidth = (result / maxValue).clamp(0.1, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            localizations.isEnglish ? 'Visual Comparison' : 'Comparación Visual',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // From unit bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${value.toStringAsFixed(2)} ${fromUnit.symbol}',
                    style: GoogleFonts.comicNeue(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => _speakUnit(value, fromUnit, localizations),
                    child: const Icon(Icons.volume_up, color: Colors.white, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: fromWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6B46C1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '=',
            style: GoogleFonts.fredoka(color: Color(0xFFFFD700), fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // To unit bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${result.toStringAsFixed(2)} ${toUnit.symbol}',
                    style: GoogleFonts.comicNeue(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => _speakUnit(result, toUnit, localizations),
                    child: const Icon(Icons.volume_up, color: Colors.white, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: toWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            localizations.isEnglish 
              ? 'These represent the SAME length in different units!'
              : '¡Estas representan la MISMA longitud en diferentes unidades!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingGame(AppLocalizations localizations) {
    // Generate new game if needed - do it immediately and trigger rebuild
    if (_objects.isEmpty && _cards.isEmpty) {
      // Generate immediately
      _generateNewRound();
      // Then trigger rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6B46C1),
            Color(0xFF8B5CF6),
            Color(0xFFA78BFA),
            Color(0xFFC4B5FD),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Simplified header for kids
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  localizations.isEnglish ? 'Match the Objects!' : '¡Empareja los Objetos!',
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4)],
                  ),
                ),
              ),
                
              // Score row
              _buildGameHeader(localizations),
              const SizedBox(height: 10),
              
              // Objects and cards area
              Expanded(
                child: _objects.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            // Left side: Objects (Targets)
                            Expanded(
                              flex: 1,
                              child: ListView(
                                children: _objects.map((obj) => _buildObject(obj, localizations)).toList(),
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Right side: Draggable cards
                            Expanded(
                              flex: 1,
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 columns instead of 3 for larger cards
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.85,
                                ),
                                itemCount: _cards.length,
                                itemBuilder: (context, index) {
                                  if (_cards[index].isMatched) return const SizedBox.shrink();
                                  return _buildDraggableCard(_cards[index], localizations);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          
          // Game complete overlay
          if (_gameComplete)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '🎉',
                      style: TextStyle(fontSize: 80),
                    ),
        const SizedBox(height: 20),
                    Text(
                      localizations.isEnglish ? 'Perfect Match!' : '¡Emparejaste Todo!',
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${localizations.isEnglish ? "Score" : "Puntos"}: $_score',
                      style: GoogleFonts.fredoka(
                        color: Colors.yellow,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_currentRound >= _totalRounds)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          localizations.isEnglish 
                            ? '🎉 Level $_level Complete! 🎉'
                            : '🎉 ¡Nivel $_level Completado! 🎉',
                          style: GoogleFonts.fredoka(
                            color: Colors.green,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Generate new round for current level
                          _generateNewRound();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        _currentRound >= _totalRounds
                          ? (localizations.isEnglish ? 'Next Level' : 'Siguiente Nivel')
                          : (localizations.isEnglish ? 'Next Round' : 'Siguiente Ronda'),
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: math.pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeighingGame(AppLocalizations localizations) {
    _ensureWeighingItems();
    final item = _weighingItems.isNotEmpty ? _weighingItems[_weighingIndex] : null;
    final name = item == null ? '' : (localizations.isEnglish ? item.nameEn : item.nameEs);
    if (item != null && _lastSpokenWeighingIndex != _weighingIndex) {
      _lastSpokenWeighingIndex = _weighingIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _speakPlain(
          localizations.isEnglish
              ? 'How many blocks does the ${item.nameEn} weigh?'
              : '¿Cuántos bloques pesa ${item.nameEs}?',
          language: localizations.isEnglish ? 'en' : 'es',
          interrupt: true,
        );
      });
    }

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _WeighingRoomPainter(),
          ),
        ),
        Positioned(
          top: 80,
          left: 30,
          child: _buildFloatingOrb(const Color(0xFFFFD700), 26),
        ),
        Positioned(
          top: 140,
          right: 40,
          child: _buildFloatingOrb(const Color(0xFF7CFFCB), 20),
        ),
        Positioned(
          bottom: 160,
          left: 20,
          child: _buildFloatingOrb(const Color(0xFFFF9EF5), 18),
        ),
        Column(
          children: [
            const SizedBox(height: 12),
            Text(
              localizations.isEnglish ? 'Weigh the Item!' : '¡Pesa el objeto!',
              style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              localizations.isEnglish
                  ? 'Add blocks until the scale feels balanced.'
                  : 'Agrega bloques hasta que la balanza se sienta equilibrada.',
              style: GoogleFonts.comicNeue(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (item != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Weighing3DView(
                      emoji: item.emoji,
                      blocks: _weighingSelected,
                      target: item.weightBlocks,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            _buildWeighingControls(localizations),
            const SizedBox(height: 10),
            if (_weighingFeedback.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _weighingFeedbackColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _weighingFeedbackColor, width: 2),
                ),
                child: Text(
                  _weighingFeedback,
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              localizations.isEnglish
                  ? 'Item ${_weighingIndex + 1} of ${_weighingItems.length}'
                  : 'Objeto ${_weighingIndex + 1} de ${_weighingItems.length}',
              style: GoogleFonts.comicNeue(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.2)],
        ),
        boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 12)],
      ),
    );
  }

  Widget _buildWeighingControls(AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _weighingSelected = (_weighingSelected - 1).clamp(1, 5);
            });
          },
          icon: const Icon(Icons.remove_circle, color: Colors.white),
          iconSize: 40,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange, width: 3),
          ),
          child: Text(
            '${_weighingSelected} ${localizations.isEnglish ? "blocks" : "bloques"}',
            style: GoogleFonts.fredoka(fontSize: 18, color: Colors.black87),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _weighingSelected = (_weighingSelected + 1).clamp(1, 5);
            });
          },
          icon: const Icon(Icons.add_circle, color: Colors.white),
          iconSize: 40,
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _onWeighingSubmit(localizations),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            localizations.isEnglish ? 'Check' : 'Comprobar',
            style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildWeighingScale({
    required String itemEmoji,
    required String itemLabel,
    required int targetBlocks,
    required int selectedBlocks,
  }) {
    final diff = (selectedBlocks - targetBlocks).clamp(-3, 3);
    final tilt = diff * 0.08;
    final leftLift = diff > 0 ? 10.0 : 0.0;
    final rightLift = diff < 0 ? 10.0 : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 14, offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          Text(
            itemLabel,
            style: GoogleFonts.fredoka(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(end: tilt),
            duration: const Duration(milliseconds: 250),
            builder: (context, value, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateZ(value),
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Beam
                Container(
                  width: 360,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                ),
                // Pivot
                Positioned(
                  bottom: -12,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.brown.shade600, width: 2),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  child: CustomPaint(
                    size: const Size(30, 22),
                    painter: _TrianglePainter(color: Colors.orange.shade400),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Transform.translate(
                    offset: Offset(0, leftLift),
                    child: _buildSpotlightObject(itemEmoji),
                  ),
                  const SizedBox(height: 8),
                  Transform.translate(
                    offset: Offset(0, leftLift),
                    child: _buildScalePlate(),
                  ),
                ],
              ),
              Column(
                children: [
                  Transform.translate(
                    offset: Offset(0, rightLift),
                    child: _build3DBlockStack(selectedBlocks),
                  ),
                  const SizedBox(height: 8),
                  Transform.translate(
                    offset: Offset(0, rightLift),
                    child: _buildScalePlate(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.brown.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScalePlate() {
    return Container(
      width: 180,
      height: 18,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade200, Colors.grey.shade500],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
    );
  }

  Widget _build3DBlockStack(int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: _build3DBlock(),
        ),
      ),
    );
  }

  Widget _build3DBlock() {
    return SizedBox(
      width: 84,
      height: 40,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 8,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade400,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 8,
            bottom: 8,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade200, Colors.orange.shade400],
                ),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.brown.shade500, width: 2),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 6,
            child: Container(
              width: 12,
              decoration: BoxDecoration(
                color: Colors.orange.shade700,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotlightObject(String emoji) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.white, Colors.yellow.shade100],
        ),
        boxShadow: [
          BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 72),
        ),
      ),
    );
  }

  Widget _buildWeighingLearnSection(AppLocalizations localizations) {
    final learnItems = <WeighingItem>[
      WeighingItem(emoji: '🍎', nameEn: 'Apple', nameEs: 'Manzana', weightBlocks: 1),
      WeighingItem(emoji: '🧸', nameEn: 'Teddy', nameEs: 'Osito', weightBlocks: 2),
      WeighingItem(emoji: '🍉', nameEn: 'Watermelon', nameEs: 'Sandía', weightBlocks: 4),
    ];
    final item = learnItems[_weighingLearnIndex.clamp(0, learnItems.length - 1)];
    final name = localizations.isEnglish ? item.nameEn : item.nameEs;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange, width: 3),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(
            localizations.isEnglish ? 'Count the blocks to weigh it' : 'Cuenta los bloques para pesarlo',
            style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 260,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Weighing3DView(
                emoji: item.emoji,
                blocks: _weighingLearnSelected,
                target: item.weightBlocks,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _weighingLearnDone
                    ? null
                    : () {
                        setState(() {
                          _weighingLearnSelected = (_weighingLearnSelected - 1).clamp(1, 5);
                        });
                      },
                icon: const Icon(Icons.remove_circle, color: Colors.orange),
                iconSize: 36,
              ),
              const SizedBox(width: 6),
              Text(
                '${_weighingLearnSelected} ${localizations.isEnglish ? "blocks" : "bloques"}',
                style: GoogleFonts.fredoka(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: _weighingLearnDone
                    ? null
                    : () {
                        setState(() {
                          _weighingLearnSelected = (_weighingLearnSelected + 1).clamp(1, 5);
                        });
                      },
                icon: const Icon(Icons.add_circle, color: Colors.orange),
                iconSize: 36,
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _weighingLearnDone
                    ? null
                    : () => _onWeighingLearnSubmit(item, localizations),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  localizations.isEnglish ? 'Check' : 'Comprobar',
                  style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_weighingLearnFeedback.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _weighingLearnFeedbackColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _weighingLearnFeedbackColor, width: 2),
              ),
              child: Text(
                _weighingLearnFeedback,
                style: GoogleFonts.comicNeue(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onWeighingLearnSubmit(WeighingItem item, AppLocalizations localizations) {
    if (_weighingLearnDone) return;
    final isCorrect = _weighingLearnSelected == item.weightBlocks;
    setState(() {
      if (isCorrect) {
        _weighingLearnFeedback = localizations.isEnglish ? 'Yes! It weighs ${item.weightBlocks} blocks.' : '¡Sí! Pesa ${item.weightBlocks} bloques.';
        _weighingLearnFeedbackColor = Colors.green;
        _speakPlain(
          localizations.isEnglish
              ? 'Yes! ${item.nameEn} weighs ${item.weightBlocks} blocks.'
              : '¡Sí! ${item.nameEs} pesa ${item.weightBlocks} bloques.',
          language: localizations.isEnglish ? 'en' : 'es',
          interrupt: true,
        );
      } else {
        _weighingLearnFeedback = localizations.isEnglish ? 'Try a different number.' : 'Intenta con otro número.';
        _weighingLearnFeedbackColor = Colors.orange;
        _speakPlain(
          localizations.isEnglish ? 'Try a different number.' : 'Intenta con otro número.',
          language: localizations.isEnglish ? 'en' : 'es',
          interrupt: true,
        );
      }
    });

    if (isCorrect) {
      _playCorrectSound();
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          if (_weighingLearnIndex >= 2) {
            _weighingLearnDone = true;
            _weighingLearnFeedback = localizations.isEnglish ? 'Great! You are ready to play.' : '¡Genial! Ya puedes jugar.';
            _weighingLearnFeedbackColor = Colors.green;
          } else {
            _weighingLearnIndex++;
            _weighingLearnSelected = 1;
            _weighingLearnFeedback = '';
            _weighingLearnFeedbackColor = Colors.transparent;
          }
        });
      });
    } else {
      _playWrongSound();
    }
  }
  
  Widget _buildObject(MeasurementObject object, AppLocalizations localizations) {
    return DragTarget<MeasurementCard>(
      onAccept: (card) {
        _onCardDropped(card, object);
      },
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            colors: object.isMatched
              ? [Colors.green.shade400, Colors.green.shade600]
              : isHighlighted
                ? [Color(0xFFC4B5FD), Color(0xFFA78BFA)]
                : [Color(0xFF8B5CF6), Color(0xFF6B46C1)],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: object.isMatched ? Colors.green : Colors.white,
              width: isHighlighted ? 4 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
      children: [
              // Try to show image, fallback to emoji if image doesn't exist
              _buildObjectImage(object),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                      object.name,
                      style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
                    const SizedBox(height: 5),
            Text(
                      '${object.value.toStringAsFixed(object.value == object.value.roundToDouble() ? 0 : 1)} ${object.unit.symbol}',
                      style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
              ),
              if (object.isMatched)
                Icon(Icons.check_circle, color: Colors.white, size: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildObjectImage(MeasurementObject object) {
    final imagePath = _getImagePath(object.name);
    
    // Try to load image, fallback to emoji if image doesn't exist
    if (imagePath.isNotEmpty) {
      return SizedBox(
        width: 60,
        height: 60,
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to emoji if image fails to load
            return Text(
              object.emoji,
              style: const TextStyle(fontSize: 50),
            );
          },
        ),
      );
    } else {
      // No image path, use emoji
      return Text(
        object.emoji,
        style: const TextStyle(fontSize: 50),
      );
    }
  }
  
  Widget _buildDraggableCard(MeasurementCard card, AppLocalizations localizations) {
    return Draggable<MeasurementCard>(
      data: card,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: Container(
            width: 90,
            height: 100,
      decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.pink.shade400, Colors.purple.shade600],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    card.unit.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${card.value.toStringAsFixed(card.value == card.value.roundToDouble() ? 0 : 1)} ${card.unit.symbol}',
                    style: GoogleFonts.comicNeue(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 90,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Center(
          child: Icon(Icons.drag_handle, size: 30, color: Colors.grey.shade700),
        ),
      ),
        child: Container(
          width: 90,
          height: 100,
          decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade400, Colors.purple.shade600],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  Text(
                    card.unit.emoji,
                    style: const TextStyle(fontSize: 34),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '${card.value.toStringAsFixed(card.value == card.value.roundToDouble() ? 0 : 1)} ${card.unit.symbol}',
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

    

  Widget _buildGameHeader(AppLocalizations localizations) {
    Level? levelData;
    if (widget.levelId != null) {
      levelData = LevelData.getLevel(widget.levelId!);
    }

    return Column(
      children: [
        if (levelData != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                Text(
                  levelData.getWorldTitle(localizations.isEnglish ? 'en' : 'es'),
                  style: GoogleFonts.fredoka(
                    color: Colors.amberAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    shadows: [Shadow(color: Colors.black26, offset: Offset(1,1), blurRadius: 2)],
                  ),
                ),
                Text(
                  levelData.getTitle(localizations.isEnglish ? 'en' : 'es'),
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().scale(),
          const SizedBox(height: 15),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildHeaderBadge('⭐', '$_score', Colors.orange),
            _buildHeaderBadge('🎯', '${localizations.isEnglish ? "Lvl" : "Nvl"} $_level', Colors.blue),
            _buildHeaderBadge('🏆', '${_currentRound + 1}/$_totalRounds', Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderBadge(String emoji, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), offset: const Offset(0, 4), blurRadius: 4),
          BoxShadow(color: Colors.white.withOpacity(0.3), offset: const Offset(0, -2), blurRadius: 0), // highlight
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.fredoka(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack);
  }

  Widget _buildGate(AppLocalizations localizations) {
    if (_currentGate == null) return const SizedBox();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gateOpen
            ? [Colors.green.withOpacity(0.4), Colors.green.withOpacity(0.2)]
            : [Colors.orange.withOpacity(0.3), Colors.orange.withOpacity(0.15)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _gateOpen ? Colors.green : Colors.orange,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (_gateOpen ? Colors.green : Colors.orange).withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _gateOpen ? '🚪✨' : '🎯',
            style: TextStyle(fontSize: _gateOpen ? 40 : 35),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizations.isEnglish
                  ? _gateOpen ? 'Gate Open! 🎉' : 'Find:'
                  : _gateOpen ? '¡Puerta Abierta! 🎉' : 'Encuentra:',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (!_gateOpen) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
                    '${_currentGate!.requiredValue.toStringAsFixed(_currentGate!.requiredValue == _currentGate!.requiredValue.roundToDouble() ? 0 : 1)} ${_currentGate!.requiredUnit.symbol}',
        style: GoogleFonts.comicNeue(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameInstructions(AppLocalizations localizations) {
    final instructionText = _currentMode == 'weighing'
        ? (localizations.isEnglish
            ? 'Add blocks to weigh the item!'
            : '¡Agrega bloques para pesar el objeto!')
        : (localizations.isEnglish
            ? '🎮 Tap cards to flip them! Find matching pairs! 🎮'
            : '🎮 ¡Toca las tarjetas para voltearlas! ¡Encuentra las parejas! 🎮');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.yellow.withOpacity(0.5), width: 2),
      ),
      child: Text(
        instructionText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  
  

  Widget _buildHeader(AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Column(
          children: [
            Text(
              '${localizations.score}: $_score',
              style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${localizations.level}: $_level',
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

}

// Expandable Unit Card Widget
class _ExpandableUnitCard extends StatefulWidget {
  final MeasurementUnit unit;
  final AppLocalizations localizations;
  final VoidCallback onTap;

  const _ExpandableUnitCard({
    required this.unit,
    required this.localizations,
    required this.onTap,
  });

  @override
  State<_ExpandableUnitCard> createState() => _ExpandableUnitCardState();
}

class _ExpandableUnitCardState extends State<_ExpandableUnitCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isExpanded
                ? [Color(0xFFC4B5FD), Color(0xFFA78BFA)]
                : [Color(0xFF8B5CF6), Color(0xFF6B46C1)],
            ),
            borderRadius: BorderRadius.circular(20),
                border: Border.all(
              color: _isExpanded ? const Color(0xFFFFD700) : Colors.white,
              width: _isExpanded ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              // Speak unit name when tapped
              widget.onTap();
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(widget.unit.emoji, style: const TextStyle(fontSize: 40)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.localizations.isEnglish ? widget.unit.nameEn : widget.unit.nameEs,
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                        ),
                        Text(
                          '(${widget.unit.symbol})',
                          style: GoogleFonts.comicNeue(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.localizations.isEnglish ? widget.unit.descriptionEn : widget.unit.descriptionEs,
                          style: GoogleFonts.comicNeue(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConversionRates(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConversionRates() {
    final allUnits = MeasurementData.getAllUnits();
    final otherUnits = allUnits.where((u) => u.symbol != widget.unit.symbol).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.localizations.isEnglish ? 'Conversion Rates:' : 'Tasas de Conversión:',
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        ...otherUnits.map((otherUnit) {
          final converted = MeasurementData.convert(1.0, widget.unit.symbol, otherUnit.symbol);
          return Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '1 ${widget.unit.symbol} = ',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${converted.toStringAsFixed(4)} ${otherUnit.symbol}',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
          ),
        );
      }).toList(),
      ],
    );
  }
}

// Comparison Tool Widget
class _ComparisonToolWidget extends StatefulWidget {
  final AppLocalizations localizations;
  final Function(double, MeasurementUnit) onSpeakUnit;

  const _ComparisonToolWidget({
    required this.localizations,
    required this.onSpeakUnit,
  });

  @override
  State<_ComparisonToolWidget> createState() => _ComparisonToolWidgetState();
}

class _ComparisonToolWidgetState extends State<_ComparisonToolWidget> {
  final TextEditingController _valueController = TextEditingController(text: '1');
  String _selectedUnit = 'm';

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final units = MeasurementData.getAllUnits();
    final value = double.tryParse(_valueController.text) ?? 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B5CF6), Color(0xFF6B46C1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            widget.localizations.isEnglish ? 'Compare Measurements' : 'Comparar Medidas',
            style: GoogleFonts.fredoka(
              color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.localizations.isEnglish 
              ? 'See how different units relate to each other!'
              : '¡Ve cómo se relacionan las diferentes unidades entre sí!',
          style: GoogleFonts.comicNeue(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
          Row(
            children: [
              Text(
                widget.localizations.isEnglish ? 'Show me:' : 'Muéstrame:',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _valueController,
                  style: GoogleFonts.comicNeue(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white54),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white54),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white54),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedUnit,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF2E5B8A),
                    style: const TextStyle(color: Colors.white),
                    underline: const SizedBox(),
                    items: units.map((unit) {
                      return DropdownMenuItem<String>(
                        value: unit.symbol,
                        child: Text(
                          '${widget.localizations.isEnglish ? unit.nameEn : unit.nameEs} (${unit.symbol})',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedUnit = value;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
        ),
        const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: units.where((u) => u.symbol != _selectedUnit).map((unit) {
              final converted = MeasurementData.convert(value, _selectedUnit, unit.symbol);
              return GestureDetector(
                onTap: () => widget.onSpeakUnit(converted, unit),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.localizations.isEnglish ? unit.nameEn : unit.nameEs,
                        style: GoogleFonts.fredoka(
                          color: Color(0xFFFFD700),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${converted.toStringAsFixed(2)} ${unit.symbol}',
                            style: GoogleFonts.comicNeue(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.volume_up, color: Colors.white, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Game data classes
class Treasure {
  final String emoji;
  final double value;
  final MeasurementUnit unit;
  final String id;
  final bool isCorrect;
  bool isCollected;
  
  Treasure({
    required this.emoji,
    required this.value,
    required this.unit,
    required this.id,
    required this.isCorrect,
    this.isCollected = false,
  });
}

class MeasurementObject {
  final int id;
  final String emoji;
  final String name;
  final double value;
  final MeasurementUnit unit;
  bool isMatched;
  
  MeasurementObject({
    required this.id,
    required this.emoji,
    required this.name,
    required this.value,
    required this.unit,
    this.isMatched = false,
  });
}

class MeasurementCard {
  final String id;
  final double value;
  final MeasurementUnit unit;
  final bool isCorrect;
  final int matchedObjectId;
  bool isMatched;
  
  MeasurementCard({
    required this.id,
    required this.value,
    required this.unit,
    required this.isCorrect,
    required this.matchedObjectId,
    this.isMatched = false,
  });
}

class WeighingItem {
  final String emoji;
  final String nameEn;
  final String nameEs;
  final int weightBlocks;

  WeighingItem({
    required this.emoji,
    required this.nameEn,
    required this.nameEs,
    required this.weightBlocks,
  });
}

class Gate {
  final double requiredValue;
  final MeasurementUnit requiredUnit;
  final String id;
  
  Gate({
    required this.requiredValue,
    required this.requiredUnit,
    required this.id,
  });
}


class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _WeighingRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF4C2C92), const Color(0xFF8B5CF6), const Color(0xFFC4B5FD)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), background);

    final floorTop = size.height * 0.6;
    final floorPaint = Paint()
      ..color = const Color(0xFF5C3B9C).withOpacity(0.8);
    canvas.drawRect(Rect.fromLTWH(0, floorTop, size.width, size.height - floorTop), floorPaint);

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 2;

    for (int i = 0; i < 8; i++) {
      final t = i / 8;
      final y = floorTop + (size.height - floorTop) * t;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    for (int i = 0; i < 8; i++) {
      final t = i / 8;
      final x = size.width * t;
      canvas.drawLine(Offset(x, floorTop), Offset(size.width / 2, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeighingRoomPainter oldDelegate) {
    return false;
  }
}

// Custom painter for game background
class _GameBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Sun
    final sunPaint = Paint()
      ..color = Color(0xFFFFF8DC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      size.width * 0.12,
      sunPaint,
    );
    
    // Sun rays
    final rayPaint = Paint()
      ..color = Color(0xFFFFF8DC).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final startX = size.width * 0.85 + math.cos(angle) * size.width * 0.12;
      final startY = size.height * 0.15 + math.sin(angle) * size.width * 0.12;
      final endX = size.width * 0.85 + math.cos(angle) * size.width * 0.18;
      final endY = size.height * 0.15 + math.sin(angle) * size.width * 0.18;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), rayPaint);
    }
    
    // Clouds
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    // Cloud 1
    _drawCloud(canvas, Offset(size.width * 0.2, size.height * 0.2), size.width * 0.15, cloudPaint);
    // Cloud 2
    _drawCloud(canvas, Offset(size.width * 0.6, size.height * 0.25), size.width * 0.12, cloudPaint);
    // Cloud 3
    _drawCloud(canvas, Offset(size.width * 0.4, size.height * 0.15), size.width * 0.10, cloudPaint);
    
    // Decorative circles (bubbles/particles)
    final bubblePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.5), 20, bubblePaint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.6), 15, bubblePaint);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.7), 25, bubblePaint);
    canvas.drawCircle(Offset(size.width * 0.95, size.height * 0.4), 18, bubblePaint);
  }
  
  void _drawCloud(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawCircle(Offset(center.dx - size * 0.3, center.dy), size * 0.4, paint);
    canvas.drawCircle(Offset(center.dx, center.dy), size * 0.5, paint);
    canvas.drawCircle(Offset(center.dx + size * 0.3, center.dy), size * 0.4, paint);
    canvas.drawCircle(Offset(center.dx - size * 0.15, center.dy - size * 0.2), size * 0.35, paint);
    canvas.drawCircle(Offset(center.dx + size * 0.15, center.dy - size * 0.2), size * 0.35, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ActiveBug {
  final String id;
  final double x;
  final double y;
  final String type; // 'target' or 'distractor'
  final String icon;
  
  ActiveBug({
    required this.id,
    required this.x,
    required this.y,
    required this.type,
    required this.icon,
  });
}

// Helper Painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    final double dashWidth = 5;
    final double dashSpace = 5;
    double startX = 0;
    
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height/2), Offset(startX + dashWidth, size.height/2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom Shape for Knife Slider
class _KnifeThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(40, 100);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    
    // Draw Knife Handle
    final handlePaint = Paint()..color = Colors.black;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: center.translate(0, -40), width: 20, height: 50), const Radius.circular(5)), 
      handlePaint
    );
    
    // Draw Blade
    final bladePaint = Paint()..color = Colors.grey.shade400;
    final path = Path();
    path.moveTo(center.dx - 5, center.dy - 20); // Top left of blade
    path.lineTo(center.dx + 5, center.dy - 20); // Top right
    path.lineTo(center.dx + 5, center.dy + 40); // Bottom right
    path.lineTo(center.dx, center.dy + 50);     // Tip
    path.lineTo(center.dx - 5, center.dy + 40); // Bottom left
    path.close();
    canvas.drawPath(path, bladePaint);
    
    // Shine on blade
    canvas.drawLine(Offset(center.dx+2, center.dy-10), Offset(center.dx+2, center.dy+30), Paint()..color=Colors.white.withOpacity(0.5)..strokeWidth=1);
  }
}

// Custom Painter for Knife Animation (used in the game screen, separate from slider)
class _KnifePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw Knife Handle
    final handlePaint = Paint()..color = Colors.black;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(size.width/2, 20), width: 25, height: 60), const Radius.circular(8)), 
      handlePaint
    );
    // Draw Blade
    final bladePaint = Paint()..color = Colors.grey.shade300..style = PaintingStyle.fill;
    final bladeOutline = Paint()..color = Colors.grey.shade600..style = PaintingStyle.stroke..strokeWidth = 2;
    
    final path = Path();
    path.moveTo(size.width/2 - 10, 50); // Top Left
    path.lineTo(size.width/2 + 10, 50); // Top Right
    path.lineTo(size.width/2 + 10, size.height - 10); // Bottom Right
    path.quadraticBezierTo(size.width/2, size.height + 10, size.width/2 - 10, size.height - 10); // Rounded Tip
    path.close();
    
    canvas.drawPath(path, bladePaint);
    canvas.drawPath(path, bladeOutline);
    
    // Shine
    final shinePaint = Paint()..color = Colors.white.withOpacity(0.6)..strokeWidth = 2;
    canvas.drawLine(Offset(size.width/2 + 5, 60), Offset(size.width/2 + 5, size.height - 20), shinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
