import 'package:flutter/material.dart';

// Import Tidy Town screens
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';

class TidyTownWrapper extends StatefulWidget {
  final String userPin;

  const TidyTownWrapper({super.key, required this.userPin});

  @override
  State<TidyTownWrapper> createState() => _TidyTownWrapperState();
}

class _TidyTownWrapperState extends State<TidyTownWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize services if needed
    // The Tidy Town game uses Redis and API services, but we'll skip those for now
    // and let the game initialize them if needed

    setState(() {
      _isInitialized = true;
    });
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

    // Return the Tidy Town game wrapped in a MaterialApp to provide its own navigation context
    return MaterialApp(
      title: 'Tidy Town',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
