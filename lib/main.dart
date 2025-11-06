import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'config/firebaseconfig.dart';
import 'package:supersetfirebase/provider/user_pin_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeFirebase();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => UserPinProvider()),
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

      if (savedPin != null && savedPin.isNotEmpty) {
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
