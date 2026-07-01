import 'package:flutter/material.dart';

class FilterTechniqueInfo {
  const FilterTechniqueInfo({
    required this.id,
    required this.displayName,
    required this.introVoiceLine,
    required this.infographicImagePath,
    required this.steps,
    required this.materials,
    required this.accentColor,
  });

  final String id;
  final String displayName;
  final String introVoiceLine;
  final String infographicImagePath;
  final List<FilterStep> steps;
  final List<String> materials;
  final Color accentColor;

  static const List<FilterTechniqueInfo> all = [
    FilterTechniqueInfo(
      id: 'mechanical',
      displayName: 'Regular Filter',
      introVoiceLine:
          'We use pebbles, sand, charcoal, and cloth to clean dirty water!',
      infographicImagePath:
          'assets/safewaterheroes/images/infographic_mechanical.jpg',
      accentColor: Color(0xFF0288D1),
      materials: ['Pebbles', 'Sand', 'Charcoal', 'Cloth'],
      steps: [
        FilterStep(
          stepNumber: 1,
          title: 'Add Pebbles',
          description: 'Big pebbles catch large pieces of dirt',
          icon: Icons.circle,
          color: Color(0xFF90A4AE),
        ),
        FilterStep(
          stepNumber: 2,
          title: 'Add Charcoal',
          description: 'Charcoal removes bad smells and tiny germs',
          icon: Icons.brightness_1,
          color: Color(0xFF546E7A),
        ),
        FilterStep(
          stepNumber: 3,
          title: 'Add Sand',
          description: 'Fine sand filters out small dirty particles',
          icon: Icons.grain,
          color: Color(0xFFFFD54F),
        ),
        FilterStep(
          stepNumber: 4,
          title: 'Add Cloth',
          description: 'Cloth at the bottom keeps everything in place',
          icon: Icons.layers,
          color: Color(0xFF81D4FA),
        ),
      ],
    ),
    FilterTechniqueInfo(
      id: 'osmosis',
      displayName: 'Osmosis Filter',
      introVoiceLine:
          'Osmosis uses tiny holes to block germs and let clean water through!',
      infographicImagePath:
          'assets/safewaterheroes/images/infographic_osmosis.jpg',
      accentColor: Color(0xFF7B1FA2),
      materials: [
        'Sediment filter',
        'Carbon filter',
        'RO membrane',
        'Storage tank',
      ],
      steps: [
        FilterStep(
          stepNumber: 1,
          title: 'Water Goes In',
          description: 'Dirty water enters the filter machine',
          icon: Icons.water_drop,
          color: Color(0xFF29B6F6),
        ),
        FilterStep(
          stepNumber: 2,
          title: 'Tiny Holes',
          description: 'A special sheet with tiny holes blocks the dirt',
          icon: Icons.filter_drama,
          color: Color(0xFFAB47BC),
        ),
        FilterStep(
          stepNumber: 3,
          title: 'Germs Blocked',
          description: 'Bad germs are too big to fit through the holes',
          icon: Icons.block,
          color: Color(0xFFEF5350),
        ),
        FilterStep(
          stepNumber: 4,
          title: 'Clean Water Out',
          description:
              'Only clean water makes it through to the other side',
          icon: Icons.check_circle,
          color: Color(0xFF66BB6A),
        ),
      ],
    ),
    FilterTechniqueInfo(
      id: 'distillation',
      displayName: 'Distillation Filter',
      introVoiceLine:
          'Distillation filter We heat water until it turns to steam, then cool it back into clean water!',
      infographicImagePath:
          'assets/safewaterheroes/images/infographic_distillation.jpg',
      accentColor: Color(0xFFE65100),
      materials: [
        'Heat source',
        'Boiling chamber',
        'Condenser',
        'Collection jar',
      ],
      steps: [
        FilterStep(
          stepNumber: 1,
          title: 'Heat the Water',
          description: 'Dirty water is heated until it boils',
          icon: Icons.local_fire_department,
          color: Color(0xFFFF7043),
        ),
        FilterStep(
          stepNumber: 2,
          title: 'Becomes Steam',
          description:
              'Water turns into steam and rises up, leaving dirt behind',
          icon: Icons.cloud,
          color: Color(0xFFB0BEC5),
        ),
        FilterStep(
          stepNumber: 3,
          title: 'Steam Cools',
          description:
              'The steam travels through a cool tube and becomes water again',
          icon: Icons.ac_unit,
          color: Color(0xFF4FC3F7),
        ),
        FilterStep(
          stepNumber: 4,
          title: 'Pure Water',
          description:
              'Clean pure water drips into a fresh container',
          icon: Icons.water_drop,
          color: Color(0xFF29B6F6),
        ),
      ],
    ),
    FilterTechniqueInfo(
      id: 'uv',
      displayName: 'UV Purification Filter',
      introVoiceLine:
          'UV light zaps and destroys invisible germs hiding in the water!',
      infographicImagePath:
          'assets/safewaterheroes/images/infographic_uv.jpg',
      accentColor: Color(0xFF4527A0),
      materials: [
        'Pre-filter',
        'UV lamp',
        'Quartz sleeve',
        'Clean outlet',
      ],
      steps: [
        FilterStep(
          stepNumber: 1,
          title: 'Water Goes In',
          description: 'Water with hidden germs enters the UV machine',
          icon: Icons.water_drop,
          color: Color(0xFF29B6F6),
        ),
        FilterStep(
          stepNumber: 2,
          title: 'UV Light On',
          description: 'A special purple UV light turns on inside',
          icon: Icons.lightbulb,
          color: Color(0xFFCE93D8),
        ),
        FilterStep(
          stepNumber: 3,
          title: 'Germs Destroyed',
          description: 'The UV light zaps and kills all the germs',
          icon: Icons.flash_on,
          color: Color(0xFFFFD54F),
        ),
        FilterStep(
          stepNumber: 4,
          title: 'Safe Water',
          description: 'The water is now safe and clean to drink',
          icon: Icons.check_circle,
          color: Color(0xFF66BB6A),
        ),
      ],
    ),
  ];

  static FilterTechniqueInfo? byId(String id) {
    for (final info in all) {
      if (info.id == id) return info;
    }
    return null;
  }
}

class FilterStep {
  const FilterStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final int stepNumber;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
