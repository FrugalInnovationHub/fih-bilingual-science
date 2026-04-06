import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'solar_explora/home_page.dart';
import 'solar_explora/tts_service.dart';
import 'dart:async';

class SolarExploraWrapper extends StatefulWidget {
  final String userPin;

  const SolarExploraWrapper({super.key, required this.userPin});

  @override
  State<SolarExploraWrapper> createState() => _SolarExploraWrapperState();
}

class _SolarExploraWrapperState extends State<SolarExploraWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Wrap entire initialization in a timeout to ensure game loads even if something hangs
    try {
      await Future.any([
        _doInitialize(),
        Future.delayed(const Duration(seconds: 3), () {
          debugPrint('Initialization timeout - loading game anyway');
        }),
      ]);
    } catch (e) {
      debugPrint('Initialization error: $e - loading game anyway');
    }

    // Always set initialized to true, even if initialization fails
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _doInitialize() async {
    // Initialize TTS service with timeout to prevent hanging on web
    try {
      if (kIsWeb) {
        // On web, TTS might not be fully supported, so use timeout
        await TTSService.initTTS().timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            debugPrint('TTS initialization timeout on web - continuing anyway');
          },
        );
      } else {
        await TTSService.initTTS();
      }
    } catch (e) {
      debugPrint('TTS initialization error: $e');
      // Continue even if TTS fails
    }

    // Set landscape orientation for the game (may not work on web, but won't block)
    try {
      if (!kIsWeb) {
        // Orientation changes don't work on web browsers
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    } catch (e) {
      debugPrint('Orientation setting error: $e');
    }
  }

  @override
  void dispose() {
    // Reset orientation when leaving the game (only on mobile)
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Return the Solar Explora game wrapped in a MaterialApp
    return MaterialApp(
      title: 'SolarExplora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ArialRoundedMTBold',
      ),
      home: const HomePage(),
    );
  }
}
