import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../safe_water_heroes_wrapper.dart';

/// Provider that exposes the current user PIN.
/// When running as a wrapper, this comes from [userPinProvider].
/// When running standalone, it defaults to empty (local-only mode).
final currentUserPinProvider = Provider<String>((ref) {
  return ref.watch(userPinProvider);
});

/// Stream provider for auth state changes.
/// In the PIN-based system, this returns null when no PIN is set,
/// or a simple wrapper object when a PIN is available.
final authStateProvider = StreamProvider<PinUser?>((ref) {
  final pin = ref.watch(currentUserPinProvider);
  if (pin.isEmpty) {
    return Stream.value(null);
  }
  return Stream.value(PinUser(pin: pin));
});

/// Simple user class that wraps the PIN (replaces Firebase User)
class PinUser {
  final String pin;
  
  PinUser({required this.pin});
  
  String get uid => pin;
}

/// Controller for PIN-based authentication.
/// In the integrated version, authentication is handled by the main app.
class AuthController {
  final Ref _ref;
  
  AuthController(this._ref);

  /// In the wrapper pattern, sign-in is handled by the main app.
  /// This method is kept for standalone testing compatibility.
  Future<void> signInWithPin(String pin) async {
    debugPrint("Setting user PIN: $pin");
    _ref.read(userPinProvider.notifier).state = pin;
  }

  /// Legacy method kept for backward compatibility.
  /// In the integrated version, the main app handles auth.
  @Deprecated('Use signInWithPin instead. Firebase Auth is removed.')
  Future<void> signInAnonymously() async {
    debugPrint("signInAnonymously() called - this is now a no-op in PIN mode");
    final currentPin = _ref.read(userPinProvider);
    if (currentPin.isEmpty) {
      debugPrint("Warning: No PIN set. Running in local-only mode.");
    }
  }

  Future<void> signOut() async {
    _ref.read(userPinProvider.notifier).state = '';
    debugPrint("User signed out (PIN cleared)");
  }
}

final authControllerProvider = Provider<AuthController>((ref) => AuthController(ref));
