import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../constants/game_data.dart';
import '../../constants/strings.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../services/audio_controller.dart';
import '../../widgets/tappable_text.dart';
import '../../widgets/game_intro_banner.dart';

class SortingGameScreen extends ConsumerStatefulWidget {
  const SortingGameScreen({super.key});

  @override
  ConsumerState<SortingGameScreen> createState() => _SortingGameScreenState();
}

class _SortingGameScreenState extends ConsumerState<SortingGameScreen> {
  late List<SortingItem> _shuffledItems;
  int _currentIndex = 0;
  bool _isWrongAnim = false;

  @override
  void initState() {
    super.initState();
    _shuffledItems = List.from(kSortingItems)..shuffle();
    
    // Tech check snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
       final lang = ref.read(appSettingsProvider).languageCode;
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text("✅ Sorting Game loaded. " + AppStrings.get('interactiveOn', lang)),
           duration: const Duration(seconds: 1),
         )
       );
    });
  }

  SortingItem? get _currentItem => _currentIndex < _shuffledItems.length ? _shuffledItems[_currentIndex] : null;

  void _handleDrop(WaterType targetType) {
    if (_currentItem == null) return;

    final lang = ref.read(appSettingsProvider).languageCode;
    
    if (_currentItem!.type == targetType) {
      // Correct!
      ref.read(userProgressProvider.notifier).addCoins(5);
      ref.read(audioControllerProvider).requestSpeak(AppStrings.get('goodJob', lang));
      setState(() {
        _currentIndex++;
        _isWrongAnim = false;
      });

      if (_currentIndex == _shuffledItems.length) {
        ref.read(userProgressProvider.notifier).markGameBadge('sorting');
      }
    } else {
      // Wrong!
      ref.read(audioControllerProvider).requestSpeak(AppStrings.get('tryAgain', lang));
      setState(() => _isWrongAnim = true);
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _isWrongAnim = false);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.get('tryAgain', lang)),
          backgroundColor: Colors.redAccent,
          duration: const Duration(milliseconds: 1000),
        )
      );
    }
  }

  String _getAssetForItem(SortingItem item) {
    final name = item.nameEn.toLowerCase();
    
    if (name.contains("tap")) return 'assets/safewaterheroes/images/sorting/source_tap.png';
    if (name.contains("bottled")) return 'assets/safewaterheroes/images/sorting/source_bottle.png';
    if (name.contains("tank")) return 'assets/safewaterheroes/images/sorting/source_tank.png';
    
    if (name.contains("river")) return 'assets/safewaterheroes/images/sorting/source_river.png';
    if (name.contains("pond")) return 'assets/safewaterheroes/images/sorting/source_pond.png';
    if (name.contains("well")) return 'assets/safewaterheroes/images/sorting/source_well.png';
    if (name.contains("rain")) return 'assets/safewaterheroes/images/sorting/source_rain.png';
    if (name.contains("waterfall")) return 'assets/safewaterheroes/images/sorting/source_waterfall.png';
    if (name.contains("handpump")) return 'assets/safewaterheroes/images/sorting/source_handpump.png';
    
    if (name.contains("puddle")) return 'assets/safewaterheroes/images/sorting/source_puddle.png';
    if (name.contains("flood")) return 'assets/safewaterheroes/images/sorting/source_flood.png';
    if (name.contains("sewage")) return 'assets/safewaterheroes/images/sorting/source_sewage.png';
    if (name.contains("trash")) return 'assets/safewaterheroes/images/sorting/source_trash.png';
    if (name.contains("algae")) return 'assets/safewaterheroes/images/sorting/source_algae.png';
    if (name.contains("animals")) return 'assets/safewaterheroes/images/sorting/source_animals.png';

    return 'assets/safewaterheroes/images/sorting/source_generic.png'; 
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(appSettingsProvider.select((s) => s.languageCode));
    final isEs = lang == 'es';

    return Column(
      children: [
        GameIntroBanner(
          textEn: "Drag the water picture into the right bin: Safe, Needs Filter, or Unsafe.",
          textEs: "Arrastra la imagen del agua al contenedor correcto: Seguro, Necesita Filtro o Inseguro.",
        ),

        Expanded(
          child: _currentItem == null
              ? _buildGameComplete(isEs)
              : Column(
                  children: [
                    // TOP: Big Water Source Card
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Draggable<WaterType>(
                          data: _currentItem!.type,
                          feedback: _buildSourceCard(_currentItem!, isEs, scale: 1.1),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _buildSourceCard(_currentItem!, isEs),
                          ),
                          child: _buildSourceCard(_currentItem!, isEs)
                              .animate(target: _isWrongAnim ? 1 : 0)
                              .shake(hz: 8, duration: 500.ms),
                        ),
                      ),
                    ),

                    // BOTTOM: Image Bins
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // FIX: Expanded must be here in the Row, NOT inside the builder
                            Expanded(child: _buildImageBin(WaterType.safe, "assets/safewaterheroes/images/sorting/bin_safe.png", isEs ? "SEGURO" : "SAFE", Colors.green)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildImageBin(WaterType.needsFilter, "assets/safewaterheroes/images/sorting/bin_filter.png", isEs ? "FILTRO" : "FILTER", Colors.orange)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildImageBin(WaterType.unsafe, "assets/safewaterheroes/images/sorting/bin_unsafe.png", isEs ? "INSEGURO" : "UNSAFE", Colors.red)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildGameComplete(bool isEs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 80, color: AppTheme.accentOrange),
          const SizedBox(height: 24),
          TappableText(
            text: isEs ? "¡Juego Terminado!" : "Game Complete!",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ).animate().scale().fadeIn(),
    );
  }

  Widget _buildSourceCard(SortingItem item, bool isEs, {double scale = 1.0}) {
    String assetPath = _getAssetForItem(item); 
    
    return Transform.scale(
      scale: scale,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 300, 
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3, 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    assetPath, 
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.blue.shade100,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          Text("No Image", style: TextStyle(color: Colors.grey))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TappableText(
                  text: isEs ? item.nameEs : item.nameEn,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FIX: REMOVED EXPANDED FROM HERE
  Widget _buildImageBin(WaterType type, String assetPath, String label, Color color) {
    return DragTarget<WaterType>(
      onWillAccept: (data) => true,
      onAccept: (data) => _handleDrop(type),
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        // Just return the animated container. Expansion is handled by the parent Row.
        return AnimatedScale(
          scale: isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              border: Border.all(color: isHovered ? color : Colors.transparent, width: 4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image can still be flexible inside the column
                Flexible( 
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      assetPath, 
                      fit: BoxFit.contain,
                      errorBuilder: (c,e,s) => Icon(Icons.delete, size: 60, color: color), 
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    label, 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: color
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}