import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'explore_page.dart';
import 'planet_match_game.dart';
import 'quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSpanish = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🌌 Animated space background
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: MediaQuery.of(
                  context,
                ).size.width, // Use your original Lottie animation width
                height: MediaQuery.of(
                  context,
                ).size.height, // Use original height (e.g. designed for iPad)
                child: Lottie.asset(
                  'assets/solarexplora/space_bg.json',
                  fit: BoxFit.fill, // Lottie will fill this SizedBox now
                  repeat: true,
                ),
              ),
            ),
          ),

          // 🌍 UI Content
          SafeArea(
            child: Column(
              children: [
                // 🔤 Language Toggle at top right
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
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
                              setState(() {
                                isSpanish = value;
                              });
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
                  ),
                ),

                // 🌟 Title and subtitle in the center
                const SizedBox(height: 0),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ), // Minimal top padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SolarExplora',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // SizedBox(height: 6),
                        // Text(
                        //   isSpanish
                        //       ? '¡Una plataforma bilingüe para explorar el Sistema Solar\nde una manera divertida y atractiva!'
                        //       : 'A bilingual platform to explore the Solar System\nin a fun and engaging way!!',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 18,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                const Spacer(), // Pushes the buttons to the bottom
                // 🚀 Explore and game buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ExplorePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade300
                                .withOpacity(0.9),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            isSpanish ? 'Explorar' : 'Explore',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      GameCard(
                        emoji: '',
                        title: isSpanish ? 'Juego de Planetas' : 'Planet Match',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PlanetMatchGame(),
                            ),
                          );
                        },
                      ),
                      // const SizedBox(height: 20),
                      // GameCard(
                      //     emoji: '',
                      //     title: isSpanish ? 'Construye un Cohete' : 'Build a Rocket',
                      //     onTap: () {},
                      // ),
                      const SizedBox(height: 20),
                      GameCard(
                        emoji: '',
                        title: isSpanish ? 'Quiz del Espacio' : 'Space Quiz',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const QuizPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 📦 Game Button Card
class GameCard extends StatelessWidget {
  final String emoji;
  final String title;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4, // 👈 consistent width
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade300.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30), // 👈 rounded edges
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$emoji  $title',
              style: const TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
