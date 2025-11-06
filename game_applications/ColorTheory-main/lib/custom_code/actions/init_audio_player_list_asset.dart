// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:just_audio/just_audio.dart';

Future<List<dynamic>> initAudioPlayerListAsset(
    List<String> assetPathList) async {
  List<AudioPlayer> audioPlayers = [];

  for (String path in assetPathList) {
    final player = AudioPlayer();

    try {
      await player.setAsset(path);
      await player.setLoopMode(LoopMode.off);

      audioPlayers.add(player);
    } catch (e) {
      print('Error loading asset: $path — $e');
      await player.dispose();
    }
  }

  return audioPlayers;
}
