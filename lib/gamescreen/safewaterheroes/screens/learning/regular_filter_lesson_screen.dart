import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/router.dart';
import '../../config/theme.dart';
import '../../constants/assets.dart';
import '../../services/audio_controller.dart';
import '../../widgets/tappable_text.dart';

class _RegularFilterSlide {
  const _RegularFilterSlide({
    required this.imageAssetPath,
    required this.audioLine,
  });

  final String imageAssetPath;
  final String audioLine;
}

const List<_RegularFilterSlide> _kRegularFilterSlides = [
  _RegularFilterSlide(
    imageAssetPath: AppAssets.l11c1,
    audioLine: 'A filter cleans dirty water and makes it safe to drink!',
  ),
  _RegularFilterSlide(
    imageAssetPath: AppAssets.l11c2,
    audioLine: 'You will need a bottle, pebbles, charcoal, sand, and cloth!',
  ),
  _RegularFilterSlide(
    imageAssetPath: AppAssets.l11c3,
    audioLine: 'First, place the cloth at the very bottom of the bottle!',
  ),
  _RegularFilterSlide(
    imageAssetPath: AppAssets.l11c4,
    audioLine: 'Next, pour sand on top of the cloth to catch tiny dirt!',
  ),
  _RegularFilterSlide(
    imageAssetPath: AppAssets.l11c5,
    audioLine: 'Now add charcoal on top of the sand to fight germs!',
  ),
  _RegularFilterSlide(
    imageAssetPath: AppAssets.l11c6,
    audioLine: 'Finally add pebbles at the top — your filter is ready!',
  ),
];

/// Loads bytes first so a bad/missing manifest entry does not throw through
/// [Image.asset] on web (avoids red screen while still showing a fallback).
class _RegularFilterSlideImage extends StatefulWidget {
  const _RegularFilterSlideImage({
    required this.assetPath,
    required this.slideNumber,
    required this.audioLine,
  });

  final String assetPath;
  final int slideNumber;
  final String audioLine;

  @override
  State<_RegularFilterSlideImage> createState() => _RegularFilterSlideImageState();
}

class _RegularFilterSlideImageState extends State<_RegularFilterSlideImage> {
  late Future<ByteData> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = rootBundle.load(widget.assetPath);
  }

  @override
  void didUpdateWidget(covariant _RegularFilterSlideImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _loadFuture = rootBundle.load(widget.assetPath);
    }
  }

  Widget _placeholder() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Slide ${widget.slideNumber}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.audioLine,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ByteData>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return _placeholder();
        }
        final bytes = snapshot.data!.buffer.asUint8List();
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      },
    );
  }
}

class _RegularFilterCompletionDialog extends StatelessWidget {
  const _RegularFilterCompletionDialog({
    required this.confettiController,
    required this.onExit,
    required this.onContinueNext,
  });

  final ConfettiController confettiController;
  final VoidCallback onExit;
  final VoidCallback onContinueNext;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.05,
                    numberOfParticles: 22,
                    gravity: 0.2,
                    shouldLoop: false,
                    maxBlastForce: 20,
                    minBlastForce: 9,
                    colors: const [
                      Color(0xFF4FC3F7),
                      Color(0xFFFFD54F),
                      Color(0xFF66BB6A),
                      Color(0xFFFF7043),
                      Color(0xFFEC407A),
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
            AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.emoji_events_rounded, size: 56, color: AppTheme.accentOrange),
                  SizedBox(height: 12),
                  Text(
                    'Good job!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You finished Build a Regular Filter.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'What would you like to do next?',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onContinueNext,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.accentOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Continue',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onExit,
                    child: const Text(
                      'Exit',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegularFilterLessonScreen extends ConsumerStatefulWidget {
  const RegularFilterLessonScreen({super.key});

  @override
  ConsumerState<RegularFilterLessonScreen> createState() =>
      _RegularFilterLessonScreenState();
}

class _RegularFilterLessonScreenState extends ConsumerState<RegularFilterLessonScreen> {
  late final PageController _pageController;
  late final ConfettiController _confettiController;
  bool _showingCompletion = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_speakSlide(0));
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _speakSlide(int i) async {
    if (!mounted || i < 0 || i >= _kRegularFilterSlides.length) return;
    final audio = ref.read(audioControllerProvider);
    audio.stop();
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (!mounted) return;
    await audio.speakAndWait(_kRegularFilterSlides[i].audioLine);
  }

  void _onPageChanged(int i) {
    setState(() => _index = i);
    unawaited(_speakSlide(i));
  }

  Future<void> _onFinishPressed() async {
    final lastIndex = _kRegularFilterSlides.length - 1;
    if (!mounted || _showingCompletion || _index != lastIndex) return;
    setState(() => _showingCompletion = true);
    try {
      await _showCompletionDialog();
    } finally {
      if (mounted) {
        setState(() => _showingCompletion = false);
      }
    }
  }

  Future<void> _showCompletionDialog() async {
    if (!mounted) return;
    final lastIndex = _kRegularFilterSlides.length - 1;
    if (_index != lastIndex) return;

    final screenContext = context;
    ref.read(audioControllerProvider).stop();
    _confettiController.play();

    await showDialog<void>(
      context: screenContext,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (dialogContext) {
        return _RegularFilterCompletionDialog(
          confettiController: _confettiController,
          onExit: () {
            Navigator.of(dialogContext).pop();
            Future.microtask(() {
              if (!screenContext.mounted) return;
              if (screenContext.canPop()) {
                screenContext.pop();
              } else {
                GoRouter.of(screenContext).go(
                  '${AppRoutes.learningHub}/${AppRoutes.filterLessons}',
                );
              }
            });
          },
          onContinueNext: () {
            Navigator.of(dialogContext).pop();
            Future.microtask(() {
              if (!screenContext.mounted) return;
              GoRouter.of(screenContext).go(
                '${AppRoutes.learningHub}/${AppRoutes.waterLessons}',
              );
            });
          },
        );
      },
    );

    if (mounted) {
      _confettiController.stop();
    }
  }

  void _goBack() {
    if (_index > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('${AppRoutes.learningHub}/${AppRoutes.filterLessons}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _kRegularFilterSlides[_index];
    final total = _kRegularFilterSlides.length;
    final isLast = _index == total - 1;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: _goBack,
            ),
            Expanded(
              child: TappableText(
                text: 'Build a Regular Filter',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '${_index + 1} of $total',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue.withOpacity(0.85),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: total,
                physics: const BouncingScrollPhysics(),
                onPageChanged: _onPageChanged,
                itemBuilder: (context, i) {
                  final s = _kRegularFilterSlides[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Center(
                      child: _RegularFilterSlideImage(
                        assetPath: s.imageAssetPath,
                        slideNumber: i + 1,
                        audioLine: s.audioLine,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 24,
                child: Center(
                  child: IconButton(
                    iconSize: 48,
                    color: AppTheme.primaryBlue,
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: _index > 0
                        ? () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                        : null,
                  ),
                ),
              ),
              if (!isLast)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 24,
                  child: Center(
                    child: IconButton(
                      iconSize: 48,
                      color: AppTheme.primaryBlue,
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, isLast ? 8 : 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              slide.audioLine,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0277BD),
              ),
            ),
          ),
        ),
        if (isLast)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _showingCompletion ? null : _onFinishPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.accentOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Finish',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
