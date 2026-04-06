import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'safewaterheroes/config/router.dart';
import 'safewaterheroes/config/theme.dart';
import 'safewaterheroes/providers/app_settings_provider.dart';
import 'safewaterheroes/providers/user_progress_provider.dart';

/// Provider to hold the user PIN passed from the main app.
/// This is used instead of Firebase Auth to identify the user.
final userPinProvider = StateProvider<String>((ref) => '');

/// Wrapper widget that allows Safe Water Heroes to be embedded
/// within the FIH Bilingual Science main app.
/// 
/// This follows the same pattern as TidyTownWrapper and ColorTheoryWrapper.
class SafeWaterHeroesWrapper extends StatefulWidget {
  /// The user's PIN from the main app (3-digit PIN-based auth)
  final String userPin;

  const SafeWaterHeroesWrapper({super.key, required this.userPin});

  @override
  State<SafeWaterHeroesWrapper> createState() => _SafeWaterHeroesWrapperState();
}

class _SafeWaterHeroesWrapperState extends State<SafeWaterHeroesWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ProviderScope(
      overrides: [
        userPinProvider.overrideWith((ref) => widget.userPin),
      ],
      child: const _SafeWaterHeroesApp(),
    );
  }
}

class _SafeWaterHeroesApp extends ConsumerWidget {
  const _SafeWaterHeroesApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerProvider);
    ref.watch(appSettingsProvider.select((s) => s.languageCode));

    return MaterialApp.router(
      title: 'Safe Water Heroes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.stitchTheme,
      routerConfig: routerConfig,
    );
  }
}
