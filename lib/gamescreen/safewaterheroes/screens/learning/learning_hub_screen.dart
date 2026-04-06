import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../config/router.dart';
import '../../constants/game_data.dart';
import '../../models/lesson_content.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../widgets/tappable_text.dart';

class LearningHubScreen extends ConsumerWidget {
  const LearningHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    final completedLessons = ref.watch(userProgressProvider.select((s) => s.completedLessons));
    final isEs = lang == 'es';

    return Column(
      children: [
        TappableText(
          text: isEs ? 'Misiones de Aprendizaje' : 'Learning Missions',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive Grid: 3 columns on wide tablets, 2 on smaller tablets, 1 on phones
              final crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.9, // Taller cards
                ),
                itemCount: kAllLessons.length,
                itemBuilder: (context, index) {
                  final lesson = kAllLessons[index];
                  // Unlock logic: Lesson 1 unlocked. Others unlock if previous complete.
                  bool isUnlocked = index == 0 || completedLessons.contains(kAllLessons[index - 1].id);
                  bool isComplete = completedLessons.contains(lesson.id);

                  return _buildLessonCard(context, lesson, isUnlocked, isComplete, isEs, index);
                },
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(BuildContext context, Lesson lesson, bool isUnlocked, bool isComplete, bool isEs, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isUnlocked ? () {
          context.push('${AppRoutes.learningHub}/player/${lesson.id}');
        } : null,
        child: Stack(
          children: [
            // 1. Cover Image
            Positioned.fill(
              child: Image.asset(
                lesson.coverAssetPath,
                fit: BoxFit.cover,
                color: isUnlocked ? null : Colors.grey.withOpacity(0.8), // Darken if locked
                colorBlendMode: isUnlocked ? null : BlendMode.saturation,
              ),
            ),
            // 2. Gradient Overlay for text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            // 3. Content (Title and Status Icon)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Icon (Checkmark, Play, or Lock)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isComplete ? Colors.green : (isUnlocked ? AppTheme.accentOrange : Colors.grey[700]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isComplete ? Icons.check : (isUnlocked ? Icons.play_arrow : Icons.lock),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title Text
                  TappableText(
                    text: isEs ? lesson.titleEs : lesson.titleEn,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                   Text(
                    isEs ? "Lección ${lesson.id}" : "Lesson ${lesson.id}",
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms).slideY(begin: 0.1, end: 0);
  }
}