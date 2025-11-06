import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supersetfirebase/services/firestore_score.dart';
import 'package:supersetfirebase/firebase_options.dart';

void main() {
  group('Firebase Signup Integration Tests', () {
    setUpAll(() async {
      // Initialize Firebase for testing
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });
    test('FirestoreService can create user document', () async {
      // This test verifies that our FirestoreService can work with user documents
      final firestoreService = FirestoreService();

      // Test data
      const testPin = '999';
      const testName = 'Test User';

      try {
        // Create a test user document
        await FirebaseFirestore.instance.collection('users').doc(testPin).set({
          'pin': testPin,
          'name': testName,
          'created_at': FieldValue.serverTimestamp(),
          'MathMingle': 0,
          'MathEquations': 0,
          'MathOperators': 0,
          'TotalBestScore': 0,
        });

        // Verify the document was created
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(testPin)
            .get();
        expect(doc.exists, isTrue);

        final data = doc.data() as Map<String, dynamic>;
        expect(data['pin'], equals(testPin));
        expect(data['name'], equals(testName));
        expect(data['MathMingle'], equals(0));
        expect(data['MathEquations'], equals(0));
        expect(data['MathOperators'], equals(0));
        expect(data['TotalBestScore'], equals(0));

        // Test updating scores
        await firestoreService.updateGameScore(testPin, 'MathMingle', 100);
        final updatedDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(testPin)
            .get();
        final updatedData = updatedDoc.data() as Map<String, dynamic>;
        expect(updatedData['MathMingle'], equals(100));
        expect(updatedData['TotalBestScore'], equals(100));

        // Clean up - delete the test document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(testPin)
            .delete();

        print('✅ Firebase integration test passed!');
      } catch (e) {
        print('❌ Firebase integration test failed: $e');
        rethrow;
      }
    });

    test('User document structure matches expected format', () async {
      const testPin = '888';

      try {
        // Create a test user document with the same structure as our signup
        await FirebaseFirestore.instance.collection('users').doc(testPin).set({
          'pin': testPin,
          'name': 'Test User',
          'created_at': FieldValue.serverTimestamp(),
          'MathMingle': 0,
          'MathEquations': 0,
          'MathOperators': 0,
          'TotalBestScore': 0,
        });

        // Test that FirestoreService can read the user scores
        final firestoreService = FirestoreService();
        final scores = await firestoreService.getUserScores(testPin);

        expect(scores['MathMingle'], equals(0));
        expect(scores['MathEquations'], equals(0));
        expect(scores['MathOperators'], equals(0));
        expect(scores['TotalBestScore'], equals(0));

        // Clean up
        await FirebaseFirestore.instance
            .collection('users')
            .doc(testPin)
            .delete();

        print('✅ User document structure test passed!');
      } catch (e) {
        print('❌ User document structure test failed: $e');
        rethrow;
      }
    });
  });
}
