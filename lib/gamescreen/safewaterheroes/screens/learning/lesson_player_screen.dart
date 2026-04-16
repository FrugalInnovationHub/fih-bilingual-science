import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../../config/router.dart';
import '../../config/theme.dart';
import '../../constants/game_data.dart';
import '../../models/lesson_content.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../services/audio_controller.dart';
import '../../widgets/tappable_text.dart';

class LessonPlayerScreen extends ConsumerStatefulWidget {
  final int lessonId;
  const LessonPlayerScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _showConfetti = false;
  final Set<int> _viewedPages = {};

  Lesson get _lesson => kAllLessons.firstWhere((l) => l.id == widget.lessonId);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _onPageViewed(0);
      }
    });
  }

  void _onPageViewed(int index) {
    if (mounted) {
      setState(() => _currentPage = index);
    }
    
    final lang = ref.read(appSettingsProvider).languageCode;
    final text = lang == 'es' ? _lesson.cards[index].textEs : _lesson.cards[index].textEn;

    ref.read(audioControllerProvider).requestSpeak(text);

    if (!_viewedPages.contains(index)) {
      _viewedPages.add(index);
      ref.read(userProgressProvider.notifier).addCoins(1);
    }
  }

  void _nextPage() {
    if (_currentPage < _lesson.cards.length - 1) {
      _pageController.nextPage(duration: 300.ms, curve: Curves.easeInOut);
    } else {
      _handleCompletion();
    }
  }

  void _handleCompletion() {
    ref.read(userProgressProvider.notifier).markLessonComplete(widget.lessonId);
    setState(() => _showConfetti = true);
    
    Future.delayed(1.seconds, () {
      if (mounted) {
        _showCompletionDialog();
      }
    });
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.learningHub);
    }
  }

  Future<void> _showCompletionDialog() async {
  final currentLessonIndex = kAllLessons.indexOf(_lesson);
  final hasPrevious = currentLessonIndex > 0;
  final hasNext = currentLessonIndex < kAllLessons.length - 1;
  final lang = ref.read(appSettingsProvider).languageCode;

  // ✅ Capture the lesson screen context (NOT the dialog context)
  final screenContext = context;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            lang == 'es' ? '¡Lección Completada!' : 'Lesson Complete!',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events_rounded, size: 80, color: AppTheme.accentOrange),
              const SizedBox(height: 16),
              Text(
                lang == 'es' ? '¡Gran trabajo, héroe!' : 'Great job, Hero!',
                textAlign: TextAlign.center,
                style: Theme.of(screenContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialogButton(
                    icon: Icons.arrow_back_rounded,
                    label: lang == 'es' ? 'Anterior' : 'Previous',
                    // PREVIOUS
                    onPressed: hasPrevious
                        ? () {
                            final prevId = kAllLessons[currentLessonIndex - 1].id;

                            // close dialog first
                            Navigator.of(dialogContext).pop();

                            // navigate AFTER the dialog closes
                            Future.microtask(() {
                              if (!mounted) return;
                              GoRouter.of(screenContext).go('/learning/player/$prevId');
                            });
                          }
                        : null,
                  ),

                  _buildDialogButton(
                    icon: Icons.exit_to_app_rounded,
                    label: lang == 'es' ? 'Salir' : 'Exit',
                    // EXIT
                    onPressed: () {
                      Navigator.of(dialogContext).pop();

                      Future.microtask(() {
                        if (!mounted) return;
                        GoRouter.of(screenContext).go('/learning'); // go back to LearningHub
                      });
                    },
                    isPrimary: false,
                  ),

                  _buildDialogButton(
                    icon: Icons.arrow_forward_rounded,
                    label: lang == 'es' ? 'Siguiente' : 'Next',
                    // NEXT
                    onPressed: hasNext
                        ? () {
                            final nextId = kAllLessons[currentLessonIndex + 1].id;

                            // close dialog first
                            Navigator.of(dialogContext).pop();

                            // navigate AFTER the dialog closes
                            Future.microtask(() {
                              if (!mounted) return;
                              GoRouter.of(screenContext).go('/learning/player/$nextId');
                            });
                          }
                        : null,
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildDialogButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    final color = isPrimary ? AppTheme.accentOrange : AppTheme.primaryBlue;
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              elevation: onPressed == null ? 0 : 4,
            ),
            child: Icon(icon, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    final currentCardData = _lesson.cards[_currentPage];

    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: _handleBack,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TappableText(
                      text: lang == 'es' ? _lesson.titleEs : _lesson.titleEn,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / _lesson.cards.length,
                backgroundColor: Colors.white,
                color: AppTheme.accentOrange,
              ),
            ),
            
            // CARD SECTION
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _lesson.cards.length,
                onPageChanged: _onPageViewed, 
                itemBuilder: (context, index) {
                  final cardData = _lesson.cards[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 8,
                      // White background so containment looks clean
                      color: Colors.white, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          cardData.imageAssetPath,
                          // CHANGED: Use contain to ensure 16:9 images are fully visible
                          fit: BoxFit.contain, 
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ).animate().fadeIn().slideX(begin: 0.1, end: 0),
                  );
                },
              ),
            ),

            // TEXT SECTION BELOW CARD
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
              child: Container(
                constraints: const BoxConstraints(minHeight: 80),
                child: Center(
                  child: TappableText(
                    text: lang == 'es' ? currentCardData.textEs : currentCardData.textEn,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ).animate(key: ValueKey(_currentPage)).fadeIn(),
              ),
            ),

            // CONTROLS
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 40, color: AppTheme.primaryBlue),
                      onPressed: () => _pageController.previousPage(duration: 300.ms, curve: Curves.easeInOut),
                    )
                  else const SizedBox(width: 48),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3))),
                    child: Text("${_currentPage + 1} / ${_lesson.cards.length}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                  ),
                  
                  IconButton(
                    icon: Icon(_currentPage == _lesson.cards.length - 1 ? Icons.check_circle_rounded : Icons.arrow_forward_ios_rounded, size: 40, color: AppTheme.accentOrange),
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_showConfetti)
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                 children: List.generate(50, (index) {
                   final random = Random(index);
                   return Positioned(
                     left: random.nextDouble() * MediaQuery.of(context).size.width,
                     top: -20,
                     child: Container(width: 10, height: 10, color: [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange][random.nextInt(5)])
                     .animate()
                     .moveY(begin: 0, end: MediaQuery.of(context).size.height, duration: (random.nextInt(3)+2).seconds)
                     .fadeOut(delay: 2.seconds),
                   );
                 }),
              ),
            ),
          ),
      ],
    );
  }
}
