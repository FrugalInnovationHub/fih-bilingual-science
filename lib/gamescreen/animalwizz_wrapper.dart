import 'package:flutter/material.dart';
import 'animalwizz/main.dart';

class AnimalWizzWrapper extends StatelessWidget {
  final String userPin;

  const AnimalWizzWrapper({super.key, required this.userPin});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const MyApp(), // The AnimalWizz MaterialApp
        // Floating back button to return to the parent Home Screen
        Positioned(
          top: 40,
          left: 16,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
