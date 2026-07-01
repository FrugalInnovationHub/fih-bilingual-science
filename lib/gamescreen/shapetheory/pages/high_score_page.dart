import 'package:flutter/material.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/game_storage.dart';

class HighScorePage extends StatelessWidget {
  final ShapeTheoryGame game;
  const HighScorePage({super.key, required this.game});

  static const _headerStyle = TextStyle(
    fontSize: 36,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const _bodyStyle = TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      // Keep the background transparent so the game engine shows through
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(child: Text('RANK', style: _headerStyle)),
                ),
                Expanded(
                  flex: 3,
                  child: Center(child: Text('SCORE', style: _headerStyle)),
                ),
                Expanded(
                  flex: 4,
                  child: Center(child: Text('DATE', style: _headerStyle)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 580,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: GameStorage.loadScores(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  final scores = snapshot.data ?? [];

                  if (scores.isEmpty) {
                    return Center(
                      child: Text(
                        'No Scores Yet, Play The Game!',
                        style: _bodyStyle,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      final entry = scores[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text('${index + 1}', style: _bodyStyle),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  '${entry['score']}',
                                  style: _bodyStyle,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  '${entry['date']}',
                                  style: _bodyStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D92F5),
                foregroundColor: Colors.white,
                minimumSize: const Size(230, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                game.overlays.remove('highScore');
                game.overlays.add('mainMenu');
              },
              child: const Text('Back to Menu', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }
}

