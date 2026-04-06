import 'package:flutter/services.dart';

class AudioGuard {
  static bool? _soundsValid;

  static Future<bool> soundsValid() async {
    if (_soundsValid != null) return _soundsValid!;
    const soundAssets = [
      'assets/measurements/sounds/background_music.mp3',
      'assets/measurements/sounds/correct.mp3',
      'assets/measurements/sounds/wrong.mp3',
    ];

    try {
      for (final asset in soundAssets) {
        final data = await rootBundle.load(asset);
        if (data.lengthInBytes < 1024) {
          _soundsValid = false;
          return _soundsValid!;
        }
      }
      _soundsValid = true;
    } catch (_) {
      _soundsValid = false;
    }

    return _soundsValid!;
  }
}
