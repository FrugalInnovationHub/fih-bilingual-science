import 'dart:math';
import 'package:flutter/material.dart';
import 'tts_service.dart';

class PlanetMatchGame extends StatefulWidget {
  const PlanetMatchGame({super.key});

  @override
  State<PlanetMatchGame> createState() => _PlanetMatchGameState();
}

class _PlanetMatchGameState extends State<PlanetMatchGame> {
  bool isSpanish = false;

  final Map<String, String> planetImages = {
    'Sun': 'assets/solarexplora/planet_tiles/Sun_tile.webp',
    'Mercury': 'assets/solarexplora/planet_tiles/Mercury_tile.webp',
    'Venus': 'assets/solarexplora/planet_tiles/Venus_tile.webp',
    'Earth': 'assets/solarexplora/planet_tiles/Earth_tile.webp',
    'Mars': 'assets/solarexplora/planet_tiles/Mars_tile.webp',
    'Jupiter': 'assets/solarexplora/planet_tiles/Jupiter_tile.webp',
    'Saturn': 'assets/solarexplora/planet_tiles/Saturn_tile.webp',
    'Uranus': 'assets/solarexplora/planet_tiles/Uranus_tile.webp',
    'Neptune': 'assets/solarexplora/planet_tiles/Neptune_tile.webp',
  };

  final Map<String, String> spanishNames = {
    'Sun': 'Sol',
    'Mercury': 'Mercurio',
    'Venus': 'Venus',
    'Earth': 'Tierra',
    'Mars': 'Marte',
    'Jupiter': 'Júpiter',
    'Saturn': 'Saturno',
    'Uranus': 'Urano',
    'Neptune': 'Neptuno',
  };

  List<String> selectedPlanets = [];
  Map<String, bool> matched = {};
  String? draggedPlanet;
  List<String> shuffledLabels = [];

  @override
  void initState() {
    super.initState();
    generateRandomPlanets();
  }

  void generateRandomPlanets() {
    final allPlanets = planetImages.keys.toList()..shuffle();
    selectedPlanets = allPlanets.take(6).toList();
    matched = {for (var planet in selectedPlanets) planet: false};
    shuffledLabels = List<String>.from(selectedPlanets)..shuffle();
  }

  void checkCompletion() {
    if (matched.values.every((m) => m)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("🎉 Well Done!"),
          content: const Text("You've matched all planets correctly."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => generateRandomPlanets());
              },
              child: const Text("Play Again?"),
            ),
          ],
        ),
      );
      isSpanish = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 🔙 Back + Language Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: Colors.white),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'EN',
                          style: TextStyle(
                            color: isSpanish ? Colors.white54 : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: isSpanish,
                          onChanged: (value) {
                            setState(() => isSpanish = value);
                          },
                          activeColor: Colors.orange,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                        ),
                        Text(
                          'ES',
                          style: TextStyle(
                            color: isSpanish ? Colors.white : Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🪐 Planet Image Tiles in Grid
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: selectedPlanets.map((planet) {
                    return DragTarget<String>(
                      onWillAccept: (data) => data == planet,
                      onAccept: (data) async {
                        setState(() => matched[planet] = true);
                        // 🔊 Speak the matched planet's name
                        final label = isSpanish
                            ? spanishNames[planet]!
                            : planet;
                        final lang = isSpanish ? 'es-ES' : 'en-US';

                        await TTSService.stop(); // Ensure previous audio is stopped
                        await TTSService.speak(label, language: lang);
                        checkCompletion();
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: matched[planet]!
                                  ? Colors.green
                                  : Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: matched[planet]!
                              ? Image.asset(
                                  planetImages[planet]!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  planetImages[planet]!,
                                  fit: BoxFit.cover,
                                ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🎯 Draggable Labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: shuffledLabels.map((planet) {
                  if (matched[planet]!) return const SizedBox();
                  final label = isSpanish ? spanishNames[planet]! : planet;
                  return Draggable<String>(
                    data: planet,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Chip(
                        label: Text(
                          label,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: Chip(
                        label: Text(
                          label,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                    child: Chip(
                      backgroundColor: Colors.deepPurple,
                      label: Text(
                        label,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
