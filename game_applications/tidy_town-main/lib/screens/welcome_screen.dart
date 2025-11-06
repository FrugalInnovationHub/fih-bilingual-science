import 'package:flutter/material.dart';
import 'package:tidy_town/screens/home_screen.dart';
import '../utils/transitions.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          SizedBox.expand(
            child: Image.asset(
              'assets/tidytown/images/welcome.gif',
              fit: BoxFit.cover,
            ),
          ),

          // Get Started button at bottom center
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(AppTransitions.zoom(const HomeScreen()));
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6E96F), // Yellow
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40), // Round corners
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'ComicNeue', // Custom font
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
