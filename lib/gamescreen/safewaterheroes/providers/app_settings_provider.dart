import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final String languageCode; // Always 'en' for UI text
  final String audioLanguageCode; // 'en' or 'es' for voice only
  final bool isMuted;
  final bool hoverSpeakEnabled; // Only relevant on Web

  AppSettings({
    this.languageCode = 'en', // UI text is always English
    this.audioLanguageCode = 'en', // Audio defaults to English
    this.isMuted = false,
    this.hoverSpeakEnabled = false,
  });

  AppSettings copyWith({
    String? languageCode,
    String? audioLanguageCode,
    bool? isMuted,
    bool? hoverSpeakEnabled,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      audioLanguageCode: audioLanguageCode ?? this.audioLanguageCode,
      isMuted: isMuted ?? this.isMuted,
      hoverSpeakEnabled: hoverSpeakEnabled ?? this.hoverSpeakEnabled,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(AppSettings());

  void toggleAudioLanguage() {
    state = state.copyWith(
      audioLanguageCode: state.audioLanguageCode == 'en' ? 'es' : 'en',
    );
  }

  void resetAudioToEnglish() {
    if (state.audioLanguageCode != 'en') {
      state = state.copyWith(audioLanguageCode: 'en');
    }
  }

  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }

  void toggleHoverSpeak() {
    state = state.copyWith(hoverSpeakEnabled: !state.hoverSpeakEnabled);
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});