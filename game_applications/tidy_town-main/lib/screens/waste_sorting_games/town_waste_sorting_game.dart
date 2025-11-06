import 'package:flutter/material.dart';
import 'base_waste_sorting_game.dart';

class TownWasteSortingGame extends BaseWasteSortingGame {
  const TownWasteSortingGame({super.key});

  @override
  State<TownWasteSortingGame> createState() => _TownWasteSortingGameState();
}

class _TownWasteSortingGameState
    extends BaseWasteSortingGameState<TownWasteSortingGame> {
  @override
  String get gameTitle => 'Town Explorer 🏙️';

  @override
  String get welcomeMessage =>
      'Meet Maya the Urban Explorer! She\'s passionate about keeping the town clean and sustainable. Help her sort the waste items she discovers around the busy streets!';

  @override
  Color get primaryColor => Colors.blue;

  @override
  Color get secondaryColor => Colors.lightBlue;

  @override
  List<Color> get backgroundGradient => [
    Colors.blue.withOpacity(0.3),
    Colors.lightBlue.withOpacity(0.2),
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
      'name': 'Restaurant Food Scraps',
      'image': 'assets/tidytown/images/game/apple_core.png',
      'correctBin': 'compost',
      'description':
          'I\'m leftover food from the busy town restaurant! Maya knows I can become rich soil for urban gardens!',
    },
    {
      'name': 'Market Vegetable Peels',
      'image': 'assets/tidytown/images/game/banana_peel.png',
      'correctBin': 'compost',
      'description':
          'I\'m vegetable peels from the farmers market! Maya can compost me to support urban agriculture!',
    },
    {
      'name': 'Coffee Shop Grounds',
      'image': 'assets/tidytown/images/game/coffee_grounds.png',
      'correctBin': 'compost',
      'description':
          'I\'m used coffee grounds from the town café! Maya can compost me to enrich urban garden soil!',
    },
    {
      'name': 'Park Fallen Leaves',
      'image': 'assets/tidytown/images/game/apple_core.png',
      'correctBin': 'compost',
      'description':
          'I\'m fallen leaves from the town park! Maya can compost me to create natural fertilizer for city plants!',
    },
    // RECYCLE ITEMS (4+) - Including your specified items
    {
      'name': 'Plastic Bottles',
      'image': 'assets/tidytown/images/game/plastic_bottle.png',
      'correctBin': 'recycle',
      'description':
          'I\'m plastic bottles Maya found around town! I can be recycled into new bottles for the community!',
    },
    {
      'name': 'Bus Stop Soda Can',
      'image': 'assets/tidytown/images/game/aluminum_can.png',
      'correctBin': 'recycle',
      'description':
          'I\'m an aluminum can Maya spotted at the bus stop! I can be recycled endlessly into new cans!',
    },
    {
      'name': 'Town Hall Documents',
      'image': 'assets/tidytown/images/game/newspaper.png',
      'correctBin': 'recycle',
      'description':
          'I\'m old office paper from the town hall! Maya collected me to become new paper for city planning!',
    },
    {
      'name': 'Glass Bottles',
      'image': 'assets/tidytown/images/game/aluminum_can.png',
      'correctBin': 'recycle',
      'description':
          'I\'m glass bottles from town restaurants! Maya can recycle me into new glass containers!',
    },
    // LANDFILL ITEMS (4+) - Including your specified items
    {
      'name': 'Chocolate Covers',
      'image': 'assets/tidytown/images/game/plastic_bag.png',
      'correctBin': 'landfill',
      'description':
          'I\'m chocolate wrappers Maya found on the street! I\'m made of mixed materials that can\'t be recycled!',
    },
    {
      'name': 'Broken Phone',
      'image': 'assets/tidytown/images/game/broken_glass.png',
      'correctBin': 'landfill',
      'description':
          'I\'m a broken phone from the electronics district! Maya knows I need special e-waste disposal!',
    },
    {
      'name': 'Disposable Coffee Cups',
      'image': 'assets/tidytown/images/game/coffee_grounds.png',
      'correctBin': 'landfill',
      'description':
          'I\'m disposable cups from the town café! Maya wishes I was compostable, but I have plastic lining!',
    },
    {
      'name': 'Cigarette Butts',
      'image': 'assets/tidytown/images/game/plastic_bag.png',
      'correctBin': 'landfill',
      'description':
          'I\'m cigarette butts Maya found on busy streets! I contain toxic chemicals that need proper disposal!',
    },
  ];
}
