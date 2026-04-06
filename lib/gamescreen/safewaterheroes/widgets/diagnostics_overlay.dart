import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_settings_provider.dart';
import '../providers/user_progress_provider.dart';

class DiagnosticsOverlay extends ConsumerWidget {
  const DiagnosticsOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    // Check if progress provider has a user ID to infer firebase connection roughly
    final hasUser = ref.watch(userProgressProvider.select((s) => s.createdAt != null));
    final currentRoute = GoRouterState.of(context).uri.toString();
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      title: const Text("Diagnostics"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Platform: ${kIsWeb ? 'Web' : defaultTargetPlatform.name}"),
          Text("Screen: ${size.width.toStringAsFixed(0)}x${size.height.toStringAsFixed(0)}"),
          Text("Is Tablet Size: ${size.width > 600}"),
          const Divider(),
          Text("Firebase Configured (est): $hasUser"),
          const Divider(),
          Text("Language: ${settings.languageCode}"),
          Text("Audio Muted: ${settings.isMuted}"),
          Text("Hover Speak (Web): ${settings.hoverSpeakEnabled}"),
          const Divider(),
          Text("Route: $currentRoute"),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
      ],
    );
  }
}