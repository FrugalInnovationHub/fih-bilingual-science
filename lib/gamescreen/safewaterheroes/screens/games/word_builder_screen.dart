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

class _WordBuilderScreenState extends ConsumerState<WordBuilderScreen> {
  final Random _random = Random();
  late final ConfettiController _confettiController;
  final Map<int, _LetterTileData> _placedTiles = <int, _LetterTileData>{};

  late List<_LetterTileData> _tiles;
  int _wordIndex = 0;
  bool _isComplete = false;

  WordBuilderWord get _currentWord => kWordBuilderWords[_wordIndex];
  List<String> get _currentLetters => _currentWord.word.toUpperCase().split('');

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _resetBoard();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _speakCurrentWord();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

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
    if (_isComplete || _placedTiles.containsKey(slotIndex)) {
      return;
    }

    setState(() {
      _placedTiles[slotIndex] = tile;
    });

    final audioController = ref.read(audioControllerProvider);
    await audioController.speakAndWait(tile.letter.toLowerCase());

    if (_placedTiles.length == _currentLetters.length) {
      setState(() {
        _isComplete = true;
      });
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
      if (mounted) {
        _speakCurrentWord();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final tileSize = constraints.maxWidth < 720 ? 56.0 : 68.0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppTheme.textDark,
                      iconSize: 32,
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Back',
                    ),
                    Expanded(
                      child: TappableText(
                        text: 'Word Builder',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.textDark,
                                  fontWeight: FontWeight.w900,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 18),
                _buildPronunciationCard(context),
                const SizedBox(height: 24),
                TappableText(
                  text: 'Build the word with the letter tiles below.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                _buildDropZone(tileSize),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withOpacity(0.18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.darkerBlue.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.extension_rounded,
                              color: AppTheme.accentOrange,
                              size: tileSize * 0.5,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Letter Tray',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 14,
                                runSpacing: 14,
                                children: _tiles
                                    .where(
                                      (tile) => !_placedTiles.values.any(
                                        (placedTile) => placedTile.id == tile.id,
                                      ),
                                    )
                                    .map(
                                      (tile) => Draggable<_LetterTileData>(
                                        data: tile,
                                        feedback: Material(
                                          color: Colors.transparent,
                                          child: _LetterTile(
                                            letter: tile.letter,
                                            size: tileSize,
                                            isFloating: true,
                                          ),
                                        ),
                                        childWhenDragging: Opacity(
                                          opacity: 0.22,
                                          child: _LetterTile(
                                            letter: tile.letter,
                                            size: tileSize,
                                          ),
                                        ),
                                        child: _LetterTile(
                                          letter: tile.letter,
                                          size: tileSize,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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

  Widget _buildPronunciationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkerBlue.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Listen, then spell the word.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.darkerBlue,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _speakCurrentWord,
            icon: const Icon(Icons.volume_up_rounded),
            label: const Text('Pronounce Word'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
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

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: tileSize,
                      height: tileSize + 6,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: placedTile != null
                            ? AppTheme.primaryBlue.withOpacity(0.16)
                            : isHighlighted
                                ? AppTheme.accentOrange.withOpacity(0.18)
                                : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: placedTile != null
                              ? AppTheme.primaryBlue
                              : isHighlighted
                                  ? AppTheme.accentOrange
                                  : AppTheme.primaryBlue.withOpacity(0.35),
                          width: isHighlighted ? 3 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        placedTile?.letter ?? '',
                        style: TextStyle(
                          fontSize: tileSize * 0.44,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.darkerBlue,
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

class _LetterTile extends StatelessWidget {
  final String letter;
  final double size;
  final bool isFloating;

  const _LetterTile({
    required this.letter,
    required this.size,
    this.isFloating = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFE9F8FF),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkerBlue.withOpacity(isFloating ? 0.24 : 0.12),
            blurRadius: isFloating ? 18 : 10,
            offset: Offset(0, isFloating ? 10 : 5),
          ),
        ],
      ),
      child: Text(
        letter,
        style: TextStyle(
          color: AppTheme.darkerBlue,
          fontSize: size * 0.44,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

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
