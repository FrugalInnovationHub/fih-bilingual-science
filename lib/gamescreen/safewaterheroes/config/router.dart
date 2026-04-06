import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/entry_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/learning/learning_hub_screen.dart';
import '../screens/learning/lesson_player_screen.dart';
import '../screens/games/games_hub_screen.dart';
import '../screens/games/sorting_game_screen.dart';
import '../screens/games/filter_game_screen.dart';
import '../screens/games/adventure_game_screen.dart';
import '../screens/progress_screen.dart';
import '../widgets/app_scaffold.dart';
import '../providers/app_settings_provider.dart';

// Define route paths as constants
class AppRoutes {
  static const entry = '/';
  static const dashboard = '/dashboard';
  static const learningHub = '/learning';
  static const lessonPlayer = 'player/:lessonId';
  static const gamesHub = '/games';
  static const gameSorting = 'sorting';
  static const gameFilter = 'filter';
  static const gameAdventure = 'adventure';
  static const progress = '/progress';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Reset language to English on every route change
  final settingsNotifier = ref.read(appSettingsProvider.notifier);

  // In a real scenario, this might be passed in by the host app constructor
  // or defined as a known deep link scheme (e.g., 'hostapp://home').
  void exitToHostApp(BuildContext context) {
    debugPrint("Exiting Module -> Returning to HOST APP Home");
    // Example integration: Navigator.of(context, rootNavigator: true).pop();
    // For this standalone build, we'll show a dialog confirming exit.
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Exit Module"),
        content: const Text("Return to Host App Home Screen?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {
             Navigator.pop(ctx);
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Exited to Host App (Simulation)")));
             // Actual exit logic goes here in real integration
          }, child: const Text("Exit")),
        ],
      )
    );
  }

  return GoRouter(
    initialLocation: AppRoutes.entry,
    redirect: (context, state) {
      // Reset audio language to English on every navigation
      settingsNotifier.resetAudioToEnglish();
      return null; // No actual redirect, just reset audio language
    },
    routes: [
      // Entry screen is not wrapped in AppScaffold (has its own specialized layout)
      GoRoute(
        path: AppRoutes.entry,
        builder: (context, state) => EntryScreen(onExitToHost: () => exitToHostApp(context)),
      ),
      // ShellRoute wraps all internal module screens with the AppScaffold
      ShellRoute(
        builder: (context, state, child) {
          // Determine if we should show the Back button (not on Dashboard)
          final showBack = state.uri.toString() != AppRoutes.dashboard;
          return AppScaffold(
            showBackButton: showBack,
            onHomePressed: () => exitToHostApp(context),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.learningHub,
            builder: (context, state) => const LearningHubScreen(),
            routes: [
               GoRoute(
                path: AppRoutes.lessonPlayer,
                builder: (context, state) {
                   final lessonId = int.tryParse(state.pathParameters['lessonId'] ?? '0') ?? 0;
                   return LessonPlayerScreen(lessonId: lessonId);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.gamesHub,
            builder: (context, state) => const GamesHubScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.gameSorting,
                builder: (context, state) => const SortingGameScreen(),
              ),
               GoRoute(
                path: AppRoutes.gameFilter,
                builder: (context, state) => const FilterGameScreen(),
              ),
               GoRoute(
                path: AppRoutes.gameAdventure,
                builder: (context, state) => const AdventureGameScreen(),
              ),
            ]
          ),
           GoRoute(
            path: AppRoutes.progress,
            builder: (context, state) => const ProgressScreen(),
          ),
        ],
      ),
    ],
  );
});