import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateGameScore(String pin, String gameKey, int newScore) async {
    final userDoc = users.doc(pin);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({});
    }
    print('Updating $gameKey to $newScore for user $pin');
    await userDoc.set({gameKey: newScore}, SetOptions(merge: true));
    await updateTotalScore(pin);
  }

  Future<void> updateTotalScore(String pin) async {
    final userDoc = users.doc(pin);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      // Only include remaining games (TidyTown, BioApp, etc.)
      // For now, calculate total from all scores except removed math games
      final total = (data['TotalBestScore'] ?? 0) as int;
      print('Updated TotalBestScore: $total');
      await userDoc.set({'TotalBestScore': total}, SetOptions(merge: true));
    }
  }

  Future<Map<String, int>> getUserScores(String pin) async {
    final doc = await users.doc(pin).get();
    if (!doc.exists) {
      print('No scores found for $pin');
      return {
        'TotalBestScore': 0,
      };
    }
    final data = doc.data() as Map<String, dynamic>;
    return {
      'TotalBestScore': data['TotalBestScore'] ?? 0,
    };
  }

  // To get user score in each game separately using user pin and gameKey
  Future<int> getUserScoreForGame(String pin, String gameKey) async {
    print('getUserScoreForGame - $pin');
    final doc = await users.doc(pin).get();
    if (!doc.exists) {
      print('getUserScoreForGame - No scores found for $pin');
      return 0;
    }
    final data = doc.data() as Map<String, dynamic>;
    return data[gameKey];
  }

  Future<void> updateUserScoreForGame(
      String pin, String gameKey, int newScore) async {
    print(
        'updateUserScoreForGame - Updating $gameKey to $newScore for user $pin');
    final userDoc = users.doc(pin);
    try {
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        await userDoc.set({gameKey: newScore}, SetOptions(merge: true));
        print(
            'updateUserScoreForGame - Successfully updated $gameKey for user $pin');
      } else {
        await userDoc.set({
          'TotalBestScore': 0,
        });
        await userDoc.set({gameKey: newScore}, SetOptions(merge: true));
        print(
            'updateUserScoreForGame - Successfully updated $gameKey for user $pin');
      }
      await updateTotalScore(pin);
    } catch (e) {
      print(
          'updateUserScoreForGame - Error updating $gameKey for user $pin: $e');
    }
  }
}
