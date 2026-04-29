import 'package:flutter/material.dart';
import 'animalwizz/main.dart';

class AnimalWizzWrapper extends StatelessWidget {
  final String userPin;

  const AnimalWizzWrapper({super.key, required this.userPin});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => JungleMainPage(userPin: userPin),
      ),
    );
  }
}
