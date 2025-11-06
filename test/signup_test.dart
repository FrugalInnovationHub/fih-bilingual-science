import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supersetfirebase/screens/signup_screen.dart';
import 'package:supersetfirebase/screens/login_screen.dart';

void main() {
  group('Signup Screen Tests', () {
    testWidgets('Signup screen displays correctly',
        (WidgetTester tester) async {
      // Build the signup screen
      await tester.pumpWidget(
        MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Verify that the main elements are present
      expect(find.text('BILINGUAL'), findsOneWidget);
      expect(find.text('SCIENTISTS'), findsOneWidget);
      expect(find.text('Learning Made Fun'), findsOneWidget);
      expect(find.text('Create Your Access Code'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Sign Up!'), findsOneWidget);
      expect(find.text('Back to Login'), findsOneWidget);
    });

    testWidgets('Name field accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Find the name text field and enter text
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'Test User');
      await tester.pump();

      // Verify the text was entered
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('PIN fields accept input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Find all text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4)); // Name field + 3 PIN fields

      // Enter 1, 2, 3 in the PIN fields (skip the first one which is the name field)
      await tester.enterText(textFields.at(1), '1');
      await tester.pump();
      await tester.enterText(textFields.at(2), '2');
      await tester.pump();
      await tester.enterText(textFields.at(3), '3');
      await tester.pump();

      // Verify the numbers were entered
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('Shows error for incomplete PIN', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Enter only 2 digits in PIN
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(1), '1');
      await tester.pump();
      await tester.enterText(textFields.at(2), '2');
      await tester.pump();

      // Tap the signup button
      await tester.tap(find.text('Sign Up!'));
      await tester.pump();

      // Verify error message appears
      expect(find.text('Oops! We need all 3 numbers for your secret code! 🎯'),
          findsOneWidget);
    });

    testWidgets('Navigation to login screen works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Tap the "Back to Login" button
      await tester.tap(find.text('Back to Login'));
      await tester.pump();

      // Verify we're on the login screen
      expect(find.text('Enter Your Access Code'), findsOneWidget);
      expect(find.text("Let's Play"), findsOneWidget);
    });
  });
}
