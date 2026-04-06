import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'providers/app_settings_provider.dart';

class SafeWaterHeroesApp extends ConsumerWidget {
  const SafeWaterHeroesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerProvider);
    // Watch language setting to rebuild app on toggle
    ref.watch(appSettingsProvider.select((s) => s.languageCode));

    return MaterialApp.router(
      title: 'Safe Water Heroes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.stitchTheme,
      routerConfig: routerConfig,
    );
  }
}