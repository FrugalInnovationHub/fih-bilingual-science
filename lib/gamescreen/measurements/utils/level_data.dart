import 'package:flutter/material.dart';
import 'game_enums.dart';
import 'translation_service.dart';

class Level {
  final int id;
  final AgeGroup ageGroup;
  final Topic topic;
  final String worldTitleKey; // Added back
  final String titleKey; 
  final String instructionKey; 
  final String learnContentKey; 
  final String gameMode; 
  final List<String> allowedUnitSymbols;
  final String icon;
  final int difficulty;
  final List<MeasurementSystem> systems;

  Level({
    required this.id,
    required this.ageGroup,
    required this.topic,
    required this.worldTitleKey,
    required this.titleKey,
    required this.instructionKey,
    required this.learnContentKey,
    required this.gameMode,
    required this.allowedUnitSymbols,
    required this.icon,
    this.difficulty = 1,
    required this.systems,
  });
  
  String getTitle(String lang) => TranslationService.get(titleKey, lang);
  String getInstruction(String lang) => TranslationService.get(instructionKey, lang);
  String getLearnContent(String lang) => TranslationService.get(learnContentKey, lang);
  String getWorldTitle(String lang) => TranslationService.get(worldTitleKey, lang);
}

class LevelData {
  static void _registerTranslations() {
    // World Titles
    TranslationService.register('w_playground', {'en': 'Playground', 'es': 'Patio de Juego'});
    TranslationService.register('w_school', {'en': 'School', 'es': 'Escuela'});
    TranslationService.register('w_market', {'en': 'Market', 'es': 'Mercado'});
    TranslationService.register('w_lab', {'en': 'Science Lab', 'es': 'Laboratorio'});

    // Level Content
    TranslationService.register('l1_title', {'en': 'Big vs Small', 'es': 'Grande vs Pequeño'});
    TranslationService.register('l1_instr', {'en': 'Tap the BIG animal!', 'es': '¡Toca el animal GRANDE!'});
    TranslationService.register('l1_learn', {'en': 'Some things are BIG like an Elephant 🐘. Some things are SMALL like a Mouse 🐁.', 'es': 'Algunas cosas son GRANDES como un Elefante 🐘. Otras son PEQUEÑAS como un Ratón 🐁.'});

    TranslationService.register('l2_title', {'en': 'Weigh It!', 'es': '¡Pésalo!'});
    TranslationService.register('l2_instr', {'en': 'Count the blocks to weigh it!', 'es': '¡Cuenta los bloques para pesarlo!'});
    TranslationService.register('l2_learn', {'en': 'We measure weight with a scale. Heavier things need MORE blocks.', 'es': 'Medimos el peso con una balanza. Las cosas más pesadas necesitan MÁS bloques.'});

    TranslationService.register('l3_title', {'en': 'Full vs Empty', 'es': 'Lleno vs Vacío'});
    TranslationService.register('l3_instr', {'en': 'Which bucket is FULL?', 'es': '¿Qué cubeta está LLENA?'});
    TranslationService.register('l3_learn', {'en': 'This bucket has water 💧. It is FULL.', 'es': 'Esta cubeta tiene agua 💧. Está LLENA.'});
  
    TranslationService.register('l6_title', {'en': 'Ruler Master', 'es': 'Maestro de la Regla'});
    TranslationService.register('l6_instr', {'en': 'Measure the pencil in cm!', 'es': '¡Mide el lápiz en cm!'});
    TranslationService.register('l6_learn', {'en': 'We use Rulers 📏 to measure length.', 'es': 'Usamos Reglas 📏 para medir longitud.'});

    TranslationService.register('l7_title', {'en': 'Weighing Fruits', 'es': 'Pesando Frutas'});
    TranslationService.register('l7_instr', {'en': 'Find the 1kg weight!', 'es': '¡Encuentra la pesa de 1kg!'});
    TranslationService.register('l7_learn', {'en': 'Grams (g) are for light things. Kilograms (kg) are for heavy things.', 'es': 'Gramos (g) son para cosas ligeras. Kilogramos (kg) son para cosas pesadas.'});

    TranslationService.register('l14_title', {'en': 'Celsius vs Fahrenheit', 'es': 'Celsius vs Fahrenheit'});
    TranslationService.register('l14_instr', {'en': 'Convert C to F!', 'es': '¡Convierte C a F!'});
    TranslationService.register('l14_learn', {'en': 'Water freezes at 0°C or 32°F.', 'es': 'El agua se congela a 0°C o 32°F.'});
  }

  static bool _initialized = false;
  static void ensureInitialized() {
    if (!_initialized) {
      _registerTranslations();
      _initialized = true;
    }
  }

  static final List<Level> levels = [
    // 🧸 Ages 3–5
    Level(
      id: 1, ageGroup: AgeGroup.earlyLearners, topic: Topic.length, worldTitleKey: 'w_playground',
      titleKey: 'l1_title', instructionKey: 'l1_instr', learnContentKey: 'l1_learn',
      gameMode: 'matching', allowedUnitSymbols: ['m', 'cm'], icon: '🐘',
      systems: [MeasurementSystem.universal],
    ),
    Level(
      id: 2, ageGroup: AgeGroup.earlyLearners, topic: Topic.weight, worldTitleKey: 'w_playground',
      titleKey: 'l2_title', instructionKey: 'l2_instr', learnContentKey: 'l2_learn',
      gameMode: 'weighing', allowedUnitSymbols: [], icon: '⚖️',
      systems: [MeasurementSystem.universal],
    ),
    Level(
      id: 3, ageGroup: AgeGroup.earlyLearners, topic: Topic.volume, worldTitleKey: 'w_playground',
      titleKey: 'l3_title', instructionKey: 'l3_instr', learnContentKey: 'l3_learn',
      gameMode: 'matching', allowedUnitSymbols: ['l', 'ml'], icon: '🪣',
      systems: [MeasurementSystem.universal],
    ),

    // 🎒 Ages 6–8
    Level(
      id: 6, ageGroup: AgeGroup.foundationLearners, topic: Topic.length, worldTitleKey: 'w_school',
      titleKey: 'l6_title', instructionKey: 'l6_instr', learnContentKey: 'l6_learn',
      gameMode: 'lab', allowedUnitSymbols: ['cm', 'm'], icon: '📏',
      systems: [MeasurementSystem.metric], // Metric specific
    ),
    Level(
      id: 601, ageGroup: AgeGroup.foundationLearners, topic: Topic.length, worldTitleKey: 'w_school',
      titleKey: 'l6_title', instructionKey: 'l6_instr', learnContentKey: 'l6_learn',
      gameMode: 'lab', allowedUnitSymbols: ['in', 'ft'], icon: '📏',
      systems: [MeasurementSystem.imperial], // Imperial specific
    ),

    Level(
      id: 7, ageGroup: AgeGroup.foundationLearners, topic: Topic.weight, worldTitleKey: 'w_market',
      titleKey: 'l7_title', instructionKey: 'l7_instr', learnContentKey: 'l7_learn',
      gameMode: 'matching', allowedUnitSymbols: ['g', 'kg'], icon: '⚖️',
      systems: [MeasurementSystem.metric],
    ),
    Level(
      id: 701, ageGroup: AgeGroup.foundationLearners, topic: Topic.weight, worldTitleKey: 'w_market',
      titleKey: 'l7_title', instructionKey: 'l7_instr', learnContentKey: 'l7_learn',
      gameMode: 'matching', allowedUnitSymbols: ['lb', 'oz'], icon: '⚖️',
      systems: [MeasurementSystem.imperial],
    ),

    // 🧠 Ages 9–11
    Level(
      id: 14, ageGroup: AgeGroup.advancedLearners, topic: Topic.temperature, worldTitleKey: 'w_lab',
      titleKey: 'l14_title', instructionKey: 'l14_instr', learnContentKey: 'l14_learn',
      gameMode: 'matching', allowedUnitSymbols: ['°C'], icon: '🌡️',
      systems: [MeasurementSystem.metric],
    ),
    Level(
      id: 1401, ageGroup: AgeGroup.advancedLearners, topic: Topic.temperature, worldTitleKey: 'w_lab',
      titleKey: 'l14_title', instructionKey: 'l14_instr', learnContentKey: 'l14_learn',
      gameMode: 'matching', allowedUnitSymbols: ['°F'], icon: '🌡️',
      systems: [MeasurementSystem.imperial],
    ),
  ];

  static List<Level> getLevels({required AgeGroup age, required MeasurementSystem system}) {
    ensureInitialized();
    return levels.where((l) => 
      l.ageGroup == age && 
      (l.systems.contains(system) || l.systems.contains(MeasurementSystem.universal))
    ).toList();
  }

  static Level getLevel(int id) {
    ensureInitialized();
    return levels.firstWhere((level) => level.id == id, orElse: () => levels.first);
  }
}
