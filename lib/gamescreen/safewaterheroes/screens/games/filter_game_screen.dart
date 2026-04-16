import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart'; // Added for context.pop()
import 'package:video_player/video_player.dart';
import '../../config/theme.dart';
import '../../constants/strings.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../services/audio_controller.dart';
import '../../widgets/tappable_text.dart';
import '../../widgets/game_intro_banner.dart';
import '../../widgets/game_screen_back_bar.dart';

class FilterGameScreen extends ConsumerStatefulWidget {
  const FilterGameScreen({super.key});

  @override
  ConsumerState<FilterGameScreen> createState() => _FilterGameScreenState();
}

class _FilterGameScreenState extends ConsumerState<FilterGameScreen> {
  // 0: Empty, 1: Pebbles, 2: Sand, 3: Charcoal, 4: Cloth
  final List<int?> _slots = [null, null, null, null];
  final List<int> _requiredOrder = [1, 3, 2, 4]; // Top to bottom: Pebbles, Sand, Charcoal, Cloth
  bool _isPouring = false;
  bool _isComplete = false;

  void _handleDrop(int slotIndex, int materialId) {
    final lang = ref.read(appSettingsProvider).languageCode;
    
    // Check if correct material for this slot position
    if (_requiredOrder[slotIndex] == materialId) {
      setState(() {
        _slots[slotIndex] = materialId;
      });
      ref.read(audioControllerProvider).requestSpeak(AppStrings.get('goodJob', lang));
      _checkCompletion();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong layer order!")));
      ref.read(audioControllerProvider).requestSpeak(AppStrings.get('tryAgain', lang));
    }
  }

  void _checkCompletion() {
    if (_slots.every((s) => s != null)) {
      // All slots filled correctly. Start animation sequence.
      setState(() => _isPouring = true);
      
      Future.delayed(const Duration(seconds: 3), () {
         setState(() => _isComplete = true);
         ref.read(userProgressProvider.notifier).addCoins(20);
         ref.read(userProgressProvider.notifier).markGameBadge('filter');
         _showVideoSuccess(); // Show video on complete
      });
    }
  }
  Future<void> _showVideoSuccess() async {
    // Prevent double dialogs (very important)
    if (_isComplete == false) return; // safety; optional
    if (!mounted) return;

    final screenContext = context; // router scope

    final VideoPlayerController videoController =
        VideoPlayerController.asset("assets/safewaterheroes/videos/water_filtration.mp4");

    try {
      await videoController.initialize();
      await videoController.play();

      if (!mounted) {
        await videoController.dispose();
        return;
      }

      // Await the dialog so we control disposal timing precisely
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: AspectRatio(
            aspectRatio: videoController.value.aspectRatio == 0
                ? 16 / 9
                : videoController.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(videoController),
                VideoProgressIndicator(videoController, allowScrubbing: true),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () async {
                // Stop playback, but DO NOT dispose here
                await videoController.pause();
                Navigator.of(ctx).pop(); // close dialog
              },
              icon: const Icon(Icons.check_circle, color: Colors.green),
              label: const Text(
                "Finish & Exit",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

      // ✅ Key: wait for dialog pop animation to finish before dispose
      await Future.delayed(const Duration(milliseconds: 300));

      await videoController.dispose();

      if (!mounted) return;

      // Go back to Games Hub
      GoRouter.of(screenContext).go('/games');
    } catch (e) {
      debugPrint("Video init error: $e");
      // Always dispose on failure too
      try {
        await videoController.dispose();
      } catch (_) {}

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Video failed to load.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    final isEs = lang == 'es';

    return Column(
      children: [
        GameScreenBackBar(
          title: isEs ? 'Crear un Filtro' : 'Filter Making',
        ),
        // 1. Intro Banner
        GameIntroBanner(
          textEn: "Build a filter! Use Pebbles, Sand, Charcoal, and Cloth in order.",
          textEs: "¡Construye un filtro! Usa Piedras, Arena, Carbón y Tela en orden.",
        ),
        
        // 2. Main Game Area
        Expanded(
          child: Row(
            children: [
              // Left: Materials Panel
              Expanded(
                flex: 2,
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                      TappableText(text: isEs ? "Materiales" : "Materials", style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 24),
                      
                      // Material Draggables with Image Assets
                      _buildDraggableMaterial(1, isEs ? "Piedras" : "Pebbles", "assets/safewaterheroes/images/items/pebbles.png", Colors.grey[700]!),
                      _buildDraggableMaterial(2, isEs ? "Arena" : "Sand", "assets/safewaterheroes/images/items/sand.png", Colors.orange[200]!),
                      _buildDraggableMaterial(3, isEs ? "Carbón" : "Charcoal", "assets/safewaterheroes/images/items/charcoal.png", Colors.black),
                      _buildDraggableMaterial(4, isEs ? "Tela" : "Cloth", "assets/safewaterheroes/images/items/cloth.png", Colors.teal[100]!),
                   ],
                ),
              ),
              // Right: Bottle Assembly Area
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    width: 250,
                    height: 500,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey, width: 4),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                      color: Colors.white.withOpacity(0.8)
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: List.generate(4, (index) => _buildSlot(index)),
                        ),
                        if (_isPouring) _buildPouringAnimation(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableMaterial(int id, String label, String assetPath, Color fallbackColor) {
    // The visual component for the material item
    final widget = Column(
      children: [
        Container(
          width: 80, height: 80,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0,2))]
          ),
          // Uses fallback icon if asset missing
          child: Image.asset(
            assetPath, 
            errorBuilder: (c,e,s) => Icon(Icons.layers, color: fallbackColor, size: 40)
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );

    // Disable dragging if already placed
    if (_slots.contains(id)) return Opacity(opacity: 0.3, child: widget);

    return Draggable<int>(
      data: id,
      feedback: Material(color: Colors.transparent, child: widget),
      childWhenDragging: Opacity(opacity: 0.5, child: widget),
      child: Padding(padding: const EdgeInsets.all(8.0), child: widget),
    );
  }

  Widget _buildSlot(int index) {
    final materialId = _slots[index];
    
    // Define color based on material ID for visual feedback
    Color slotColor = Colors.transparent;
    if (materialId == 1) slotColor = Colors.grey[700]!;
    if (materialId == 2) slotColor = Colors.orange[200]!;
    if (materialId == 3) slotColor = Colors.black;
    if (materialId == 4) slotColor = Colors.teal[100]!;

    return Expanded(
      child: DragTarget<int>(
        onWillAccept: (data) => _slots[index] == null, // Only accept if empty
        onAccept: (data) => _handleDrop(index, data),
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: materialId != null ? slotColor : Colors.grey[200],
              border: Border.all(color: candidateData.isNotEmpty ? AppTheme.accentOrange : Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: materialId == null ? const Text("Drop Here") : null,
          );
        },
      ),
    );
  }

  Widget _buildPouringAnimation() {
    return Positioned.fill(
      child: _isComplete
      ? Container(color: Colors.blue.withOpacity(0.6)) // Clean water fill
         .animate().fadeIn(duration: 1.seconds)
      : Column(
        children: [
           // Brown water pouring in
           Container(height: 50, color: Colors.brown)
             .animate(onPlay: (c)=>c.repeat()).slideY(begin: -1, end: 10, duration: 2.seconds),
           Expanded(
             // Transitioning water body
             child: Container(color: Colors.brown.withOpacity(0.5))
               .animate().color(begin: Colors.brown.withOpacity(0.5), end: Colors.blue.withOpacity(0.5), duration: 3.seconds),
           ),
        ],
      ),
    );
  }
}