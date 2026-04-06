import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../constants/game_data.dart';
import '../../constants/assets.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../services/audio_controller.dart';
import '../../widgets/game_intro_banner.dart';
import '../../widgets/tappable_text.dart';

// --- STATE MACHINE ---
enum AdventurePhase {
  intro,     // Game start explanation
  entering,  // Kid walking in from LEFT to IDLE
  narrating, // Kid THINKING, Scene description spoken
  deciding,  // Kid ASKING, Question spoken, Buttons active
  feedback,  // Kid THINKING (or Happy), Explanation spoken
  exiting    // Kid WALKING out to RIGHT
}

// --- STRICT SCRIPT MODEL ---
class SceneScript {
  final String id;
  final String bgAsset;
  final WaterType correctAnswer;
  
  // Narration (Broken into lines for captioning)
  final List<String> narrationEn;
  final List<String> narrationEs;
  
  // The Question
  final String questionEn;
  final String questionEs;

  // Feedback (Correct)
  final List<String> correctEn;
  final List<String> correctEs;

  // Feedback (Wrong)
  final List<String> wrongEn;
  final List<String> wrongEs;

  const SceneScript({
    required this.id, required this.bgAsset, required this.correctAnswer,
    required this.narrationEn, required this.narrationEs,
    required this.questionEn, required this.questionEs,
    required this.correctEn, required this.correctEs,
    required this.wrongEn, required this.wrongEs,
  });
}

// --- EXACT DIALOGUE DATA ---
final List<SceneScript> _scenes = [
  SceneScript(
    id: 'pond',
    bgAsset: 'assets/safewaterheroes/images/scenes/scene_pond.png',
    correctAnswer: WaterType.needsFilter,
    narrationEn: [
      "We found a quiet pond.",
      "The water looks calm, but insects live here.",
      "Still water can grow tiny germs we cannot see."
    ],
    narrationEs: [
      "Encontramos un estanque tranquilo.",
      "El agua parece calmada, pero aquí viven insectos.",
      "El agua estancada puede criar gérmenes que no vemos."
    ],
    questionEn: "Can I drink this water?",
    questionEs: "¿Puedo beber esta agua?",
    correctEn: ["Correct!", "Pond water is not safe to drink directly.", "We must filter and boil it first."],
    correctEs: ["¡Correcto!", "El agua del estanque no es segura para beber directamente.", "Debemos filtrarla y hervirla primero."],
    wrongEn: ["Not quite.", "Even if it looks clear, germs might be hiding inside.", "It is safer to clean it first."],
    wrongEs: ["Casi.", "Aunque parezca clara, los gérmenes pueden esconderse.", "Es más seguro limpiarla primero."],
  ),
  SceneScript(
    id: 'river',
    bgAsset: 'assets/safewaterheroes/images/scenes/scene_river.png',
    correctAnswer: WaterType.needsFilter,
    narrationEn: [
      "Here is a big flowing river.",
      "It moves fast, which is good.",
      "But mud and dirt from faraway towns wash into it."
    ],
    narrationEs: [
      "Aquí hay un gran río que fluye.",
      "Se mueve rápido, lo cual es bueno.",
      "Pero el lodo y la suciedad de pueblos lejanos caen en él."
    ],
    questionEn: "Is it safe to drink?",
    questionEs: "¿Es seguro beberla?",
    correctEn: ["Great choice!", "River water carries dirt we cannot see.", "We should filter it to be safe."],
    correctEs: ["¡Gran elección!", "El agua de río lleva suciedad que no vemos.", "Debemos filtrarla para estar seguros."],
    wrongEn: ["Be careful.", "Running water can still carry dirt and germs.", "Let's try to make it safer."],
    wrongEs: ["Ten cuidado.", "El agua corriente aún puede llevar suciedad y gérmenes.", "Intentemos hacerla más segura."],
  ),
  SceneScript(
    id: 'stream',
    bgAsset: 'assets/safewaterheroes/images/scenes/scene_stream.png',
    correctAnswer: WaterType.needsFilter,
    narrationEn: [
      "Look at this small stream.",
      "It flows over rocks and looks sparkly.",
      "However, animals might step in the water upstream."
    ],
    narrationEs: [
      "Mira este pequeño arroyo.",
      "Fluye sobre rocas y brilla.",
      "Sin embargo, los animales pueden pisar el agua río arriba."
    ],
    questionEn: "Should I drink it?",
    questionEs: "¿Debería beberla?",
    correctEn: ["That is right.", "Animal waste can make the water unsafe.", "Always filter stream water."],
    correctEs: ["Es correcto.", "Los desechos de animales pueden hacer el agua insegura.", "Siempre filtra el agua de arroyo."],
    wrongEn: ["Not safe yet.", "Animals walk here.", "We don't want to get a tummy ache."],
    wrongEs: ["Aún no es segura.", "Los animales caminan aquí.", "No queremos dolor de estómago."],
  ),
  SceneScript(
    id: 'pump',
    bgAsset: 'assets/safewaterheroes/images/scenes/scene_pump.png',
    correctAnswer: WaterType.needsFilter,
    narrationEn: [
      "This is a village handpump.",
      "The water comes from deep underground.",
      "It is cleaner than the river, but the nozzle might be dirty."
    ],
    narrationEs: [
      "Esta es una bomba manual del pueblo.",
      "El agua viene de las profundidades.",
      "Es más limpia que el río, pero la boquilla podría estar sucia."
    ],
    questionEn: "Is this ready to drink?",
    questionEs: "¿Está lista para beber?",
    correctEn: ["Smart thinking.", "It is mostly clean, but filtering is the safest habit.", "Better safe than sorry!"],
    correctEs: ["Bien pensado.", "Está mayormente limpia, pero filtrar es el hábito más seguro.", "¡Mejor prevenir que curar!"],
    wrongEn: ["Almost.", "It is usually okay, but we should still be careful.", "Let's filter it to be sure."],
    wrongEs: ["Casi.", "Usualmente está bien, pero debemos tener cuidado.", "Filtrémosla para estar seguros."],
  ),
  SceneScript(
    id: 'tap',
    bgAsset: 'assets/safewaterheroes/images/scenes/scene_tap.png',
    correctAnswer: WaterType.safe,
    narrationEn: [
      "We found a community tap.",
      "This water comes from a clean tank.",
      "It has been treated to kill germs."
    ],
    narrationEs: [
      "Encontramos un grifo comunitario.",
      "Esta agua viene de un tanque limpio.",
      "Ha sido tratada para matar gérmenes."
    ],
    questionEn: "Can I drink this?",
    questionEs: "¿Puedo beber esto?",
    correctEn: ["Yes!", "Treated tap water is safe.", "Drink up and stay hydrated!"],
    correctEs: ["¡Sí!", "El agua de grifo tratada es segura.", "¡Bebe y mantente hidratado!"],
    wrongEn: ["Think again.", "This water was cleaned by the city.", "It is actually safe to drink!"],
    wrongEs: ["Piénsalo bien.", "Esta agua fue limpiada por la ciudad.", "¡En realidad es segura para beber!"],
  ),
  SceneScript(
    id: 'puddle',
    bgAsset: 'assets/safewaterheroes/images/scenes/scene_puddle.png',
    correctAnswer: WaterType.unsafe,
    narrationEn: [
      "Oh no. A muddy puddle on the ground.",
      "It is brown and dirty.",
      "Flies are buzzing around it."
    ],
    narrationEs: [
      "Oh no. Un charco de lodo en el suelo.",
      "Es marrón y sucio.",
      "Hay moscas zumbando alrededor."
    ],
    questionEn: "Should I touch this?",
    questionEs: "¿Debería tocar esto?",
    correctEn: ["Correct.", "Never drink from puddles.", "That water will make you sick."],
    correctEs: ["Correcto.", "Nunca bebas de charcos.", "Esa agua te enfermará."],
    wrongEn: ["Stop!", "That is definitely dangerous.", "Muddy water is full of bad germs."],
    wrongEs: ["¡Alto!", "Eso es definitivamente peligroso.", "El agua lodosa está llena de gérmenes malos."],
  ),
];

class AdventureGameScreen extends ConsumerStatefulWidget {
  const AdventureGameScreen({super.key});

  @override
  ConsumerState<AdventureGameScreen> createState() => _AdventureGameScreenState();
}

class _AdventureGameScreenState extends ConsumerState<AdventureGameScreen> with TickerProviderStateMixin {
  // --- STATE ---
  int _currentIndex = 0;
  AdventurePhase _phase = AdventurePhase.intro;
  
  // Character Positioning
  double _kidLeft = -300; // Start off-screen LEFT
  Duration _kidMoveDuration = Duration.zero; 
  
  // Captions
  String _captionText = "";
  bool _showConfetti = false;

  // Animation
  late AnimationController _walkBobController; 
  
  // Getters
  SceneScript get _currentScene => _scenes[_currentIndex];
  bool get _isButtonsEnabled => _phase == AdventurePhase.deciding;

  @override
  void initState() {
    super.initState();
    _walkBobController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 10.0, 
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage(_scenes[0].bgAsset), context);
      _runGameStart();
    });
  }

  @override
  void dispose() {
    _walkBobController.dispose();
    super.dispose();
  }

  // --- KID ASSET SWAP LOGIC ---
  String get _kidAsset {
    // Assets needed: kid_walking.png, kid_thinking.png, kid_asking.png
    if (_phase == AdventurePhase.entering || _phase == AdventurePhase.exiting || _phase == AdventurePhase.intro) {
      return AppAssets.kidWalking; 
    }
    if (_phase == AdventurePhase.deciding) {
      return 'assets/safewaterheroes/images/kid_asking.png'; // Assuming asset exists, fallback logic in builder
    }
    return 'assets/safewaterheroes/images/kid_thinking.png'; // Narrating or Feedback
  }

  // --- AUDIO QUEUE HELPER (AWAITABLE) ---
  Future<void> _speakLine(String text) async {
    if (!mounted) return;
    
    // 1. Update Caption
    setState(() => _captionText = text);

    // 2. Speak & Await Completion (using the upgraded AudioController)
    await ref.read(audioControllerProvider).speakAndWait(text);
  }

  // --- GAME FLOW (ASYNC SEQUENCE) ---

  Future<void> _runGameStart() async {
    setState(() {
      _phase = AdventurePhase.intro;
      _kidLeft = -300; 
      _kidMoveDuration = Duration.zero; 
    });

    final lang = ref.read(appSettingsProvider).languageCode;
    
    // Intro Lines
    final lines = lang == 'es' 
      ? ["¡Vamos a una aventura!", "Ayúdame a decidir qué agua es segura."]
      : ["Let's go on an adventure!", "Help me decide which water is safe."];

    for (final line in lines) {
      await _speakLine(line);
    }
    
    _runSceneFlow();
  }

  Future<void> _runSceneFlow() async {
    if (!mounted) return;
    final lang = ref.read(appSettingsProvider).languageCode;
    final screenWidth = MediaQuery.of(context).size.width;
    final idleX = screenWidth * 0.12; 

    // 1. RESET POSITION (Instant)
    setState(() {
      _captionText = ""; // Clear caption
      _kidLeft = -300; 
      _kidMoveDuration = Duration.zero; 
    });
    await Future.delayed(const Duration(milliseconds: 50)); 

    // 2. ENTERING (Walk In)
    setState(() {
      _phase = AdventurePhase.entering;
      _kidLeft = idleX;
      _kidMoveDuration = const Duration(seconds: 2);
    });
    _walkBobController.repeat(reverse: true);
    
    // Precache next
    if (_currentIndex + 1 < _scenes.length) {
      precacheImage(AssetImage(_scenes[_currentIndex + 1].bgAsset), context);
    }

    await Future.delayed(const Duration(seconds: 2));

    // 3. NARRATION (Thinking)
    if (!mounted) return;
    setState(() {
      _phase = AdventurePhase.narrating;
      _captionText = "";
    });
    _walkBobController.animateTo(0);

    // Play all narration lines
    final lines = lang == 'es' ? _currentScene.narrationEs : _currentScene.narrationEn;
    for (final line in lines) {
      await _speakLine(line);
    }

    // 4. QUESTION (Asking)
    if (!mounted) return;
    _askQuestion();
  }

  Future<void> _askQuestion() async {
    setState(() => _phase = AdventurePhase.deciding);
    final lang = ref.read(appSettingsProvider).languageCode;
    final q = lang == 'es' ? _currentScene.questionEs : _currentScene.questionEn;
    await _speakLine(q);
    // Now waiting for user tap...
  }

  void _handleUserChoice(WaterType choice) async {
    if (_phase != AdventurePhase.deciding) return;

    final isCorrect = choice == _currentScene.correctAnswer;
    final lang = ref.read(appSettingsProvider).languageCode;

    setState(() => _phase = AdventurePhase.feedback);

    if (isCorrect) {
      // --- CORRECT ---
      setState(() => _showConfetti = true);
      ref.read(userProgressProvider.notifier).addCoins(5);

      final lines = lang == 'es' ? _currentScene.correctEs : _currentScene.correctEn;
      for (final line in lines) {
        await _speakLine(line);
      }

      setState(() {
        _showConfetti = false;
        _captionText = "";
      });
      
      await _runExitSequence();

    } else {
      // --- WRONG ---
      final lines = lang == 'es' ? _currentScene.wrongEs : _currentScene.wrongEn;
      for (final line in lines) {
        await _speakLine(line);
      }
      
      // Retry
      if (mounted) _askQuestion();
    }
  }

  Future<void> _runExitSequence() async {
    if (!mounted) return;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 1. EXITING
    setState(() {
      _phase = AdventurePhase.exiting;
      _kidLeft = screenWidth + 200; // Walk off RIGHT
      _kidMoveDuration = const Duration(seconds: 2);
      _captionText = "";
    });
    _walkBobController.repeat(reverse: true);

    await Future.delayed(const Duration(seconds: 2));

    // 2. SWITCH
    if (_currentIndex < _scenes.length - 1) {
      setState(() {
        _currentIndex++; 
      });
      _runSceneFlow(); 
    } else {
      _showGameComplete();
    }
  }

  void _showGameComplete() {
    final lang = ref.read(appSettingsProvider).languageCode;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(lang == 'es' ? "¡Aventura Completada!" : "Adventure Complete!"),
        content: const Icon(Icons.emoji_events, size: 80, color: Colors.orange),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/games'); 
            }, 
            child: const Text("OK")
          )
        ],
      )
    );
  }

  // --- UI HELPERS ---

  Alignment _getBgAlignment() {
    if (_phase == AdventurePhase.entering) return const Alignment(-0.3, 0.0);
    if (_phase == AdventurePhase.exiting) return const Alignment(0.3, 0.0);
    return const Alignment(0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. BACKGROUND
          AnimatedAlign(
            duration: const Duration(seconds: 3),
            alignment: _getBgAlignment(),
            curve: Curves.easeInOutSine,
            child: SizedBox(
              width: screenWidth * 1.1, 
              height: double.infinity,
              child: Image.asset(
                _currentScene.bgAsset,
                key: ValueKey(_currentScene.id),
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.blue.shade100),
                gaplessPlayback: true,
              ),
            ),
          ),

          // 2. CHARACTER
          AnimatedPositioned(
            duration: _kidMoveDuration,
            curve: Curves.linear,
            bottom: 120, 
            left: _kidLeft,
            child: AnimatedBuilder(
              animation: _walkBobController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_walkBobController.value), 
                  child: Image.asset(
                    _kidAsset, 
                    height: 200,
                    errorBuilder: (c,e,s) => Image.asset(AppAssets.kidWalking, height: 200), // Fallback
                  ),
                );
              },
            ),
          ),

          // 3. CLOUD CAPTION (NEW)
          if (_captionText.isNotEmpty && (_phase == AdventurePhase.narrating || _phase == AdventurePhase.deciding || _phase == AdventurePhase.feedback || _phase == AdventurePhase.intro))
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              // Position cloud relative to Kid's idle position
              left: (screenWidth * 0.12) + 120, // To right of kid
              bottom: 250, // Above kid
              child: Container(
                width: 250,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/safewaterheroes/images/cloud.png'), // Ensure this asset exists!
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: Text(
                    _captionText,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
              ).animate().fadeIn().scale(),
            ),

          // 4. TOP BANNER (Optional, maybe for phase name or simple instruction)
          // Removed the old big banner, relying on Caption Cloud now as requested.
          
          // 5. BOTTOM CHOICE BAR
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              height: 120, 
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChoiceBtn(WaterType.safe, lang == 'es' ? "SEGURO" : "SAFE", Icons.check_circle, Colors.green),
                  _buildChoiceBtn(WaterType.needsFilter, lang == 'es' ? "FILTRO" : "FILTER", Icons.water_drop, Colors.orange),
                  _buildChoiceBtn(WaterType.unsafe, lang == 'es' ? "PELIGRO" : "UNSAFE", Icons.dangerous, Colors.red),
                ],
              ),
            ),
          ),

          // 6. FIRECRACKER CONFETTI
          if (_showConfetti)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 0, right: 0,
              child: SizedBox(
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(20, (i) {
                    final angle = (i * 18) * (pi / 180); 
                    final dist = 150.0;
                    return Container(
                      width: 15, height: 15,
                      decoration: BoxDecoration(
                        color: [Colors.red, Colors.amber, Colors.blue, Colors.green][i % 4],
                        shape: BoxShape.circle
                      ),
                    ).animate()
                     .move(begin: const Offset(0,0), end: Offset(cos(angle)*dist, sin(angle)*dist), duration: 800.ms, curve: Curves.easeOutQuad)
                     .fadeOut(delay: 400.ms, duration: 400.ms)
                     .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5));
                  }),
                ),
              ),
            ),

          // 7. PROGRESS DOTS
          Positioned(
            bottom: 5, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_scenes.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index <= _currentIndex ? AppTheme.accentOrange : Colors.grey.shade400,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Smaller Buttons (~100 width)
  Widget _buildChoiceBtn(WaterType type, String label, IconData icon, Color color) {
    final isEnabled = _phase == AdventurePhase.deciding;
    
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => _handleUserChoice(type) : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 100, // Reduced width
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: color.withOpacity(0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: color), // Smaller Icon
                const SizedBox(height: 4),
                Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}