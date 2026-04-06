import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/router.dart';
import '../config/theme.dart';
import '../constants/strings.dart';
import '../constants/assets.dart';
import '../providers/app_settings_provider.dart';
import '../widgets/tappable_text.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a GridView for better responsive layout of big cards
        final crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
        
        return Column(
          children: [
            const SizedBox(height: 20),
            // Mascot greeting area
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.mascot, height: 120)
                   .animate(onPlay: (c) => c.repeat(reverse: true))
                   .moveY(begin: 0, end: -10, duration: 2.seconds, curve: Curves.easeInOut),
                 const SizedBox(width: 20),
                 Flexible(
                   child: TappableText(
                     text: "Welcome back, Hero!",
                     style: Theme.of(context).textTheme.headlineSmall,
                   ),
                 ),
              ],
            ),
            const SizedBox(height: 40),
            // Main Cards Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: crossAxisCount == 1 ? 1.5 : 0.8, // Taller on wide screens
                children: [
                  _buildVisualCard(context, AppStrings.get('dashboardBtnLearning', lang), Icons.school, AppAssets.lessonCover1, AppRoutes.learningHub, 0),
                  _buildVisualCard(context, AppStrings.get('dashboardBtnGames', lang), Icons.videogame_asset, AppAssets.gameAdventure, AppRoutes.gamesHub, 1),
                  _buildVisualCard(context, AppStrings.get('dashboardBtnProgress', lang), Icons.bar_chart, AppAssets.badgeCoin, AppRoutes.progress, 2),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  // MODIFIED: New method to build visually rich cards
  Widget _buildVisualCard(BuildContext context, String title, IconData icon, String imagePath, String route, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(route),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background Image
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
            // 2. Gradient Overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8)
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
            // 3. Content (Icon and Text)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 48, color: Colors.white),
                  const SizedBox(height: 16),
                  TappableText(
                    text: title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0);
  }
}