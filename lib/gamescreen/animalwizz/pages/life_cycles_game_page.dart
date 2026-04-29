import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import 'package:supersetfirebase/provider/language_provider.dart';

class LifeCyclesGamePage extends StatefulWidget {
  final String animal;
  const LifeCyclesGamePage({super.key, required this.animal});

  @override
  State<LifeCyclesGamePage> createState() => _LifeCyclesGamePageState();
}

class _LifeCyclesGamePageState extends State<LifeCyclesGamePage>
    with TickerProviderStateMixin {
  final FlutterTts tts = FlutterTts();
  late ConfettiController _confettiController;

  bool get _isSpanish => context.read<LanguageProvider>().isSpanish;

  final Map<String, List<Map<String, String>>> sequences = {
    'Butterfly': [
      {'stage': 'Egg', 'image': 'assets/animalwizz/images/butterfly_eggs.jpg'},
      {'stage': 'Caterpillar', 'image': 'assets/animalwizz/images/caterpillar.jpg'},
      {'stage': 'Chrysalis', 'image': 'assets/animalwizz/images/chrysalis.jpg'},
      {
        'stage': 'Adult Butterfly',
        'image': 'assets/animalwizz/images/adult_butterfly.jpg',
      },
    ],
    'Frog': [
      {'stage': 'Egg', 'image': 'assets/animalwizz/images/frog_egg.jpg'},
      {'stage': 'Tadpole', 'image': 'assets/animalwizz/images/tadpole.jpg'},
      {'stage': 'Tadpole with Legs', 'image': 'assets/animalwizz/images/froglet.jpg'},
      {'stage': 'Adult Frog', 'image': 'assets/animalwizz/images/frog_adult.jpg'},
    ],
  };

  final Map<String, Map<String, String>> narrations = {
    'Butterfly': {
      'en':
          'A butterfly’s life starts as an egg, then caterpillar, chrysalis, and finally a butterfly!',
      'es':
          'La vida de una mariposa comienza como un huevo, luego oruga, crisálida y finalmente mariposa.',
    },
    'Frog': {
      'en':
          'A frog begins as an egg, becomes a tadpole, then grows legs, and becomes a frog!',
      'es':
          'Una rana comienza como un huevo, se convierte en renacuajo, desarrolla patas y se convierte en rana.',
    },
  };

  final Map<String, Map<String, Map<String, String>>> stageLessons = {
    'Butterfly': {
      'Egg': {
        'en': 'The butterfly lays eggs on leaves.',
        'es': 'La mariposa pone huevos en las hojas.',
      },
      'Caterpillar': {
        'en': 'The egg hatches into a caterpillar.',
        'es': 'El huevo se convierte en oruga.',
      },
      'Chrysalis': {
        'en': 'The caterpillar forms a chrysalis.',
        'es': 'La oruga forma una crisálida.',
      },
      'Adult Butterfly': {
        'en': 'It emerges as a beautiful butterfly.',
        'es': 'Emergió como una hermosa mariposa.',
      },
    },
    'Frog': {
      'Egg': {
        'en': 'Frogs begin life as eggs in water.',
        'es': 'Las ranas comienzan como huevos en el agua.',
      },
      'Tadpole': {
        'en': 'The egg hatches into a tadpole.',
        'es': 'El huevo se convierte en renacuajo.',
      },
      'Tadpole with Legs': {
        'en': 'Tadpoles grow legs over time.',
        'es': 'Los renacuajos desarrollan patas con el tiempo.',
      },
      'Adult Frog': {
        'en': 'It becomes an adult frog that lives on land and water.',
        'es': 'Se convierte en una rana adulta que vive en tierra y agua.',
      },
    },
  };

  List<String> userProgress = [];
  String? lastTappedStage;
  final Map<String, bool> shake = {};
  final Map<String, bool> bounce = {};

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    tts.stop();
    super.dispose();
  }

  void _speak(String text) async {
    await tts.setLanguage(_isSpanish ? 'es-ES' : 'en-US');
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }

  void _resetGame() {
    tts.stop();
    setState(() {
      userProgress = [];
      lastTappedStage = null;
      shake.clear();
      bounce.clear();
    });
  }

  void _handleDrop(String droppedStage, int targetIndex) {
    final correctSequence =
        sequences[widget.animal]!.map((s) => s['stage']!).toList();

    if (correctSequence[targetIndex] == droppedStage) {
      setState(() {
        bounce[droppedStage] = true;
        userProgress.insert(targetIndex, droppedStage);
        lastTappedStage = droppedStage;
      });

      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => bounce[droppedStage] = false);
      });

      final lessonText =
          stageLessons[widget.animal]?[droppedStage]?[_isSpanish ? 'es' : 'en'];
      if (lessonText != null) _speak(lessonText);

      if (userProgress.length == correctSequence.length) {
        _confettiController.play();
        _speak(narrations[widget.animal]![_isSpanish ? 'es' : 'en']!);
      }
    } else {
      setState(() => shake[droppedStage] = true);
      _speak(_isSpanish ? 'Inténtalo de nuevo' : 'Try again');
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => shake[droppedStage] = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();

    final options = List<Map<String, String>>.from(sequences[widget.animal]!);
    final correctStages = options.map((e) => e['stage']!).toList();
    final stageImages = {
      for (var item in options) item['stage']!: item['image']!,
    };

    final completed = userProgress.length == correctStages.length;
    final titleText = _isSpanish
        ? 'Ciclo de Vida: ${widget.animal}'
        : '${widget.animal} Life Cycle';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(titleText),
        backgroundColor: Colors.green.shade800,
        actions: [
          IconButton(
            tooltip: _isSpanish ? 'Reiniciar' : 'Reset',
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/animalwizz/images/forest_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDropRow(correctStages, stageImages),
                  const SizedBox(height: 28),
                  if (!completed)
                    _buildDraggableRow(correctStages, stageImages),
                  if (completed) _buildCompletionBadge(),
                  const SizedBox(height: 20),
                  if (lastTappedStage != null) _buildLessonPanel(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              maxBlastForce: 20,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropRow(
    List<String> correctStages,
    Map<String, String> stageImages,
  ) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: correctStages.asMap().entries.map((entry) {
        final index = entry.key;
        final stage = entry.value;
        final filled =
            userProgress.length > index && userProgress[index] == stage;

        return DragTarget<String>(
          builder: (context, candidateData, rejectedData) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              transform: bounce[stage] == true
                  ? Matrix4.translationValues(0, -10.0, 0)
                  : Matrix4.identity(),
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(
                  color: candidateData.isNotEmpty
                      ? Colors.amber.shade700
                      : Colors.brown,
                  width: candidateData.isNotEmpty ? 4 : 3,
                ),
                color: filled
                    ? Colors.green.shade100
                    : Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  if (filled)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: Image.asset(
                        stageImages[stage]!,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Center(
                      child: Text(
                        '?',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade400,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade800,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          onWillAcceptWithDetails: (_) => true,
          onAcceptWithDetails: (details) => _handleDrop(details.data, index),
        );
      }).toList(),
    );
  }

  Widget _buildDraggableRow(
    List<String> correctStages,
    Map<String, String> stageImages,
  ) {
    final remaining =
        correctStages.where((stage) => !userProgress.contains(stage)).toList();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 16,
      children: remaining.map((stage) {
        final image = stageImages[stage]!;
        return Draggable<String>(
          data: stage,
          feedback: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(image, width: 130, height: 130, fit: BoxFit.cover),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _buildDraggableCard(image),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            transform: shake[stage] == true
                ? Matrix4.translationValues(10.0, 0, 0)
                : Matrix4.identity(),
            child: _buildDraggableCard(image),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDraggableCard(String imagePath) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCompletionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Text(
        _isSpanish ? '¡Bien hecho! 🎉' : 'Great job! 🎉',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLessonPanel() {
    final lesson =
        stageLessons[widget.animal]?[lastTappedStage!]?[_isSpanish ? 'es' : 'en'] ??
            '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade900, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Text(
        lesson,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
