import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_progress.dart';
import 'auth_provider.dart';

/// Game key used in the main app's Firestore structure.
/// Scores are stored as: users/{pin}/SafeWaterHeroes: score
const String safeWaterHeroesGameKey = 'SafeWaterHeroes';

final userProgressProvider = StateNotifierProvider<UserProgressNotifier, UserProgress>((ref) {
  final userAsync = ref.watch(authStateProvider);
  final user = userAsync.value;
  return UserProgressNotifier(user?.uid);
});

class UserProgressNotifier extends StateNotifier<UserProgress> {
  final String? _userPin;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _firestoreSubscription;
  bool _isFirebaseAvailable = false;

  UserProgressNotifier(this._userPin) : super(UserProgress.initial()) {
    _init();
  }

  void _init() async {
    try {
       if (FirebaseFirestore.instance.app.options.projectId.isEmpty) throw Exception("No config");
       _isFirebaseAvailable = true;
    } catch(e) {
       _isFirebaseAvailable = false;
       debugPrint("Firestore not available for progress sync. Using local only.");
    }

    if (_isFirebaseAvailable && _userPin != null && _userPin!.isNotEmpty) {
      _firestoreSubscription = _firestore
          .collection('users')
          .doc(_userPin)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          state = UserProgress.fromFirestore(snapshot);
        } else {
          _syncToFirestore(state);
        }
      }, onError: (e) {
         debugPrint("Firestore listen error: $e. Switching to local.");
         _isFirebaseAvailable = false;
      });
    }
  }

  Future<void> _syncToFirestore(UserProgress newState) async {
    if (_isFirebaseAvailable && _userPin != null && _userPin!.isNotEmpty) {
      try {
        await _firestore.collection('users').doc(_userPin).set(
          newState.toFirestore(),
          SetOptions(merge: true)
        );
      } catch (e) {
         debugPrint("Sync failed: $e");
      }
    }
  }

  /// Syncs the total score to the main app's format.
  /// This stores the score in the same structure as other games:
  /// users/{pin}/SafeWaterHeroes: score
  Future<void> _syncScoreToMainAppFormat(int score) async {
    if (_isFirebaseAvailable && _userPin != null && _userPin!.isNotEmpty) {
      try {
        await _firestore.collection('users').doc(_userPin).set(
          {safeWaterHeroesGameKey: score},
          SetOptions(merge: true)
        );
        debugPrint("Synced $safeWaterHeroesGameKey score: $score for user $_userPin");
      } catch (e) {
        debugPrint("Failed to sync main app score: $e");
      }
    }
  }

  /// Calculates the total game score based on badges and coins.
  int _calculateTotalScore() {
    int score = state.coins;
    if (state.sortingBadged) score += 50;
    if (state.filterBadged) score += 50;
    if (state.adventureBadged) score += 50;
    score += state.completedLessons.length * 10;
    return score;
  }

  @override
  void dispose() {
    _firestoreSubscription?.cancel();
    super.dispose();
  }

  void addCoins(int amount) {
    final newState = state.copyWith(coins: state.coins + amount);
    state = newState;
    _syncToFirestore(newState);
    _syncScoreToMainAppFormat(_calculateTotalScore());
  }

  void markLessonComplete(int lessonId) {
    if (!state.completedLessons.contains(lessonId)) {
      final updatedList = [...state.completedLessons, lessonId];
      final newState = state.copyWith(
        completedLessons: updatedList,
        coins: state.coins + 10
      );
      state = newState;
      _syncToFirestore(newState);
      _syncScoreToMainAppFormat(_calculateTotalScore());
    }
  }

  void markGameBadge(String gameType) {
    UserProgress newState = state;
    if (gameType == 'sorting') newState = state.copyWith(sortingBadged: true);
    if (gameType == 'filter') newState = state.copyWith(filterBadged: true);
    if (gameType == 'adventure') newState = state.copyWith(adventureBadged: true);

    if (newState != state) {
       state = newState;
       _syncToFirestore(newState);
       _syncScoreToMainAppFormat(_calculateTotalScore());
    }
  }

  Future<void> resetProgress() async {
     final newState = UserProgress.initial();
     state = newState;
     if (_isFirebaseAvailable && _userPin != null && _userPin!.isNotEmpty) {
        await _firestore.collection('users').doc(_userPin).set(newState.toFirestore());
        await _syncScoreToMainAppFormat(0);
     }
  }
}
