import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'config/firebaseconfig.dart';
import 'package:supersetfirebase/provider/user_pin_provider.dart';
import 'provider/language_provider.dart';

// Global Firebase Analytics instance
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeFirebase();

  // Initialize Firebase Analytics
  await analytics.setAnalyticsCollectionEnabled(true);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => UserPinProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        Provider<FirebaseAnalytics>(create: (_) => analytics),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIH Science',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF6C63FF),
          primary: Color(0xFF6C63FF),
        ),
      ),
      home: _AuthCheckScreen(),
    );
  }
}

class _AuthCheckScreen extends StatefulWidget {
  @override
  State<_AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<_AuthCheckScreen> {
  Future<Widget> _getInitialScreen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPin = prefs.getString('user_pin');
      final savedTimestamp = prefs.getInt('user_pin_timestamp');

      if (savedPin != null && savedPin.isNotEmpty && savedTimestamp != null) {
        // Check if PIN is older than 10 hours
        final savedTime = DateTime.fromMillisecondsSinceEpoch(savedTimestamp);
        final now = DateTime.now();
        final hoursSinceSaved = now.difference(savedTime).inHours;

        if (hoursSinceSaved >= 10) {
          // PIN is older than 10 hours, delete it
          await prefs.remove('user_pin');
          await prefs.remove('user_pin_timestamp');
          return LoginScreen();
        }

        // Verify the PIN still exists in Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(savedPin)
            .get();

        if (userDoc.exists) {
          // Set PIN in provider
          Provider.of<UserPinProvider>(context, listen: false).setPin(savedPin);
          return HomeScreen(pin: savedPin);
        } else {
          // PIN doesn't exist anymore, clear saved PIN
          await prefs.remove('user_pin');
          await prefs.remove('user_pin_timestamp');
        }
      }
    } catch (e) {
      print('Error checking login status: $e');
    }

    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return snapshot.data ?? LoginScreen();
      },
    );
  }
}
