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
import '../services/audio_controller.dart';

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

final exitToHostCallbackProvider = Provider<VoidCallback?>((ref) => null);

final routerProvider = Provider<GoRouter>((ref) {
  final settingsNotifier = ref.read(appSettingsProvider.notifier);
  String? lastLocation;

  return GoRouter(
    initialLocation: AppRoutes.entry,
    redirect: (context, state) {
      final nextLocation = state.uri.toString();
      if (lastLocation != null && lastLocation != nextLocation) {
        ref.read(audioControllerProvider).stop();
      }
      lastLocation = nextLocation;
      settingsNotifier.resetAudioToEnglish();
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.entry,
        builder: (context, state) => EntryScreen(
          onExitToHost: () {
            ref.read(audioControllerProvider).stop();
            final exitToHost = ref.read(exitToHostCallbackProvider);
            if (exitToHost != null) {
              exitToHost();
              return;
            }

            final rootNavigator = Navigator.of(context, rootNavigator: true);
            if (rootNavigator.canPop()) {
              rootNavigator.pop();
            } else {
              context.go(AppRoutes.entry);
            }
          },
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final currentLocation = state.uri.toString();
          final showBack = currentLocation != AppRoutes.entry &&
              currentLocation != AppRoutes.dashboard;
          return AppScaffold(
            showBackButton: showBack,
            currentLocation: currentLocation,
            onHomePressed: () {
              ref.read(audioControllerProvider).stop();
              final exitToHost = ref.read(exitToHostCallbackProvider);
              if (exitToHost != null) {
                exitToHost();
                return;
              }

              final rootNavigator = Navigator.of(context, rootNavigator: true);
              if (rootNavigator.canPop()) {
                rootNavigator.pop();
              } else {
                context.go(AppRoutes.entry);
              }
            },
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
