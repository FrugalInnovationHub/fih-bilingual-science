import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/strings.dart';
import '../data/filter_technique_info.dart';
import '../providers/app_settings_provider.dart';
import '../services/audio_controller.dart';

class FilterInfoPopup extends ConsumerStatefulWidget {
  const FilterInfoPopup({
    super.key,
    required this.info,
    required this.onClose,
    required this.audioController,
  });

  final FilterTechniqueInfo info;
  final VoidCallback onClose;
  final AudioController audioController;

  @override
  ConsumerState<FilterInfoPopup> createState() => _FilterInfoPopupState();
}

class _FilterInfoPopupState extends ConsumerState<FilterInfoPopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lang = ref.read(appSettingsProvider).audioLanguageCode;
      widget.audioController.requestSpeak(
        AppStrings.translateForAudio(widget.info.introVoiceLine, lang),
      );
    });
  }

  @override
  void dispose() {
    widget.audioController.stop();
    super.dispose();
  }

  void _close() {
    widget.audioController.stop();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: media.size.height * 0.92,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(22, 18, 16, 18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.info.accentColor,
                          widget.info.accentColor.withOpacity(0.75),
                        ],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.info.displayName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.info.introVoiceLine,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.92),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Material(
                          color: Colors.white.withOpacity(0.22),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              final lang = ref.read(appSettingsProvider).audioLanguageCode;
                              widget.audioController.requestSpeak(
                                AppStrings.translateForAudio(widget.info.introVoiceLine, lang),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.volume_up_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: widget.info.accentColor.withOpacity(0.05),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        widget.info.infographicImagePath,
                        width: double.infinity,
                        height: 460,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stack) => Container(
                          height: 460,
                          color: widget.info.accentColor.withOpacity(0.08),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  color: widget.info.accentColor,
                                  size: 56,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Image coming soon',
                                  style: TextStyle(
                                    color: widget.info.accentColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Materials you will need',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0277BD),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.info.materials.map((material) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFF4FC3F7).withOpacity(0.14),
                                border: Border.all(
                                  color: const Color(0xFF4FC3F7),
                                  width: 1.3,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                material,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0277BD),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        onTap: _close,
                        borderRadius: BorderRadius.circular(28),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0288D1), Color(0xFF26C6DA)],
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: const Text(
                            "Got it! Let's build 🤿",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
