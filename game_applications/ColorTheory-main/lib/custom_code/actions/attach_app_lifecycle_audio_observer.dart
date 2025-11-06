// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';

class _AudioLifecycleObserver with WidgetsBindingObserver {
  _AudioLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _cleanupPlayer(
      AudioPlayer? playerRef, void Function() clearRef) async {
    if (playerRef != null) {
      await playerRef.stop();
      await playerRef.dispose();
      clearRef();
    }
  }

  Future<void> _cleanupPlayerList(
      List<dynamic>? playerList, void Function() clearRef) async {
    if (playerList != null) {
      for (final item in playerList) {
        if (item is AudioPlayer) {
          await item.stop();
          await item.dispose();
        }
      }
    }
    clearRef();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      await _cleanupPlayer(
        FFAppState().mainMenuAudioRef,
        () => FFAppState().mainMenuAudioRef = null,
      );

      await _cleanupPlayerList(
        FFAppState().colorAudioEnRef,
        () => FFAppState().colorAudioEnRef = [],
      );

      await _cleanupPlayerList(
        FFAppState().colorAudioEsRef,
        () => FFAppState().colorAudioEsRef = [],
      );

      await _cleanupPlayer(
        FFAppState().gameOverAudioRef,
        () => FFAppState().gameOverAudioRef = null,
      );
      FFAppState().audioInitialized = false;
    } else if (state == AppLifecycleState.resumed) {
      if (!FFAppState().audioInitialized) {
        print("Audio initialization started.");
        try {
          final mainPlayer = AudioPlayer();
          await mainPlayer.setAsset(FFAppConstants.MainMenuBgAudioAssetPath);
          await mainPlayer.setLoopMode(LoopMode.one);
          await mainPlayer.setVolume(FFAppState().soundVolumeBg);

          FFAppState().mainMenuAudioRef = mainPlayer;

          if (FFAppState().enableSound && !FFAppState().pauseSound) {
            unawaited(mainPlayer.play());
          }

          FFAppState().colorAudioEnRef =
              await initAudioPlayerRefsFromAssetPaths(
                  FFAppConstants.ColorAudioAssetPathEn);

          FFAppState().colorAudioEsRef =
              await initAudioPlayerRefsFromAssetPaths(
                  FFAppConstants.ColorAudioAssetPathEs);

          final gameOverPlayer = AudioPlayer();
          await gameOverPlayer.setAsset(FFAppConstants.GameOverAudioAssetPath);
          await gameOverPlayer.setLoopMode(LoopMode.off);
          FFAppState().gameOverAudioRef = gameOverPlayer;
          print("Audio initialization done");
          FFAppState().audioInitialized = true;
        } catch (e) {
          print('Error reinitializing audio refs on resume');
        }
      }
    }
  }

  Future<void> handleInitialStartup() async {
    try {
      final mainPlayer = AudioPlayer();
      await mainPlayer.setAsset(FFAppConstants.MainMenuBgAudioAssetPath);
      await mainPlayer.setLoopMode(LoopMode.one);
      await mainPlayer.setVolume(FFAppState().soundVolumeBg);
      FFAppState().mainMenuAudioRef = mainPlayer;

      if (FFAppState().enableSound && !FFAppState().pauseSound) {
        await mainPlayer.play();
      }

      FFAppState().colorAudioEnRef = await initAudioPlayerRefsFromAssetPaths(
        FFAppConstants.ColorAudioAssetPathEn,
      );

      FFAppState().colorAudioEsRef = await initAudioPlayerRefsFromAssetPaths(
        FFAppConstants.ColorAudioAssetPathEs,
      );

      final gameOverPlayer = AudioPlayer();
      await gameOverPlayer.setAsset(FFAppConstants.GameOverAudioAssetPath);
      await gameOverPlayer.setLoopMode(LoopMode.off);
      FFAppState().gameOverAudioRef = gameOverPlayer;
      print('Audio initialized on app start');
    } catch (e) {
      print('Failed to initialize audio on app start');
    }
  }
}

Future<void> attachAppLifecycleAudioObserver() async {
  final observer = _AudioLifecycleObserver();
  if (!FFAppState().audioInitialized) {
    await observer.handleInitialStartup();
    FFAppState().audioInitialized = true;
  }
}

Future<List<AudioPlayer>> initAudioPlayerRefsFromAssetPaths(
    List<String> assetPathList) async {
  List<AudioPlayer> audioPlayers = [];

  for (String path in assetPathList) {
    final player = AudioPlayer();

    try {
      await player.setAsset(path);
      await player.setLoopMode(LoopMode.off);
      audioPlayers.add(player);
    } catch (e) {
      print('Error loading asset');
      await player.dispose();
    }
  }

  print('Initialized ${audioPlayers.length} audio players.');
  return audioPlayers;
}
