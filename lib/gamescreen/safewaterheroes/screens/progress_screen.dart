import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../config/router.dart';
import '../constants/game_data.dart';
import '../providers/app_settings_provider.dart';
import '../providers/user_progress_provider.dart';
import '../services/audio_controller.dart';
import '../widgets/tappable_text.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       final progress = ref.read(userProgressProvider);
       final lang = ref.read(appSettingsProvider).languageCode;
       // Read stats once on load
       final text = lang == 'es'
         ? "Tienes ${progress.coins} monedas y has completado ${progress.completedLessons.length} lecciones."
         : "You have ${progress.coins} coins and completed ${progress.completedLessons.length} lessons.";
       ref.read(audioControllerProvider).requestSpeak(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    final progress = ref.watch(userProgressProvider);
    final isEs = lang == 'es';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.dashboard);
                  }
                },
              ),
              Expanded(
                child: TappableText(
                  text: isEs ? "Mi Progreso" : "My Progress",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 24),
          // Stats Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(context, isEs ? "Monedas" : "Coins", progress.coins.toString(), Icons.monetization_on),
                  _buildStat(context, isEs ? "Lecciones" : "Lessons", "${progress.completedLessons.length}/${kAllLessons.length}", Icons.school),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TappableText(text: isEs ? "Medallas de Juego" : "Game Badges", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
                _buildBadge(context, "Sorting", progress.sortingBadged),
                _buildBadge(context, "Filter", progress.filterBadged),
                _buildBadge(context, "Adventure", progress.adventureBadged),
             ],
          ),
          const SizedBox(height: 48),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
               showDialog(context: context, builder: (ctx) => AlertDialog(
                 title: const Text("Reset Progress?"),
                 content: const Text("This cannot be undone."),
                 actions: [
                    TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text("Cancel")),
                    TextButton(onPressed: (){
                       ref.read(userProgressProvider.notifier).resetProgress();
                       Navigator.pop(ctx);
                    }, child: const Text("Reset", style: TextStyle(color: Colors.red))),
                 ],
               ));
            },
            icon: const Icon(Icons.delete_forever),
            label: TappableText(text: isEs ? "Reiniciar Progreso" : "Reset Progress"),
          )
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 48, color: AppTheme.primaryBlue),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        TappableText(text: label),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, String label, bool isEarned) {
     return Column(
       children: [
         CircleAvatar(
           radius: 40,
           backgroundColor: isEarned ? AppTheme.accentOrange : Colors.grey[300],
           child: Icon(Icons.emoji_events, size: 40, color: isEarned ? Colors.white : Colors.grey),
         ),
         const SizedBox(height: 8),
         Text(label, style: TextStyle(color: isEarned ? AppTheme.textDark : Colors.grey)),
       ],
     );
  }
}
