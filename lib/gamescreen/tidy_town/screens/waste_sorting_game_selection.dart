import 'package:flutter/material.dart';
import 'waste_sorting_game.dart'; // Original game
import 'waste_sorting_games/village_waste_sorting_game.dart';
import 'waste_sorting_games/town_waste_sorting_game.dart';
import 'waste_sorting_games/space_waste_sorting_game.dart';
import 'waste_sorting_games/beach_waste_sorting_game.dart';
import '../services/translation_service.dart';

class GameTheme {
  final String id;
  final String name;
  final String description;
  final String thumbnailImage;
  final Color primaryColor;
  final Color secondaryColor;

  GameTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailImage,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

class WasteSortingGameSelection extends StatefulWidget {
  const WasteSortingGameSelection({super.key});

  @override
  State<WasteSortingGameSelection> createState() =>
      _WasteSortingGameSelectionState();
}

class _WasteSortingGameSelectionState extends State<WasteSortingGameSelection> {
  final TranslationService _translationService = TranslationService();

  final List<GameTheme> gameThemes = [
    GameTheme(
      id: 'original',
      name: 'Waste Sorting Game',
      description: 'Learn to sort waste into the right bins!',
      thumbnailImage: 'assets/tidytown/images/1.png', // Original game thumbnail
      primaryColor: Colors.orange,
      secondaryColor: Colors.deepOrange,
    ),
    GameTheme(
      id: 'village',
      name: 'Village Adventure',
      description: 'Help Farmer Sam keep the peaceful village clean!',
      thumbnailImage:
          'assets/tidytown/images/village_thumbnail.png', // NEW: Village with Farmer Sam
      primaryColor: Colors.green,
      secondaryColor: Colors.lightGreen,
    ),
    GameTheme(
      id: 'town',
      name: 'Town Explorer',
      description: 'Help Maya sort waste in the busy town center!',
      thumbnailImage:
          'assets/tidytown/images/town_thumbnail.png', // NEW: Urban scene with Maya
      primaryColor: Colors.blue,
      secondaryColor: Colors.lightBlue,
    ),
    GameTheme(
      id: 'space',
      name: 'Space Mission',
      description: 'Help Captain Luna clean up space debris!',
      thumbnailImage:
          'assets/tidytown/images/space_thumbnail.png', // NEW: Space scene with Captain Luna
      primaryColor: Colors.purple,
      secondaryColor: Colors.deepPurple,
    ),
    GameTheme(
      id: 'beach',
      name: 'Beach Cleanup with Alex',
      description: 'Help Ocean Alex save marine life and discover beach waste!',
      thumbnailImage: 'assets/tidytown/images/beach_thumbnail.png',
      primaryColor: Colors.cyan,
      secondaryColor: Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _translationService.translate('Choose Your Adventure 🌍'),
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: Colors.green.shade900,
            ),
            onPressed: () {
              _translationService.toggleLanguage();
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB2E3F6), Color(0xFFF6F9D2)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                _translationService.translate(
                  'Select a theme for your waste sorting adventure!',
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue',
                  color: Color(0xFF4A3728),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: gameThemes.length,
                  itemBuilder: (context, index) {
                    final theme = gameThemes[index];
                    return _buildThemeCard(theme);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(GameTheme theme) {
    return GestureDetector(
      onTap: () {
        Widget gameScreen;
        switch (theme.id) {
          case 'original':
            gameScreen = const WasteSortingGame();
            break;
          case 'village':
            gameScreen = const VillageWasteSortingGame();
            break;
          case 'town':
            gameScreen = const TownWasteSortingGame();
            break;
          case 'space':
            gameScreen = const SpaceWasteSortingGame();
            break;
          case 'beach':
            gameScreen = const BeachWasteSortingGame();
            break;
          default:
            gameScreen = const WasteSortingGame();
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => gameScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.8),
              theme.secondaryColor.withOpacity(0.6),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white.withOpacity(0.9),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    theme.thumbnailImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.primaryColor.withOpacity(0.3),
                        child: Icon(
                          _getThemeIcon(theme.id),
                          size: 60,
                          color: theme.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _translationService.translate(theme.name),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _translationService.translate(theme.description),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'ComicNeue',
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getThemeIcon(String themeId) {
    switch (themeId) {
      case 'village':
        return Icons.home;
      case 'town':
        return Icons.location_city;
      case 'space':
        return Icons.rocket_launch;
      case 'beach':
        return Icons.beach_access;
      default:
        return Icons.eco;
    }
  }
}
