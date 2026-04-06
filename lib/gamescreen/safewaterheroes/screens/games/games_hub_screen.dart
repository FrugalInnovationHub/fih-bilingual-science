import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../constants/assets.dart';
import '../../providers/app_settings_provider.dart';
import '../../widgets/tappable_text.dart';
import '../../config/router.dart';


class GamesHubScreen extends ConsumerWidget {
  const GamesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    final isEs = lang == 'es';

    return Column(
      children: [
        TappableText(
          text: isEs ? 'Centro de Juegos' : 'Games Hub',
          style: Theme.of(context).textTheme.headlineSmall,
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
}