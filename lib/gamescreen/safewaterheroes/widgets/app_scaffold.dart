import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/router.dart';
import '../config/theme.dart';
import '../constants/assets.dart';
import '../providers/app_settings_provider.dart';
import '../providers/repeat_button_provider.dart';
import '../services/audio_controller.dart';
import 'animated_background.dart';
import 'coin_badge.dart';

class AppScaffold extends ConsumerWidget {
  final Widget child;
  final bool showBackButton;
  final VoidCallback onHomePressed;

  const AppScaffold({
    super.key,
    required this.child,
    this.showBackButton = true,
    required this.onHomePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final audioLang = settings.audioLanguageCode; // For audio only
    final settingsCtrl = ref.read(appSettingsProvider.notifier);
    
    // Watch repeat visibility
    final showRepeat = ref.watch(repeatButtonVisibleProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 32),
                onPressed: () {
                  // Reset audio language to English on navigation
                  settingsCtrl.resetAudioToEnglish();
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.dashboard);
                  }
                },
              )
            : null,
        title: Image.asset(AppAssets.logo, height: 60),
        centerTitle: true,
        actions: [
          // 1. REPEAT BUTTON (Only visible when timer triggers)
          if (showRepeat)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton.icon(
                onPressed: () => ref.read(audioControllerProvider).repeatLast(),
                icon: const Icon(Icons.replay_rounded, size: 20),
                label: const Text("Repeat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ).animate().fadeIn().scale(),
            ),

          // 2. COIN BADGE
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CoinBadge(),
          ),

          // 3. MUTE BUTTON
          IconButton(
            icon: Icon(
              settings.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              size: 28,
              color: settings.isMuted ? Colors.grey : AppTheme.textDark,
            ),
            onPressed: () => settingsCtrl.toggleMute(),
            tooltip: settings.isMuted ? 'Unmute' : 'Mute',
          ),

          // 4. LANGUAGE TOGGLE BUTTON (EN/ES for audio only - text stays English)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => settingsCtrl.toggleAudioLanguage(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: audioLang == 'es' ? AppTheme.accentOrange : AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  audioLang.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          // 5. HOME BUTTON
          IconButton(
            icon: const Icon(Icons.home_rounded, size: 32),
            onPressed: onHomePressed,
            tooltip: 'Home',
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Removed AudioRepeaterOverlay wrapper
      body: AnimatedBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}