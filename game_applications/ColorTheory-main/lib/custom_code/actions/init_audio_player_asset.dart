// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:just_audio/just_audio.dart';

Future<dynamic> initAudioPlayerAsset(String assetPath) async {
  AudioPlayer audioPlayer = AudioPlayer();
  await audioPlayer.setAsset(assetPath);
  // FFAppState().mainMenuAudioRef = audioPlayer;
  return audioPlayer;
}
