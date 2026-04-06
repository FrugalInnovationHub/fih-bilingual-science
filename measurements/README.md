# Measurement Adventure 🎮📏

A bilingual Flutter game designed to teach kids measurements in English and Spanish through interactive gameplay!

## Features

- 🌍 **Bilingual Support**: Switch between English and Spanish
- 📏 **Measurement Learning**: Learn meters, feet, inches, centimeters, kilometers, and yards
- 🎯 **Interactive Gameplay**: Three modes - Learn, Practice, and Quiz
- 🎵 **Text-to-Speech**: Tap on units to hear them spoken aloud
- 🎨 **Kid-Friendly UI**: Colorful, animated interface with gradient backgrounds
- 📊 **Progress Tracking**: Score and level system
- 🔊 **Audio Feedback**: Sound effects for correct/wrong answers

## Measurement Units Covered

- **Meter** / **Metro** (m)
- **Centimeter** / **Centímetro** (cm)
- **Foot** / **Pie** (ft)
- **Inch** / **Pulgada** (in)
- **Kilometer** / **Kilómetro** (km)
- **Yard** / **Yarda** (yd)

## Game Modes

1. **Learn Mode**: Explore measurement units with expandable cards, system overviews, comparison tools, and fun facts
2. **Practice Mode**: Convert between units with step-by-step explanations and visual comparisons
3. **Quiz Mode**: Test your knowledge with multiple-choice questions, hints, and detailed explanations

## How to Play

1. **Start the Game**: Select your language and choose a game mode
2. **Learn Mode**: Tap on unit cards to expand and learn details, use the comparison tool to see conversions
3. **Practice Mode**: Enter values and convert between units, view step-by-step solutions
4. **Quiz Mode**: Answer questions, use hints when stuck, and review explanations
5. **Text-to-Speech**: Tap on any unit name or value to hear it spoken aloud

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone or download this project
2. Navigate to the project directory:

   ```bash
   cd /path/to/measurement_game
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Adding Sound Effects (Optional)

To add sound effects, place audio files in the `assets/sounds/` directory:

- `background_music.mp3` - Background music
- `correct.mp3` - Correct answer sound
- `wrong.mp3` - Wrong answer sound

## Game Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart      # Main menu
│   ├── game_screen.dart      # Gameplay screen
│   └── settings_screen.dart  # Settings and preferences
└── utils/
    ├── measurement_data.dart # Measurement units and conversions
    └── app_localizations.dart # Bilingual text management
```

## Educational Goals

This game helps children:

- Learn measurement vocabulary in both languages
- Understand conversion relationships between units
- Practice mental math with measurements
- Build confidence in bilingual learning
- Develop problem-solving skills

## Customization

You can easily customize the game by:

- Adding new measurement units in `measurement_data.dart`
- Modifying difficulty levels in the game logic
- Adding new languages in `app_localizations.dart`
- Changing colors and themes in the UI

## Contributing

Feel free to contribute by:

- Adding new measurement units
- Improving the UI/UX
- Adding more languages
- Creating additional game modes
- Enhancing accessibility features

## License

This project is open source and available under the MIT License.

---

**Have fun learning measurements! 📏🎉**
