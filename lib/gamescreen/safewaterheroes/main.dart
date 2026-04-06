import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try initializing Firebase. If it fails (e.g. no internet, bad config),
  // the app must still run in fallback mode.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e. Running in offline mode.");
  }

  runApp(const ProviderScope(child: SafeWaterHeroesApp()));
}