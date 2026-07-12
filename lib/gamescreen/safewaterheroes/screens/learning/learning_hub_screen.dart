import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/router.dart';
import '../../providers/app_settings_provider.dart';
import '../../widgets/tappable_text.dart';

class LearningHubScreen extends ConsumerWidget {
  const LearningHubScreen({super.key});

  static const String _section1Cover =
      'assets/safewaterheroes/images/Learning_Section1_Cover.webp';
  static const String _section2Cover =
      'assets/safewaterheroes/images/Learning_Section2_Cover.webp';

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
                  context.go(AppRoutes.dashboard);
                }
              },
            ),
            Expanded(
              child: TappableText(
                text: isEs ? 'Misiones de Aprendizaje' : 'Learning Missions',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 0.75,
                    child: GestureDetector(
                      onTap: () => context.push(
                        '${AppRoutes.learningHub}/${AppRoutes.waterLessons}',
                      ),
                      child: _buildHubCard(
                        coverImagePath: _section1Cover,
                        title: isEs
                            ? 'Aprende sobre el agua'
                            : 'Learn About Water',
                        subtitle: isEs
                            ? '¡Descubre datos asombrosos del agua!'
                            : 'Discover amazing water facts!',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 0.75,
                    child: GestureDetector(
                      onTap: () => context.push(
                        '${AppRoutes.learningHub}/${AppRoutes.filterLessons}',
                      ),
                      child: _buildHubCard(
                        coverImagePath: _section2Cover,
                        title: isEs
                            ? 'Aprende a hacer filtros'
                            : 'Learn to Make Filters',
                        subtitle: isEs
                            ? '¡Construye tu propio filtro de agua!'
                            : 'Build your own water filter!',
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
  }
}

Widget _buildHubCard({
  required String coverImagePath,
  required String title,
  required String subtitle,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // Cover image fills the whole card
          Positioned.fill(
            child: Image.asset(
              coverImagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: const Color(0xFF0288D1).withOpacity(0.2),
                child: const Icon(Icons.image_not_supported,
                    color: Color(0xFF0288D1), size: 48),
              ),
            ),
          ),

          // Dark gradient overlay at bottom for text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
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
              ),
            ),
          ),

          // Play button bottom right
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFFFB300),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    ),
  );
}
