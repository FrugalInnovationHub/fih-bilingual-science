import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/user_progress_provider.dart';
import '../constants/assets.dart';

class CoinBadge extends ConsumerWidget {
  const CoinBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(userProgressProvider.select((s) => s.coins));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppAssets.badgeCoin, width: 24),
          const SizedBox(width: 8),
          Text(
            '$coins',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    )
    .animate(key: ValueKey(coins)) // Re-trigger on coin change
    .scale(begin: const Offset(1,1), end: const Offset(1.2, 1.2), duration: 200.ms)
    .then()
    .scale(begin: const Offset(1.2,1.2), end: const Offset(1, 1), duration: 200.ms);
  }
}