import 'game_enums.dart';

class MeasurementUnit {
  final String nameEn;
  final String nameEs;
  final String symbol;
  final double conversionToMeter;
  final String emoji;
  final String descriptionEn;
  final String descriptionEs;
  final MeasurementSystem system;

  MeasurementUnit({
    required this.nameEn,
    required this.nameEs,
    required this.symbol,
    required this.conversionToMeter,
    required this.emoji,
    required this.descriptionEn,
    required this.descriptionEs,
    required this.system,
  });
}

class MeasurementData {
  static final List<MeasurementUnit> units = [
    // --- Length ---
    MeasurementUnit(
      nameEn: 'Meter',
      nameEs: 'Metro',
      symbol: 'm',
      conversionToMeter: 1.0,
      emoji: '📏',
      descriptionEn: 'The basic unit of length',
      descriptionEs: 'La unidad básica de longitud',
      system: MeasurementSystem.metric,
    ),
    MeasurementUnit(
      nameEn: 'Centimeter',
      nameEs: 'Centímetro',
      symbol: 'cm',
      conversionToMeter: 0.01,
      emoji: '📐',
      descriptionEn: '100 centimeters = 1 meter',
      descriptionEs: '100 centímetros = 1 metro',
      system: MeasurementSystem.metric,
    ),
    MeasurementUnit(
      nameEn: 'Foot',
      nameEs: 'Pie',
      symbol: 'ft',
      conversionToMeter: 0.3048,
      emoji: '🦶',
      descriptionEn: 'About the length of a foot',
      descriptionEs: 'Aproximadamente la longitud de un pie',
      system: MeasurementSystem.imperial,
    ),
    MeasurementUnit(
      nameEn: 'Inch',
      nameEs: 'Pulgada',
      symbol: 'in',
      conversionToMeter: 0.0254,
      emoji: '📏',
      descriptionEn: '12 inches = 1 foot',
      descriptionEs: '12 pulgadas = 1 pie',
      system: MeasurementSystem.imperial,
    ),
    MeasurementUnit(
      nameEn: 'Kilometer',
      nameEs: 'Kilómetro',
      symbol: 'km',
      conversionToMeter: 1000.0,
      emoji: '🛣️',
      descriptionEn: '1000 meters = 1 kilometer',
      descriptionEs: '1000 metros = 1 kilómetro',
      system: MeasurementSystem.metric,
    ),
    MeasurementUnit(
      nameEn: 'Yard',
      nameEs: 'Yarda',
      symbol: 'yd',
      conversionToMeter: 0.9144,
      emoji: '🏈',
      descriptionEn: '3 feet = 1 yard',
      descriptionEs: '3 pies = 1 yarda',
      system: MeasurementSystem.imperial,
    ),

    // --- Weight ---
    MeasurementUnit(
      nameEn: 'Gram',
      nameEs: 'Gramo',
      symbol: 'g',
      conversionToMeter: 0.0, // Not length
      emoji: '🍬',
      descriptionEn: 'For light things',
      descriptionEs: 'Para cosas ligeras',
      system: MeasurementSystem.metric,
    ),
    MeasurementUnit(
      nameEn: 'Kilogram',
      nameEs: 'Kilogramo',
      symbol: 'kg',
      conversionToMeter: 0.0,
      emoji: '🍉',
      descriptionEn: '1 kg = 1000 g',
      descriptionEs: '1 kg = 1000 g',
      system: MeasurementSystem.metric,
    ),

    // --- Volume ---
    MeasurementUnit(
      nameEn: 'Liter',
      nameEs: 'Litro',
      symbol: 'l',
      conversionToMeter: 0.0,
      emoji: '🥛',
      descriptionEn: 'For liquids',
      descriptionEs: 'Para líquidos',
      system: MeasurementSystem.metric,
    ),
    MeasurementUnit(
      nameEn: 'Milliliter',
      nameEs: 'Mililitro',
      symbol: 'ml',
      conversionToMeter: 0.0,
      emoji: '💧',
      descriptionEn: 'Small drops',
      descriptionEs: 'Gotas pequeñas',
      system: MeasurementSystem.metric,
    ),

    // --- Temperature ---
    MeasurementUnit(
      nameEn: 'Celsius',
      nameEs: 'Celsius',
      symbol: '°C',
      conversionToMeter: 0.0,
      emoji: '🌡️',
      descriptionEn: 'Water freezes at 0°C',
      descriptionEs: 'El agua se congela a 0°C',
      system: MeasurementSystem.metric,
    ),
    MeasurementUnit(
      nameEn: 'Fahrenheit',
      nameEs: 'Fahrenheit',
      symbol: '°F',
      conversionToMeter: 0.0,
      emoji: '🌡️',
      descriptionEn: 'Water freezes at 32°F',
      descriptionEs: 'El agua se congela a 32°F',
      system: MeasurementSystem.imperial,
    ),

    // --- Speed ---
    MeasurementUnit(
      nameEn: 'Km per Hour',
      nameEs: 'Km por Hora',
      symbol: 'km/h',
      conversionToMeter: 0.0,
      emoji: '🏎️',
      descriptionEn: 'Speed of a car',
      descriptionEs: 'Velocidad de un carro',
      system: MeasurementSystem.metric,
    ),

    // --- Area ---
    MeasurementUnit(
      nameEn: 'Square Meter',
      nameEs: 'Metro Cuadrado',
      symbol: 'm²',
      conversionToMeter: 0.0,
      emoji: '⬛',
      descriptionEn: 'Area of a room',
      descriptionEs: 'Área de un cuarto',
      system: MeasurementSystem.metric,
    ),
  ];

  static List<MeasurementUnit> getMetricUnits() {
    return units.where((unit) => unit.system == MeasurementSystem.metric).toList();
  }

  static List<MeasurementUnit> getImperialUnits() {
    return units.where((unit) => unit.system == MeasurementSystem.imperial).toList();
  }

  static List<MeasurementUnit> getAllUnits() {
    return units;
  }

  static List<MeasurementUnit> getRandomUnits(int count) {
    final shuffled = List<MeasurementUnit>.from(units)..shuffle();
    return shuffled.take(count).toList();
  }

  static MeasurementUnit? getUnitBySymbol(String symbol) {
    try {
      return units.firstWhere((unit) => unit.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  static MeasurementUnit? getUnit(String symbol) {
    return getUnitBySymbol(symbol);
  }

  static double convert(double value, String fromSymbol, String toSymbol) {
    final fromUnit = getUnitBySymbol(fromSymbol);
    final toUnit = getUnitBySymbol(toSymbol);
    
    if (fromUnit == null || toUnit == null) return 0.0;
    
    // Convert to meters first, then to target unit
    final meters = value * fromUnit.conversionToMeter;
    return meters / toUnit.conversionToMeter;
  }
}
