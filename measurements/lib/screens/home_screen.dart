import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_localizations.dart';
import '../utils/measurement_data.dart';
import '../utils/audio_guard.dart';
import '../utils/level_data.dart';
import '../utils/game_enums.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'pathway_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;
  
  const HomeScreen({super.key, this.onLanguageChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  MeasurementSystem _selectedSystem = MeasurementSystem.metric; // Default

  
  String get _currentLanguage => Localizations.localeOf(context).languageCode;

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    if (_soundEnabled) {
      try {
        if (!await AudioGuard.soundsValid()) return;
        await _audioPlayer.play(AssetSource('sounds/background_music.mp3'));
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      } catch (e) {
        // Handle audio error gracefully
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6B46C1),
              Color(0xFF8B5CF6),
              Color(0xFFA78BFA),
              Color(0xFFC4B5FD),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Bar: Language & System Toggles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       // System Toggle
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            _buildSystemButton(MeasurementSystem.metric, '📏 Metric'),
                            _buildSystemButton(MeasurementSystem.imperial, '🦶 Imperial'),
                          ],
                        ),
                      ),
                      
                      // Language Toggle
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLanguageButton('en', '🇺🇸', localizations),
                            _buildLanguageButton('es', '🇪🇸', localizations),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Game Title
                  Text(
                    localizations.gameTitle,
                    style: GoogleFonts.fredoka(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(3, 3),
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),
                  
                  const SizedBox(height: 20),
                  
                  // Subtitle
                  Text(
                    localizations.gameInstructions,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.comicNeue(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 800.ms),
                  
                  const SizedBox(height: 60),
                
                // Age Selection Section
                Text(
                  localizations.isEnglish ? 'Select Your Level' : 'Selecciona tu Nivel',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 20),

                // 🧸 Ages 3-5
                _buildModeCard(
                  context,
                  '🧸 Ages 3-5',
                  localizations.isEnglish
                    ? 'Early Learners: Big vs Small, Heavy vs Light'
                    : 'Aprendices Tempranos: Grande vs Pequeño',
                  const Color(0xFF4CAF50), // Green for gentle start
                  () => _navigateToPathway(context, AgeGroup.earlyLearners),
                ).animate().slideX(delay: 600.ms),

                const SizedBox(height: 15),

                // 🎒 Ages 6-8
                _buildModeCard(
                  context,
                  '🎒 Ages 6-8',
                  localizations.isEnglish
                    ? 'Foundation: cm, m, kg, liters, clocks'
                    : 'Fundamentos: cm, m, kg, litros, relojes',
                  const Color(0xFF2196F3), // Blue for school
                  () => _navigateToPathway(context, AgeGroup.foundationLearners),
                ).animate().slideX(delay: 700.ms),

                const SizedBox(height: 15),

                // 🧠 Ages 9-11
                _buildModeCard(
                  context,
                  '🧠 Ages 9-11',
                  localizations.isEnglish
                    ? 'Advanced: Area, Perimeter, Speed, Formulas'
                    : 'Avanzado: Área, Perímetro, Velocidad',
                  const Color(0xFF9C27B0), // Purple for mastery
                  () => _navigateToPathway(context, AgeGroup.advancedLearners),
                ).animate().slideX(delay: 800.ms),
                
                const SizedBox(height: 30),
                
                // Settings Button
                _buildGameButton(
                  context,
                  localizations.settingsButton,
                  Icons.settings,
                  () => _navigateToSettings(context),
                ).animate().scale(delay: 1000.ms, duration: 600.ms),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(String languageCode, String flag, AppLocalizations localizations) {
    final isSelected = _currentLanguage == languageCode;
    
    return GestureDetector(
      onTap: () => _changeLanguage(languageCode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          flag,
          style: TextStyle(
            fontSize: 20,
            color: isSelected ? Colors.blue : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSystemButton(MeasurementSystem system, String label) {
    final isSelected = _selectedSystem == system;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSystem = system;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF6B46C1) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(BuildContext context, String title, String description, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.comicNeue(
                color: Colors.white.withOpacity(0.9),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8B5CF6), Color(0xFF6B46C1)],
          ),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 15),
            Text(
              text,
              style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitsPreview(BuildContext context, AppLocalizations localizations) {
    final units = MeasurementData.getRandomUnits(4);
    
    return Column(
      children: [
        Text(
          localizations.isEnglish ? 'Learn these measurements!' : '¡Aprende estas medidas!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: units.map((unit) => _buildUnitCard(unit, localizations)).toList(),
        ),
      ],
    );
  }

  Widget _buildUnitCard(MeasurementUnit unit, AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(unit.emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 5),
          Text(
            localizations.isEnglish ? unit.nameEn : unit.nameEs,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _changeLanguage(String languageCode) {
    final locale = Locale(languageCode, '');
    widget.onLanguageChanged?.call(locale);
    // Force rebuild after language change
    setState(() {});
  }

  void _navigateToGame(BuildContext context, String mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          initialMode: mode,
          onLanguageChanged: widget.onLanguageChanged,
        ),
      ),
    );
  }

  void _navigateToPathway(BuildContext context, AgeGroup ageGroup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PathwayScreen(
          onLanguageChanged: widget.onLanguageChanged,
          ageGroup: ageGroup,
          system: _selectedSystem,
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(onLanguageChanged: widget.onLanguageChanged),
      ),
    );
  }
}
