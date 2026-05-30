import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/router.dart';
import '../../config/theme.dart';
import '../../constants/assets.dart';
import '../../providers/app_settings_provider.dart';
import '../../widgets/tappable_text.dart';

class LearnFiltersScreen extends ConsumerWidget {
  const LearnFiltersScreen({super.key});

  static const String _regularFilterCover =
      'assets/safewaterheroes/images/Regular_filter_Cover.png';
  static const String _osmosisFilterCover =
      AppAssets.osmosisFilterCover;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    final isEs = lang == 'es';

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.learningHub);
                }
              },
            ),
            Expanded(
              child: TappableText(
                text: isEs ? 'Aprende a hacer filtros' : 'Learn to Make Filters',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.9,
                ),
                children: [
                  _buildFilterLessonCard(
                    context,
                    isEs,
                    titleEn: 'Build a Regular Filter',
                    titleEs: 'Construye un filtro regular',
                    coverPath: _regularFilterCover,
                    onTap: () => context.push(
                      '${AppRoutes.learningHub}/${AppRoutes.regularFilterLesson}',
                    ),
                  ),
                  _buildFilterLessonCard(
                    context,
                    isEs,
                    titleEn: 'Build an Osmosis Filter',
                    titleEs: 'Construye un filtro de ósmosis',
                    subtitle: 'Lesson 2 • 6 Steps',
                    coverPath: _osmosisFilterCover,
                    onTap: () => context.push(
                      '${AppRoutes.learningHub}/${AppRoutes.osmosisFilterLesson}',
                    ),
                  ),
                  _buildFilterLessonCard(
                    context,
                    isEs,
                    titleEn: 'Build a Distillation Filter',
                    titleEs: 'Construye un filtro de destilación',
                    subtitle: 'Lesson 3 • 6 Steps',
                    coverPath: AppAssets.distillationFilterCover,
                    onTap: () => context.push(
                      '${AppRoutes.learningHub}/${AppRoutes.distillationFilterLesson}',
                    ),
                  ),
                  _buildFilterLessonCard(
                    context,
                    isEs,
                    titleEn: 'Build a UV Filter',
                    titleEs: 'Construye un filtro UV',
                    subtitle: 'Lesson 4 • 6 Steps',
                    coverPath: AppAssets.uvFilterCover,
                    onTap: () => context.push(
                      '${AppRoutes.learningHub}/${AppRoutes.uvFilterLesson}',
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterLessonCard(
    BuildContext context,
    bool isEs, {
    required String titleEn,
    required String titleEs,
    required String coverPath,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                coverPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade400,
                    alignment: Alignment.center,
                    child: Icon(Icons.filter_alt, size: 64, color: Colors.grey.shade700),
                  );
                },
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppTheme.accentOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 12),
                  TappableText(
                    text: isEs ? titleEs : titleEn,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 50.ms).slideY(begin: 0.1, end: 0);
  }
}
