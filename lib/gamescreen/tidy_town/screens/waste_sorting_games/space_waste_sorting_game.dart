import 'package:flutter/material.dart';
import 'base_waste_sorting_game.dart';

class SpaceWasteSortingGame extends BaseWasteSortingGame {
  const SpaceWasteSortingGame({super.key});

  @override
  State<SpaceWasteSortingGame> createState() => _SpaceWasteSortingGameState();
}

class _SpaceWasteSortingGameState
    extends BaseWasteSortingGameState<SpaceWasteSortingGame> {
  @override
  String get gameTitle => 'Space Mission 🚀';

  @override
  String get welcomeMessage =>
      'Meet Captain Luna! She\'s on a mission to clean up space debris around Earth. Help her sort the items she finds during her cosmic journey!';

  @override
  Color get primaryColor => Colors.purple;

  @override
  Color get secondaryColor => Colors.deepPurple;

  @override
  List<Color> get backgroundGradient => [
        Colors.purple.withOpacity(0.3),
        Colors.deepPurple.withOpacity(0.2),
      ];

  @override
  Map<String, String> get binImages => {
        'compost': 'assets/tidytown/images/game/bin_green.png',
        'recycle': 'assets/tidytown/images/game/bin_yellow.png',
        'landfill': 'assets/tidytown/images/game/bin_red.png',
      };

  @override
  List<String> get binOrder => ['compost', 'recycle', 'landfill'];

  @override
  List<Map<String, dynamic>> get wasteItems => [
        // COMPOST ITEMS (4+)
        {
          'name': 'Space Garden Scraps',
          'image': 'assets/tidytown/images/game/apple_core.png',
          'correctBin': 'compost',
          'description':
              'I\'m leftover food from the space station garden! Captain Luna can compost me to grow more plants in space!',
        },
        {
          'name': 'Astronaut Food Waste',
          'image': 'assets/tidytown/images/game/banana_peel.png',
          'correctBin': 'compost',
          'description':
              'I\'m food scraps from Captain Luna\'s space meals! I can become soil for space farming!',
        },
        {
          'name': 'Space Coffee Grounds',
          'image': 'assets/tidytown/images/game/coffee_grounds.png',
          'correctBin': 'compost',
          'description':
              'I\'m coffee grounds from Captain Luna\'s morning brew! I can help grow plants in the space garden!',
        },
        {
          'name': 'Hydroponic Plant Waste',
          'image': 'assets/tidytown/images/game/apple_core.png',
          'correctBin': 'compost',
          'description':
              'I\'m old plant matter from the space station\'s hydroponic farm! Captain Luna can compost me for new crops!',
        },
        // RECYCLE ITEMS (4+)
        {
          'name': 'Satellite Metal Piece',
          'image': 'assets/tidytown/images/game/aluminum_can.png',
          'correctBin': 'recycle',
          'description':
              'Captain Luna found me floating from an old satellite! I can be recycled into new space equipment!',
        },
        {
          'name': 'Fuel Container',
          'image': 'assets/tidytown/images/game/plastic_bottle.png',
          'correctBin': 'recycle',
          'description':
              'Captain Luna discovered me drifting near the space station! I held rocket fuel and can be recycled!',
        },
        {
          'name': 'Mission Reports',
          'image': 'assets/tidytown/images/game/newspaper.png',
          'correctBin': 'recycle',
          'description':
              'I\'m old space mission documents Captain Luna collected! I can be recycled into new paper!',
        },
        {
          'name': 'Space Station Metal Scraps',
          'image': 'assets/tidytown/images/game/aluminum_can.png',
          'correctBin': 'recycle',
          'description':
              'I\'m metal pieces from space station maintenance! Captain Luna can recycle me into new parts!',
        },
        // LANDFILL ITEMS (4+) - Including your specified items
        {
          'name': 'Rocket Waste',
          'image': 'assets/tidytown/images/game/broken_glass.png',
          'correctBin': 'landfill',
          'description':
              'I\'m damaged rocket components Captain Luna found! I\'m too contaminated with fuel to recycle safely!',
        },
        {
          'name': 'Space Jet Waste',
          'image': 'assets/tidytown/images/game/plastic_bag.png',
          'correctBin': 'landfill',
          'description':
              'I\'m debris from old space jets! Captain Luna knows I contain hazardous materials that need special disposal!',
        },
        {
          'name': 'Damaged Solar Panel',
          'image': 'assets/tidytown/images/game/broken_glass.png',
          'correctBin': 'landfill',
          'description':
              'I\'m a broken solar panel Captain Luna found! I\'m too damaged and contain toxic materials for safe recycling!',
        },
        {
          'name': 'Contaminated Lab Equipment',
          'image': 'assets/tidytown/images/game/plastic_bag.png',
          'correctBin': 'landfill',
          'description':
              'I\'m lab equipment from space experiments! Captain Luna knows I\'m contaminated and need hazardous waste disposal!',
        },
      ];
}
