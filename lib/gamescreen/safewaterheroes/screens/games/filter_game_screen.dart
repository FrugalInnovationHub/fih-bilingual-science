import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Added for context.pop()
import 'package:video_player/video_player.dart';

import '../../config/theme.dart';
import '../../constants/strings.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../services/audio_controller.dart';
import '../../widgets/game_intro_banner.dart';
import '../../widgets/game_screen_back_bar.dart';

class FilterGameScreen extends ConsumerStatefulWidget {
  const FilterGameScreen({super.key});

  @override
  ConsumerState<FilterGameScreen> createState() => _FilterGameScreenState();
}

class _FilterGameScreenState extends ConsumerState<FilterGameScreen>
    with TickerProviderStateMixin {
  // 0: Empty, 1: Pebbles, 2: Sand, 3: Charcoal, 4: Cloth
  final List<int?> _slots = [null, null, null, null];
  final List<int> _requiredOrder = [1, 3, 2, 4]; // Top to bottom: Pebbles, Sand, Charcoal, Cloth
  bool _isPouring = false;
  bool _isComplete = false;

  final Set<int> _hoveredMaterials = <int>{};
  late final AnimationController _backgroundController;
  late final AnimationController _dripController;
  late final AnimationController _slotPulseController;
  late final AnimationController _waveController;
  late final AnimationController _materialsPanelController;
  late final List<AnimationController> _cardFloatControllers;
  late final ConfettiController _confettiController;
  bool _confettiStarted = false;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
    _dripController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _slotPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _materialsPanelController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _cardFloatControllers = List.generate(4, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2200 + (index * 220)),
      )..repeat();
    });
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _dripController.dispose();
    _slotPulseController.dispose();
    _waveController.dispose();
    _materialsPanelController.dispose();
    for (final controller in _cardFloatControllers) {
      controller.dispose();
    }
    _confettiController.dispose();
    super.dispose();
  }

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
         if (!_confettiStarted) {
           _confettiStarted = true;
           _confettiController.play();
         }
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
        builder: (ctx) {
          final screenHeight = MediaQuery.of(ctx).size.height;
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0288D1),
                      Color(0xFF26C6DA),
                      Color(0xFFE0F7FA),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '🤿 Filter Complete!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'You cleaned the water! 🌊',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
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
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton.icon(
                          onPressed: () async {
                            // Stop playback, but DO NOT dispose here
                            await videoController.pause();
                            Navigator.of(ctx).pop(); // close dialog
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle, color: Color(0xFF0288D1)),
                          label: const Text(
                            "Finish & Exit",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0288D1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      // Key: wait for dialog pop animation to finish before dispose
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

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, _) {
              return CustomPaint(
                painter: _UnderwaterWorldPainter(progress: _backgroundController.value),
                child: const SizedBox.expand(),
              );
            },
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.transparent,
                  Colors.black.withOpacity(0.08),
                ],
              ),
            ),
          ),
        ),
        if (_confettiStarted)
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.06,
                  numberOfParticles: 18,
                  gravity: 0.18,
                  shouldLoop: false,
                  maxBlastForce: 18,
                  minBlastForce: 8,
                  colors: const [
                    Color(0xFF4FC3F7),
                    Color(0xFFFFD54F),
                    Color(0xFF66BB6A),
                    Color(0xFFFF7043),
                    Color(0xFFEC407A),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
        Column(
          children: [
            GameScreenBackBar(
              title: isEs ? 'Crear un Filtro' : 'Filter Making',
            ),
            GameIntroBanner(
              textEn: "Build a filter! Use Pebbles, Sand, Charcoal, and Cloth in order.",
              textEs: "¡Construye un filtro! Usa Piedras, Arena, Carbón y Tela en orden.",
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availH = constraints.maxHeight;
                    final tubeHeight =
                        (availH * 0.52).clamp(260.0, 360.0).toDouble();
                    final tubeWidth =
                        (tubeHeight * 0.44).clamp(180.0, 250.0).toDouble();
                    const diverHeight = 75.0;
                    final totalRightH = diverHeight + tubeHeight + 30.0 + 40.0;
                    final adjustedTubeH = totalRightH > availH
                        ? (tubeHeight - (totalRightH - availH) - 16.0)
                            .clamp(220.0, 360.0)
                            .toDouble()
                        : tubeHeight;
                    final adjustedTubeW =
                        (adjustedTubeH * 0.44).clamp(180.0, 250.0).toDouble();

                    return Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Transform.translate(
                              offset: const Offset(48, 0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Center(
                                  child: _buildMaterialsPanel(
                                    isEs,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: _buildScubaFilterZone(
                                isEs,
                                adjustedTubeW,
                                adjustedTubeH,
                                diverHeight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMaterialsPanel(bool isEs) {
    const cardWidth = 120.0;
    const cardHeight = 120.0;
    const gridSpacing = 16.0;
    final panelWidth = (cardWidth * 2) + gridSpacing + 28.0;

    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _materialsPanelController,
        curve: Curves.easeInOut,
      ),
      builder: (context, child) {
        final offsetY = -8 * Curves.easeInOut.transform(_materialsPanelController.value);
        return Transform.translate(
          offset: Offset(0, offsetY),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: panelWidth,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.22),
                Colors.white.withOpacity(0.08),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Materials 🌊',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(color: Colors.black38, blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isEs
                    ? 'Arrastra cada material al filtro'
                    : 'Drag each material into the filter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: (cardWidth * 2) + gridSpacing,
                height: (cardHeight * 2) + gridSpacing,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: gridSpacing,
                  mainAxisSpacing: gridSpacing,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildDraggableMaterial(
                      1,
                      isEs ? "Piedras" : "Pebbles",
                      "assets/safewaterheroes/images/items/pebbles.png",
                      Colors.grey[700]!,
                      cardWidth,
                      cardHeight,
                    ),
                    _buildDraggableMaterial(
                      2,
                      isEs ? "Arena" : "Sand",
                      "assets/safewaterheroes/images/items/sand.png",
                      Colors.orange[200]!,
                      cardWidth,
                      cardHeight,
                    ),
                    _buildDraggableMaterial(
                      3,
                      isEs ? "Carbón" : "Charcoal",
                      "assets/safewaterheroes/images/items/charcoal.png",
                      Colors.black,
                      cardWidth,
                      cardHeight,
                    ),
                    _buildDraggableMaterial(
                      4,
                      isEs ? "Tela" : "Cloth",
                      "assets/safewaterheroes/images/items/cloth.png",
                      Colors.teal[100]!,
                      cardWidth,
                      cardHeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScubaFilterZone(
    bool isEs,
    double tubeWidth,
    double tubeHeight,
    double diverHeight,
  ) {
    final filledCount = _slots.where((slot) => slot != null).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Help the diver build a filter! 🤿',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black38, blurRadius: 4),
                ],
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: diverHeight,
              width: tubeWidth,
              child: CustomPaint(
                size: Size(tubeWidth, diverHeight),
                painter: _ScubaDiverPainter(progress: _backgroundController.value),
              ),
            ),
            SizedBox(
              height: tubeHeight,
              width: tubeWidth,
              child: _buildFilterTube(
                tubeWidth,
                tubeHeight,
                isEs,
                filledCount > 0,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 14,
              child: Center(child: _buildProgressIndicator(filledCount)),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildFilterTube(
    double tubeWidth,
    double tubeHeight,
    bool isEs,
    bool showDroplet,
  ) {
    return Container(
      width: tubeWidth,
      height: tubeHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF4FC3F7).withOpacity(0.3),
            Colors.white.withOpacity(0.5),
            const Color(0xFF4FC3F7).withOpacity(0.3),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
        border: Border.all(
          color: const Color(0xFF29B6F6),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0288D1).withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(57),
          bottomRight: Radius.circular(57),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.18),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: List.generate(4, (index) => _buildSlot(index, isEs)),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, _) => CustomPaint(
                  size: Size(tubeWidth - 28, 12),
                  painter: _WavePainter(progress: _waveController.value),
                ),
              ),
            ),
            if (showDroplet)
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _dripController,
                    builder: (context, _) {
                      final t = _dripController.value;
                      final dropY = Curves.easeIn.transform(t) * 10;
                      return Opacity(
                        opacity: (1 - t).clamp(0.0, 1.0).toDouble(),
                        child: Transform.translate(
                          offset: Offset(0, dropY),
                          child: CustomPaint(
                            size: const Size(16, 22),
                            painter: const _DropletPainter(color: Color(0xFF4FC3F7)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (_isPouring) _buildPouringAnimation(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int filledCount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final filled = index < filledCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled
                  ? const Color(0xFFFFD54F).withOpacity(0.22)
                  : Colors.white.withOpacity(0.08),
              border: Border.all(
                color: filled
                    ? const Color(0xFFFFD54F)
                    : Colors.white.withOpacity(0.28),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDraggableMaterial(
    int id,
    String label,
    String assetPath,
    Color fallbackColor,
    double cardWidth,
    double cardHeight,
  ) {
    final isPlaced = _slots.contains(id);
    final isHovered = _hoveredMaterials.contains(id);
    final controller = _cardFloatControllers[id - 1];
    const imageSize = 60.0;

    final visualCard = AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final bobOffset = isPlaced
            ? 0.0
            : math.sin((controller.value * math.pi * 2) + ((id - 1) * 0.5)) * 5;
        return Transform.translate(
          offset: Offset(0, bobOffset),
          child: child,
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredMaterials.add(id)),
        onExit: (_) => setState(() => _hoveredMaterials.remove(id)),
        child: AnimatedScale(
          scale: isHovered ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF4FC3F7).withOpacity(0.9),
                              const Color(0xFF0288D1).withOpacity(0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0288D1).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(-2, -2),
                            ),
                            if (isHovered)
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 16,
                              ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Image.asset(
                              assetPath,
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) =>
                                  Icon(Icons.layers, color: fallbackColor, size: 40),
                            ),
                          ),
                        ),
                      ),
                      if (isPlaced)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 28,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 16,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black38, blurRadius: 3),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Disable dragging if already placed
    if (_slots.contains(id)) {
      return Opacity(opacity: 0.35, child: visualCard);
    }

    return Draggable<int>(
      data: id,
      feedback: Material(color: Colors.transparent, child: visualCard),
      childWhenDragging: Opacity(opacity: 0.5, child: visualCard),
      child: visualCard,
    );
  }

  Widget _buildSlot(int index, bool isEs) {
    final materialId = _slots[index];

    return Expanded(
      child: DragTarget<int>(
        onWillAccept: (data) => _slots[index] == null, // Only accept if empty
        onAccept: (data) => _handleDrop(index, data),
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty;
          final slotTint = _layerColor(materialId)?.withOpacity(0.85);

          return AnimatedBuilder(
            animation: _slotPulseController,
            builder: (context, _) {
              final pulseValue = 0.3 + (_slotPulseController.value * 0.6);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                child: CustomPaint(
                  painter: materialId == null && !isHovering
                      ? _DashedRoundedRectPainter(
                          color: const Color(0xFF4FC3F7).withOpacity(pulseValue),
                          radius: 18,
                        )
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: materialId != null
                          ? slotTint
                          : isHovering
                              ? const Color(0x4DFFF9C4)
                              : Colors.white.withOpacity(0.15),
                      border: Border.all(
                        color: candidateData.isNotEmpty
                            ? AppTheme.accentOrange
                            : materialId != null
                                ? Colors.white.withOpacity(0.18)
                                : Colors.white.withOpacity(pulseValue * 0.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: materialId == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.water_drop_outlined,
                                color: Color(0xFF4FC3F7),
                                size: 18,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Drop Here',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Image.asset(
                                  _materialAsset(materialId),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (c, e, s) => Icon(
                                    Icons.layers,
                                    color: _layerColor(materialId) ?? Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _materialLabel(materialId, isEs),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                      shadows: [
                                        Shadow(color: Colors.black38, blurRadius: 4),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF66BB6A),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color? _layerColor(int? materialId) {
    switch (materialId) {
      case 1:
        return const Color(0xFF90A4AE);
      case 2:
        return const Color(0xFFFFD54F);
      case 3:
        return const Color(0xFF37474F);
      case 4:
        return const Color(0xFF81D4FA);
      default:
        return null;
    }
  }

  String _materialAsset(int? materialId) {
    switch (materialId) {
      case 1:
        return "assets/safewaterheroes/images/items/pebbles.png";
      case 2:
        return "assets/safewaterheroes/images/items/sand.png";
      case 3:
        return "assets/safewaterheroes/images/items/charcoal.png";
      case 4:
        return "assets/safewaterheroes/images/items/cloth.png";
      default:
        return '';
    }
  }

  String _materialLabel(int? materialId, bool isEs) {
    switch (materialId) {
      case 1:
        return isEs ? 'Piedras' : 'Pebbles';
      case 2:
        return isEs ? 'Arena' : 'Sand';
      case 3:
        return isEs ? 'Carbón' : 'Charcoal';
      case 4:
        return isEs ? 'Tela' : 'Cloth';
      default:
        return '';
    }
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

class _UnderwaterWorldPainter extends CustomPainter {
  const _UnderwaterWorldPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color(0xFF006994),
          Color(0xFF0288D1),
          Color(0xFF4FC3F7),
        ],
        stops: [0.0, 0.6, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, background);

    _paintLightRays(canvas, size);
    _paintSeaweed(canvas, size);
    _paintCorals(canvas, size);
    _paintFish(canvas, size);
    _paintBubbles(canvas, size);
  }

  void _paintLightRays(Canvas canvas, Size size) {
    final rayPaint = Paint()..color = Colors.white.withOpacity(0.06);
    final origins = [0.42, 0.5, 0.58, 0.66];
    for (int i = 0; i < origins.length; i++) {
      final centerX = size.width * origins[i];
      final width = 36 + (i * 10);
      final endX = centerX + (i.isEven ? -70 : 70);
      final endY = size.height * (0.58 + i * 0.03);
      final path = Path()
        ..moveTo(centerX - width, 0)
        ..lineTo(centerX + width, 0)
        ..lineTo(endX, endY)
        ..close();
      canvas.drawPath(path, rayPaint);
    }
  }

  void _paintSeaweed(Canvas canvas, Size size) {
    final weedPaint = Paint()
      ..color = const Color(0xB366BB6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final phase = progress * math.pi * 2;
    final leftOffsets = [20.0, 42.0, 64.0];
    final rightOffsets = [size.width - 22.0, size.width - 44.0, size.width - 66.0];

    for (final baseX in [...leftOffsets, ...rightOffsets]) {
      final path = Path();
      for (double y = size.height; y >= size.height * 0.45; y -= 10) {
        final sway = math.sin((y / 38) + phase + (baseX * 0.03)) * 10;
        final x = baseX + sway;
        if (y == size.height) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, weedPaint);
    }
  }

  void _paintCorals(Canvas canvas, Size size) {
    _drawCoral(canvas, Offset(22, size.height - 10), 98, const Color(0xFFFF7043), false);
    _drawCoral(canvas, Offset(70, size.height - 6), 76, const Color(0xFFFF8A65), false);
    _drawCoral(canvas, Offset(116, size.height - 14), 64, const Color(0xFFFF7043), false);

    _drawCoral(canvas, Offset(size.width - 28, size.height - 12), 82, const Color(0xFFEC407A), true);
    _drawCoral(canvas, Offset(size.width - 88, size.height - 6), 58, const Color(0xFFF48FB1), true);
  }

  void _drawCoral(Canvas canvas, Offset origin, double height, Color color, bool mirror) {
    final direction = mirror ? -1.0 : 1.0;
    final path = Path()
      ..moveTo(origin.dx, origin.dy)
      ..quadraticBezierTo(
        origin.dx + 8 * direction,
        origin.dy - height * 0.35,
        origin.dx + 4 * direction,
        origin.dy - height,
      )
      ..quadraticBezierTo(
        origin.dx + 18 * direction,
        origin.dy - height * 0.78,
        origin.dx + 24 * direction,
        origin.dy - height * 0.54,
      )
      ..quadraticBezierTo(
        origin.dx + 8 * direction,
        origin.dy - height * 0.56,
        origin.dx - 10 * direction,
        origin.dy - height * 0.34,
      );

    final paint = Paint()
      ..color = color.withOpacity(0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  void _paintFish(Canvas canvas, Size size) {
    final primaryPhase = progress * math.pi * 2;
    final secondaryPhase = progress * math.pi * 4;
    final tertiaryPhase = progress * math.pi * 3;

    // Existing fish 1 — left area, amber
    _drawFish(
      canvas,
      Offset(size.width * (0.12 + 0.08 * math.sin(primaryPhase)), size.height * 0.2),
      const Size(46, 24),
      const Color(0xFFFFB74D),
      math.cos(primaryPhase) > 0,
    );
    // Existing fish 2 — right area, blue
    _drawFish(
      canvas,
      Offset(size.width * (0.82 + 0.07 * math.sin(primaryPhase + math.pi)), size.height * 0.18),
      const Size(50, 26),
      const Color(0xFF42A5F5),
      math.cos(primaryPhase + math.pi) > 0,
    );
    // Existing fish 3 — center, teal
    _drawFish(
      canvas,
      Offset(size.width * (0.58 + 0.05 * math.sin(secondaryPhase)), size.height * 0.34),
      const Size(38, 20),
      const Color(0xFF80CBC4),
      math.cos(secondaryPhase) > 0,
    );
    // New fish 4 — top right, light blue, small, faster, moving left
    _drawFish(
      canvas,
      Offset(size.width * (0.80 + 0.06 * math.sin(tertiaryPhase + math.pi)), size.height * 0.22),
      const Size(20, 11),
      const Color(0xFF4FC3F7),
      math.cos(tertiaryPhase + math.pi) > 0,
    );
    // New fish 5 — middle left, coral orange, medium, slow, moving right
    _drawFish(
      canvas,
      Offset(size.width * (0.10 + 0.06 * math.sin(primaryPhase + 0.5)), size.height * 0.50),
      const Size(26, 13),
      const Color(0xFFFF8A65),
      math.cos(primaryPhase + 0.5) > 0,
    );
    // New fish 6 — bottom right, white, small, medium speed, moving left
    _drawFish(
      canvas,
      Offset(size.width * (0.75 + 0.05 * math.sin(secondaryPhase + math.pi)), size.height * 0.75),
      const Size(18, 9),
      Colors.white.withOpacity(0.8),
      math.cos(secondaryPhase + math.pi) > 0,
    );
    // New fish 7 — middle center, light purple, tiny, slow, moving right
    _drawFish(
      canvas,
      Offset(size.width * (0.45 + 0.04 * math.sin(primaryPhase + 1.0)), size.height * 0.36),
      const Size(14, 7),
      const Color(0xFFCE93D8),
      math.cos(primaryPhase + 1.0) > 0,
    );
  }

  void _drawFish(Canvas canvas, Offset center, Size size, Color color, bool movingRight) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (movingRight) {
      canvas.scale(-1, 1);
    }

    final body = Path()
      ..moveTo(-size.width * 0.35, 0)
      ..quadraticBezierTo(0, -size.height * 0.55, size.width * 0.32, 0)
      ..quadraticBezierTo(0, size.height * 0.55, -size.width * 0.35, 0)
      ..close();

    final tail = Path()
      ..moveTo(size.width * 0.22, 0)
      ..lineTo(size.width * 0.45, -size.height * 0.35)
      ..lineTo(size.width * 0.45, size.height * 0.35)
      ..close();

    canvas.drawPath(body, Paint()..color = color.withOpacity(0.95));
    canvas.drawPath(tail, Paint()..color = color.withOpacity(0.85));
    canvas.drawCircle(
      Offset(-size.width * 0.18, -2),
      2.2,
      Paint()..color = Colors.white.withOpacity(0.9),
    );
    canvas.drawCircle(
      Offset(-size.width * 0.18, -2),
      1.0,
      Paint()..color = Colors.black87,
    );
    canvas.restore();
  }

  void _paintBubbles(Canvas canvas, Size size) {
    const bubbleConfigs = <_BubbleSpec>[
      _BubbleSpec(0.14, 0.08, 0.20, 6),
      _BubbleSpec(0.24, 0.24, 0.22, 10),
      _BubbleSpec(0.36, 0.42, 0.17, 14),
      _BubbleSpec(0.48, 0.16, 0.23, 8),
      _BubbleSpec(0.58, 0.62, 0.18, 12),
      _BubbleSpec(0.66, 0.35, 0.21, 5),
      _BubbleSpec(0.74, 0.12, 0.19, 9),
      _BubbleSpec(0.82, 0.48, 0.24, 7),
      _BubbleSpec(0.88, 0.28, 0.16, 11),
      _BubbleSpec(0.52, 0.82, 0.20, 13),
    ];

    for (final bubble in bubbleConfigs) {
      final cycle = (progress * bubble.speed + bubble.offset) % 1.0;
      final y = size.height + bubble.radius - (cycle * (size.height + 120));
      final x = size.width * bubble.x + math.sin((progress * math.pi * 2) + bubble.offset) * 8;
      final paint = Paint()..color = Colors.white.withOpacity(bubble.opacity);
      canvas.drawCircle(Offset(x, y), bubble.radius, paint);
      canvas.drawCircle(
        Offset(x - bubble.radius * 0.28, y - bubble.radius * 0.28),
        bubble.radius * 0.28,
        Paint()
          ..color = Colors.white.withOpacity(
            (bubble.opacity + 0.08).clamp(0.0, 1.0).toDouble(),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _UnderwaterWorldPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ScubaDiverPainter extends CustomPainter {
  const _ScubaDiverPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final bob = math.sin(progress * math.pi * 2) * 2;
    final scale = math.min(size.width / 110, size.height / 80).toDouble();
    canvas.translate(0, bob);
    canvas.translate(centerX, 0);
    canvas.scale(scale, scale);
    canvas.translate(-55, 0);

    final tankRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(66, 42), width: 18, height: 40),
      const Radius.circular(8),
    );
    canvas.drawRRect(tankRect, Paint()..color = const Color(0xFF546E7A));

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(55, 48), width: 44, height: 50),
      const Radius.circular(16),
    );
    canvas.drawRRect(bodyRect, Paint()..color = const Color(0xFF1565C0));

    final limbPaint = Paint()..color = const Color(0xFF1565C0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(28, 52), width: 14, height: 42),
        const Radius.circular(10),
      ),
      limbPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(82, 52), width: 14, height: 42),
        const Radius.circular(10),
      ),
      limbPaint,
    );

    final legPaint = Paint()..color = const Color(0xFF1565C0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(45, 70), width: 12, height: 26),
        const Radius.circular(10),
      ),
      legPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(65, 70), width: 12, height: 26),
        const Radius.circular(10),
      ),
      legPaint,
    );

    canvas.drawCircle(
      const Offset(55, 20),
      18,
      Paint()..color = const Color(0xFFFFCC80),
    );

    final maskRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(55, 20), width: 32, height: 14),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      maskRect,
      Paint()..color = const Color(0xB34FC3F7),
    );
    canvas.drawRRect(
      maskRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.black87,
    );

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(41, 78), width: 18, height: 8),
      Paint()..color = const Color(0xFF1B5E20),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(69, 78), width: 18, height: 8),
      Paint()..color = const Color(0xFF1B5E20),
    );

    final bubblePaint = Paint()..color = Colors.white.withOpacity(0.6);
    for (int i = 0; i < 3; i++) {
      final localPhase = (progress + i * 0.18) % 1.0;
      final bubbleY = 28 - (localPhase * 18);
      final bubbleX = 70 + math.sin((progress * math.pi * 2) + i) * 4;
      canvas.drawCircle(Offset(bubbleX, bubbleY), 3 + i.toDouble(), bubblePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScubaDiverPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  const _DashedRoundedRectPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashLength = 8.0;
    const gapLength = 5.0;
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = math.min(distance + dashLength, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

class _DropletPainter extends CustomPainter {
  const _DropletPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.35, size.width * 0.78, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.68, size.height, size.width / 2, size.height)
      ..quadraticBezierTo(size.width * 0.32, size.height, size.width * 0.22, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.35, size.width / 2, 0)
      ..close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.8),
          color,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DropletPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 4) {
      final y = 5 + math.sin((x / size.width * math.pi * 2) + (progress * math.pi * 2)) * 3;
      path.lineTo(x, y);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      path,
      Paint()..color = const Color(0xFF4FC3F7).withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _BubbleSpec {
  const _BubbleSpec(this.x, this.offset, this.speed, this.radius, [this.opacity = 0.2]);

  final double x;
  final double offset;
  final double speed;
  final double radius;
  final double opacity;
}
