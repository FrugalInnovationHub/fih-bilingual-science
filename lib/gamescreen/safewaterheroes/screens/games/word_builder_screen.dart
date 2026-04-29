import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../data/word_builder_words.dart';
import '../../services/audio_controller.dart';
import '../../widgets/tappable_text.dart';

class WordBuilderScreen extends ConsumerStatefulWidget {
  const WordBuilderScreen({super.key});

  @override
  ConsumerState<WordBuilderScreen> createState() => _WordBuilderScreenState();
}

class _WordBuilderScreenState extends ConsumerState<WordBuilderScreen>
    with TickerProviderStateMixin {
  final Random _random = Random();
  late final ConfettiController _confettiController;
  final Map<int, _LetterTileData> _placedTiles = <int, _LetterTileData>{};

  late List<_LetterTileData> _tiles;
  int _wordIndex = 0;
  bool _isComplete = false;

  // Animation controllers
  late final AnimationController _bgController;
  late final AnimationController _arrowController;

  // Emoji cycling for pronunciation card
  int _emojiIndex = 0;
  static const _emojis = ['👂', '🎵', '🔊'];

  WordBuilderWord get _currentWord => kWordBuilderWords[_wordIndex];
  List<String> get _currentLetters => _currentWord.word.toUpperCase().split('');

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _startEmojiCycle();
    _resetBoard();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _speakCurrentWord();
    });
  }

  void _startEmojiCycle() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _emojiIndex = (_emojiIndex + 1) % _emojis.length);
        _startEmojiCycle();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bgController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  // ─── Game logic — untouched ────────────────────────────────────────────────

  void _resetBoard() {
    final correctTiles = List<_LetterTileData>.generate(
      _currentLetters.length,
      (index) => _LetterTileData(
        id: 'word-$_wordIndex-slot-$index',
        letter: _currentLetters[index],
        correctIndex: index,
      ),
    );

    final distractors = _buildDistractorLetters();
    final distractorTiles = List<_LetterTileData>.generate(
      distractors.length,
      (index) => _LetterTileData(
        id: 'word-$_wordIndex-distractor-$index',
        letter: distractors[index],
        correctIndex: null,
      ),
    );

    _tiles = [...correctTiles, ...distractorTiles]..shuffle(_random);
    _placedTiles.clear();
    _isComplete = false;
  }

  List<String> _buildDistractorLetters() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final usedLetters = _currentLetters.toSet();
    final availableLetters = alphabet
        .split('')
        .where((letter) => !usedLetters.contains(letter))
        .toList()
      ..shuffle(_random);
    return availableLetters.take(3).toList();
  }

  void _speakCurrentWord() {
    ref.read(audioControllerProvider).requestSpeak(_currentWord.word);
  }

  Future<void> _handleLetterAccepted(
    int slotIndex,
    _LetterTileData tile,
  ) async {
    if (_isComplete || _placedTiles.containsKey(slotIndex)) return;

    setState(() {
      _placedTiles[slotIndex] = tile;
    });

    final audioController = ref.read(audioControllerProvider);
    await audioController.speakAndWait(tile.letter.toLowerCase());

    if (_placedTiles.length == _currentLetters.length) {
      setState(() => _isComplete = true);
      _confettiController.play();
      await audioController.speakAndWait(_currentWord.word);
    }
  }

  void _goToNextWord() {
    setState(() {
      _wordIndex = (_wordIndex + 1) % kWordBuilderWords.length;
      _resetBoard();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _speakCurrentWord();
    });
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated underwater background
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _bgController,
            builder: (context, _) => CustomPaint(
              painter: _UnderwaterBgPainter(progress: _bgController.value),
            ),
          ),
        ),

        // Game content
        LayoutBuilder(
          builder: (context, constraints) {
            const tileSize = 64.0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                // Back bar + title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: Colors.white,
                      iconSize: 32,
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Back',
                    ),
                    Expanded(
                      child: TappableText(
                        text: '🌊 Word Builder',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              shadows: const [
                                Shadow(
                                  color: Color(0xFF01579B),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildPronunciationCard(context),
                          const SizedBox(height: 20),
                          _buildDropZoneSection(tileSize),
                          const SizedBox(height: 20),
                          _buildLetterTray(tileSize),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Confetti overlay
        Positioned.fill(
          child: IgnorePointer(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: pi / 2,
                    emissionFrequency: 0.05,
                    numberOfParticles: 24,
                    gravity: 0.18,
                    shouldLoop: false,
                    colors: const [
                      AppTheme.primaryBlue,
                      AppTheme.accentOrange,
                      AppTheme.darkerBlue,
                      Colors.white,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: 0,
                    emissionFrequency: 0.03,
                    numberOfParticles: 18,
                    gravity: 0.12,
                    shouldLoop: false,
                    colors: const [
                      AppTheme.primaryBlue,
                      AppTheme.accentOrange,
                      Colors.white,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: pi,
                    emissionFrequency: 0.03,
                    numberOfParticles: 18,
                    gravity: 0.12,
                    shouldLoop: false,
                    colors: const [
                      AppTheme.primaryBlue,
                      AppTheme.accentOrange,
                      Colors.white,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_isComplete) _buildCompletionOverlay(context),
      ],
    );
  }

  // ─── Section builders ──────────────────────────────────────────────────────

  Widget _buildPronunciationCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            const Color(0xFFE1F5FE).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0288D1).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFF4FC3F7), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: Text(
                  _emojis[_emojiIndex],
                  key: ValueKey(_emojiIndex),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 8),
              const Flexible(
                child: Text(
                  'Listen, then spell the word!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0277BD),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8F00).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: _speakCurrentWord,
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.volume_up_rounded, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Pronounce Word',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _arrowController,
            builder: (context, _) => Transform.translate(
              offset: Offset(0, _arrowController.value * 6),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF0277BD).withOpacity(0.5),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropZoneSection(double tileSize) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD54F).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🗺️', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'Build the word!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0277BD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropZone(tileSize),
        ],
      ),
    );
  }

  Widget _buildDropZone(double tileSize) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              _currentLetters.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: DragTarget<_LetterTileData>(
                  onWillAccept: (tile) {
                    return !_isComplete &&
                        tile != null &&
                        tile.correctIndex == index &&
                        !_placedTiles.containsKey(index);
                  },
                  onAccept: (tile) {
                    _handleLetterAccepted(index, tile);
                  },
                  builder: (context, candidateData, rejectedData) {
                    final placedTile = _placedTiles[index];
                    final isHighlighted = candidateData.isNotEmpty;

                    if (placedTile != null) {
                      return _PlacedLetterSlot(
                        letter: placedTile.letter,
                        size: tileSize,
                      );
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: tileSize,
                      height: tileSize + 6,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? AppTheme.accentOrange.withOpacity(0.18)
                            : Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isHighlighted
                              ? AppTheme.accentOrange
                              : const Color(0xFFFFD54F),
                          width: isHighlighted ? 3 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD54F).withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        '⭐',
                        style: TextStyle(
                          fontSize: tileSize * 0.32,
                          color: Colors.amber.withOpacity(0.35),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterTray(double tileSize) {
    final visibleTiles = _tiles
        .where((tile) => !_placedTiles.values.any((p) => p.id == tile.id))
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0288D1).withOpacity(0.85),
            const Color(0xFF01579B).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF01579B).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🧩', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text(
                'Letter Tray',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: visibleTiles.asMap().entries.map((entry) {
              final idx = entry.key;
              final tile = entry.value;
              return Draggable<_LetterTileData>(
                data: tile,
                feedback: Material(
                  color: Colors.transparent,
                  child: _BobbingLetterTile(
                    letter: tile.letter,
                    tileIndex: idx,
                    isFloating: true,
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.22,
                  child: _BobbingLetterTile(
                    letter: tile.letter,
                    tileIndex: idx,
                  ),
                ),
                child: _BobbingLetterTile(
                  letter: tile.letter,
                  tileIndex: idx,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Completion overlay — logic unchanged, only minor visual polish
  Widget _buildCompletionOverlay(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.white.withOpacity(0.58),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.darkerBlue.withOpacity(0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.celebration_rounded,
                  size: 72,
                  color: AppTheme.accentOrange,
                ),
                const SizedBox(height: 16),
                Text(
                  'Great spelling!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.darkerBlue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You built the word with all the right letters.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textDark,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8FF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withOpacity(0.28),
                    ),
                  ),
                  child: Text(
                    _currentWord.word.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.darkerBlue,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                ElevatedButton.icon(
                  onPressed: _goToNextWord,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Next Word'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Placed letter slot (pop-in scale animation) ──────────────────────────────

class _PlacedLetterSlot extends StatefulWidget {
  final String letter;
  final double size;

  const _PlacedLetterSlot({required this.letter, required this.size});

  @override
  State<_PlacedLetterSlot> createState() => _PlacedLetterSlotState();
}

class _PlacedLetterSlotState extends State<_PlacedLetterSlot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: widget.size,
        height: widget.size + 6,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF29B6F6), Color(0xFF0277BD)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0288D1).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          widget.letter,
          style: TextStyle(
            fontSize: widget.size * 0.44,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ─── Bobbing letter tile with hover scale ─────────────────────────────────────

class _BobbingLetterTile extends StatefulWidget {
  final String letter;
  final int tileIndex;
  final bool isFloating;

  const _BobbingLetterTile({
    required this.letter,
    required this.tileIndex,
    this.isFloating = false,
  });

  @override
  State<_BobbingLetterTile> createState() => _BobbingLetterTileState();
}

class _BobbingLetterTileState extends State<_BobbingLetterTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bobCtrl;
  bool _hovered = false;

  static const _tileSize = 64.0;

  @override
  void initState() {
    super.initState();
    final ms = 1500 + (widget.tileIndex % 5) * 200;
    _bobCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ms),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bobCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.12 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedBuilder(
          animation: _bobCtrl,
          builder: (context, _) {
            final bobY = _bobCtrl.value * -4.0;
            return Transform.translate(
              offset: Offset(0, bobY),
              child: Container(
                width: _tileSize,
                height: _tileSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Color(0xFFE1F5FE)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        widget.isFloating ? 0.22 : 0.15,
                      ),
                      blurRadius: widget.isFloating ? 10 : 6,
                      offset: Offset(0, widget.isFloating ? 6 : 3),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 4,
                      offset: const Offset(-1, -1),
                    ),
                  ],
                ),
                child: Text(
                  widget.letter,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0277BD),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Underwater background CustomPainter ─────────────────────────────────────

class _UnderwaterBgPainter extends CustomPainter {
  const _UnderwaterBgPainter({required this.progress});

  final double progress;

  static const _bubbles = <_BubbleSpec>[
    _BubbleSpec(0.10, 0.05, 0.18, 7),
    _BubbleSpec(0.22, 0.20, 0.22, 12),
    _BubbleSpec(0.35, 0.55, 0.16, 9),
    _BubbleSpec(0.48, 0.10, 0.24, 6),
    _BubbleSpec(0.58, 0.70, 0.19, 14),
    _BubbleSpec(0.68, 0.38, 0.21, 8),
    _BubbleSpec(0.76, 0.12, 0.17, 11),
    _BubbleSpec(0.85, 0.45, 0.23, 7),
    _BubbleSpec(0.92, 0.30, 0.15, 10),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Gradient background
    final rect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF87CEEB),
          Color(0xFF29B6F6),
          Color(0xFF0288D1),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // Rising bubbles
    for (final b in _bubbles) {
      final cycle = (progress * b.speed + b.offset) % 1.0;
      final y = size.height + b.radius - cycle * (size.height + 60);
      final x = size.width * b.x +
          sin((progress * pi * 2) + b.offset * 6) * 10;
      final paint = Paint()..color = Colors.white.withOpacity(0.18);
      canvas.drawCircle(Offset(x, y), b.radius, paint);
      canvas.drawCircle(
        Offset(x - b.radius * 0.3, y - b.radius * 0.3),
        b.radius * 0.3,
        Paint()..color = Colors.white.withOpacity(0.28),
      );
    }

    // Fish 1 — small orange, top area
    final f1Phase = progress * pi * 2;
    _drawFish(
      canvas,
      Offset(
        size.width * (0.15 + 0.12 * sin(f1Phase)),
        size.height * 0.15,
      ),
      const Size(32, 16),
      const Color(0xFFFF8A65),
      cos(f1Phase) > 0,
    );

    // Fish 2 — small blue, bottom area
    final f2Phase = progress * pi * 2 + pi;
    _drawFish(
      canvas,
      Offset(
        size.width * (0.80 + 0.10 * sin(f2Phase)),
        size.height * 0.80,
      ),
      const Size(28, 14),
      const Color(0xFF4FC3F7),
      cos(f2Phase) > 0,
    );
  }

  void _drawFish(
    Canvas canvas,
    Offset center,
    Size size,
    Color color,
    bool movingRight,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (movingRight) canvas.scale(-1, 1);

    final body = Path()
      ..moveTo(-size.width * 0.35, 0)
      ..quadraticBezierTo(0, -size.height * 0.55, size.width * 0.32, 0)
      ..quadraticBezierTo(0, size.height * 0.55, -size.width * 0.35, 0)
      ..close();

    final tail = Path()
      ..moveTo(size.width * 0.22, 0)
      ..lineTo(size.width * 0.45, -size.height * 0.35)
      ..lineTo(size.width * 0.45, size.height * 0.35)
      ..close();

    canvas.drawPath(body, Paint()..color = color.withOpacity(0.92));
    canvas.drawPath(tail, Paint()..color = color.withOpacity(0.82));
    canvas.drawCircle(
      Offset(-size.width * 0.18, -2),
      2.0,
      Paint()..color = Colors.white.withOpacity(0.9),
    );
    canvas.drawCircle(
      Offset(-size.width * 0.18, -2),
      1.0,
      Paint()..color = Colors.black87,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _UnderwaterBgPainter old) =>
      old.progress != progress;
}

class _BubbleSpec {
  const _BubbleSpec(this.x, this.offset, this.speed, this.radius);

  final double x;
  final double offset;
  final double speed;
  final double radius;
}

// ─── Data class — untouched ───────────────────────────────────────────────────

class _LetterTileData {
  final String id;
  final String letter;
  final int? correctIndex;

  const _LetterTileData({
    required this.id,
    required this.letter,
    required this.correctIndex,
  });
}
