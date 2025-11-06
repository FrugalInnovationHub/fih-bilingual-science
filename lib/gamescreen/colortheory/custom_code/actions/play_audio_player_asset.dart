// Automatic FlutterFlow imports
import '../../backend/schema/structs/index.dart';
import '../../backend/schema/enums/enums.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:just_audio/just_audio.dart';
// import 'dart:async';

Future playAudioPlayerAsset(
    dynamic mainMenuAudioRef, double soundVolume, bool enableLoop) async {
  AudioPlayer audioPlayer = mainMenuAudioRef;
  if (enableLoop) {
    await audioPlayer
        .setLoopMode(LoopMode.one); // Set the player to loop the current track
  } else {
    await audioPlayer.seek(Duration.zero);
  }
  await audioPlayer.setVolume(soundVolume);
  await audioPlayer.play(); // Play the audio
}
