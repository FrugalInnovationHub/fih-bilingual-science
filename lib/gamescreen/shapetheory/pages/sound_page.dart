// Page to set the sound on/off.
import 'package:flutter/material.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/configuration.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/game_storage.dart';
import 'package:supersetfirebase/gamescreen/shapetheory/game/shape_theory_game.dart';

class SoundPage extends StatefulWidget {
  final ShapeTheoryGame game;
  static const String id = 'sound';
  const SoundPage({super.key, required this.game});

  @override
  State<SoundPage> createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SOUND',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            _soundButton(true),
            SizedBox(height: 20),
            _soundButton(false),
            SizedBox(height: 20),
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
                widget.game.overlays.remove('sound');
                widget.game.overlays.add('mainMenu');
              },
              child: Text('Back to Menu', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _soundButton(bool isEnabled) {
    bool isSelected = Configuration.soundEnabled == isEnabled;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Color.fromARGB(255, 203, 197, 244)
            : Color(0xFF9D92F5),
        foregroundColor: Colors.white,
        minimumSize: Size(230, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        Configuration.soundEnabled = isEnabled;
        GameStorage.saveSoundPreference(isEnabled);
        if (isEnabled) {
          widget.game.startBgm();
        } else {
          widget.game.stopBgm();
        }
        setState(() {});
      },
      child: Text(isEnabled ? 'ON' : 'OFF', style: TextStyle(fontSize: 25)),
    );
  }
}

