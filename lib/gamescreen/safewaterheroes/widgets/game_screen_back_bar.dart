import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/router.dart';
import '../config/theme.dart';
import '../providers/app_settings_provider.dart';
import 'tappable_text.dart';

/// In-screen back control for individual games (matches Games Hub pattern).
class GameScreenBackBar extends ConsumerWidget {
  final String? title;
  final bool contrastBackdrop;

  const GameScreenBackBar({
    super.key,
    this.title,
    this.contrastBackdrop = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onBack() {
      ref.read(appSettingsProvider.notifier).resetAudioToEnglish();
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.gamesHub);
      }
    }

    final iconColor = contrastBackdrop ? Colors.white : AppTheme.textDark;

    Widget back = IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      color: iconColor,
      onPressed: onBack,
      tooltip: 'Back',
    );
    if (contrastBackdrop) {
      back = Material(
        color: Colors.black38,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: back,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          back,
          if (title != null) ...[
            Expanded(
              child: TappableText(
                text: title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: contrastBackdrop ? Colors.white : null,
                      shadows: contrastBackdrop
                          ? const [Shadow(blurRadius: 6, color: Colors.black54)]
                          : null,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48),
          ] else
            const Spacer(),
        ],
      ),
    );
  }
}
