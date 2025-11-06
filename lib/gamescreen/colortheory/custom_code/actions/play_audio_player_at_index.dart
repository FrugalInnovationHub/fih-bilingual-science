// Automatic FlutterFlow imports
import '../../backend/schema/structs/index.dart';
import '../../backend/schema/enums/enums.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

import 'package:just_audio/just_audio.dart';

Future playAudioPlayerAtIndex(
  List<dynamic> audioPlayerList,
  int audioIndex,
  double soundVolume,
) async {
  try {
    if (audioIndex < 0 || audioIndex >= audioPlayerList.length) {
      print('Invalid audio index: $audioIndex');
      return;
    }

    final AudioPlayer audioPlayer = audioPlayerList[audioIndex];

    // Stop if already playing (just in case)
    if (audioPlayer.playing) {
      await audioPlayer.stop();
    }

    await audioPlayer.seek(Duration.zero);
    await audioPlayer.setVolume(soundVolume);
    await audioPlayer.play();
  } catch (e, stackTrace) {
    print('Error in playAudioPlayerAtIndex: $e');
    print('Stack trace: $stackTrace');
  }
}
