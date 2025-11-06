import 'package:flutter/material.dart';
import 'base_waste_sorting_game.dart';

class VillageWasteSortingGame extends BaseWasteSortingGame {
  const VillageWasteSortingGame({super.key});

  @override
  State<VillageWasteSortingGame> createState() =>
      _VillageWasteSortingGameState();
}

class _VillageWasteSortingGameState
    extends BaseWasteSortingGameState<VillageWasteSortingGame> {
  @override
  String get gameTitle => 'Village Adventure 🏘️';

  @override
  String get welcomeMessage =>
      'Meet Farmer Sam! He loves keeping the village clean and green. Help him sort the waste items he finds while tending to the village gardens!';

  @override
  Color get primaryColor => Colors.green;

  @override
  Color get secondaryColor => Colors.lightGreen;

  @override
  List<Color> get backgroundGradient => [
        Colors.green.withOpacity(0.3),
        Colors.lightGreen.withOpacity(0.2),
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
        // COMPOST ITEMS (4+) - Including your specified items
        {
          'name': 'Banana Peels',
          'image': 'assets/tidytown/images/game/banana_peel.png',
          'correctBin': 'compost',
          'description':
              'I\'m banana peels from the village market! Farmer Sam knows I can enrich the soil for vegetables!',
        },
        {
          'name': 'Animal Waste',
          'image': 'assets/tidytown/images/game/coffee_grounds.png',
          'correctBin': 'compost',
          'description':
              'I\'m animal manure from the village farm! Farmer Sam uses me as natural fertilizer for the crops!',
        },
        {
          'name': 'Orchard Apple Cores',
          'image': 'assets/tidytown/images/game/apple_core.png',
          'correctBin': 'compost',
          'description':
              'Farmer Sam found me under the old apple tree! I can help grow more fruit in the village garden!',
        },
        {
          'name': 'Café Coffee Grounds',
          'image': 'assets/tidytown/images/game/coffee_grounds.png',
          'correctBin': 'compost',
          'description':
              'I\'m coffee grounds from the village café! Farmer Sam uses me to help his tomatoes grow big and strong!',
        },
        // RECYCLE ITEMS (4+)
        {
          'name': 'Village Newsletter',
          'image': 'assets/tidytown/images/game/newspaper.png',
          'correctBin': 'recycle',
          'description':
              'I\'m the weekly village newsletter Sam collected from mailboxes! I can become new paper for the community!',
        },
        {
          'name': 'Grandma\'s Jam Jars',
          'image': 'assets/tidytown/images/game/aluminum_can.png',
          'correctBin': 'recycle',
          'description':
              'I\'m empty jam jars from Grandma\'s kitchen! Sam can recycle me into new containers for the village!',
        },
        {
          'name': 'Delivery Cardboard',
          'image': 'assets/tidytown/images/game/plastic_bottle.png',
          'correctBin': 'recycle',
          'description':
              'I\'m cardboard boxes from village deliveries! Farmer Sam can recycle me into new packaging!',
        },
        {
          'name': 'Metal Farm Tools',
          'image': 'assets/tidytown/images/game/aluminum_can.png',
          'correctBin': 'recycle',
          'description':
              'I\'m old metal tools from the farm! Sam can recycle me into new farming equipment for the village!',
        },
        // LANDFILL ITEMS (4+)
        {
          'name': 'Store Plastic Bags',
          'image': 'assets/tidytown/images/game/plastic_bag.png',
          'correctBin': 'landfill',
          'description':
              'I\'m plastic bags that blew away from the village store! Sam knows I need special disposal to protect animals!',
        },
        {
          'name': 'Workshop Pottery Shards',
          'image': 'assets/tidytown/images/game/broken_glass.png',
          'correctBin': 'landfill',
          'description':
              'I\'m broken pottery from the village craft workshop! I\'m too sharp to recycle, so I need safe disposal!',
        },
        {
          'name': 'Old Paint Cans',
          'image': 'assets/tidytown/images/game/plastic_bag.png',
          'correctBin': 'landfill',
          'description':
              'I\'m old paint cans from village house repairs! I contain toxic chemicals that need hazardous waste disposal!',
        },
        {
          'name': 'Worn Out Rubber Boots',
          'image': 'assets/tidytown/images/game/broken_glass.png',
          'correctBin': 'landfill',
          'description':
              'I\'m old rubber boots from farm work! I\'m too worn and mixed materials to recycle properly!',
        },
      ];
}
