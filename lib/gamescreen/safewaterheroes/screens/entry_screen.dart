import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/router.dart';
import '../config/theme.dart';
import '../constants/strings.dart';
import '../constants/assets.dart';
import '../providers/auth_provider.dart';
import '../providers/app_settings_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/tappable_text.dart';
import '../services/audio_controller.dart';

class EntryScreen extends ConsumerStatefulWidget {
  final VoidCallback onExitToHost;
  const EntryScreen({super.key, required this.onExitToHost});

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Auto-read welcome message on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
       final lang = ref.read(appSettingsProvider).languageCode;
       ref.read(audioControllerProvider).requestSpeak(AppStrings.get('appTitle', lang));
    });
  }

  Future<void> _handleGetStarted() async {
    setState(() => _isLoading = true);
    // In wrapper mode, PIN is already set by the main app.
    // In standalone mode, we proceed without auth (local-only mode).
    // The deprecated signInAnonymously() is kept for backward compatibility.
    // ignore: deprecated_member_use_from_same_package
    await ref.read(authControllerProvider).signInAnonymously();
    if (mounted) {
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    // Use LayoutBuilder to ensure responsiveness beyond the iPad baseline
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Adjust layout based on width (phone vs tablet)
              final isNarrow = constraints.maxWidth < 600;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mascot Animation: Bounce + drift in
                      Image.asset(AppAssets.mascot, height: isNarrow ? 150 : 250)
                        .animate().scale(duration: 600.ms, curve: Curves.easeOutBack)
                        .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 32),
                      // Logo/Title
                      TappableText(
                        text: AppStrings.get('appTitle', lang),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 48),
                      // Buttons
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else ...[
                        ElevatedButton(
                          onPressed: _handleGetStarted,
                          child: Text(AppStrings.get('getStarted', lang)),
                        ).animate().fadeIn(delay: 500.ms).scale(),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: widget.onExitToHost,
                          child: Text(
                            AppStrings.get('home', lang),
                            style: const TextStyle(fontSize: 18, color: AppTheme.darkerBlue),
                          ),
                        ).animate().fadeIn(delay: 600.ms),
                      ]
                    ],
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}