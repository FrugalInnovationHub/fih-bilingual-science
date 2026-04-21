import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../constants/assets.dart';
import '../../providers/app_settings_provider.dart';
import '../../widgets/tappable_text.dart';
import '../../config/router.dart';
import 'word_builder_screen.dart';


class GamesHubScreen extends ConsumerWidget {
  const GamesHubScreen({super.key});

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
                text: isEs ? 'Centro de Juegos' : 'Games Hub',
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
              // Adapt grid count based on width
              final crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.8,
                children: [
                  _buildGameCard(context, isEs ? "Clasificación de Agua" : "Water Sorting", AppAssets.gameSorting, AppRoutes.gameSorting),
                  _buildGameCard(context, isEs ? "Crear un Filtro" : "Filter Making", AppAssets.gameFilter, AppRoutes.gameFilter),
                  _buildGameCard(context, isEs ? "Aventura del Agua" : "Water Adventure", AppAssets.gameAdventure, AppRoutes.gameAdventure),
                  _buildWordBuilderCard(
                    context,
                    isEs ? "Constructor de Palabras" : "Word Builder",
                  ),
                ],
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String imgPath, String route) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('${AppRoutes.gamesHub}/$route'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(imgPath, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TappableText(text: title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Icon(Icons.play_circle_fill, color: AppTheme.accentOrange, size: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordBuilderCard(BuildContext context, String title) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const WordBuilderScreen(),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFBEEBFF),
                      Color(0xFFEAFBFF),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.darkerBlue.withOpacity(0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _MiniLetterTile(letter: 'W'),
                        SizedBox(width: 8),
                        _MiniLetterTile(letter: 'O'),
                        SizedBox(width: 8),
                        _MiniLetterTile(letter: 'R'),
                        SizedBox(width: 8),
                        Icon(
                          Icons.volume_up_rounded,
                          color: AppTheme.accentOrange,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TappableText(
                      text: title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.play_circle_fill,
                    color: AppTheme.accentOrange,
                    size: 40,
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

class _MiniLetterTile extends StatelessWidget {
  final String letter;

  const _MiniLetterTile({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.35)),
      ),
      child: Text(
        letter,
        style: const TextStyle(
          color: AppTheme.darkerBlue,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
    );
  }
}
