import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../utils/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;
  
  const SettingsScreen({super.key, this.onLanguageChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEffects = true;
  bool _music = true;
  String _difficulty = 'easy';

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
              Color(0xFF4A90E2),
              Color(0xFF357ABD),
              Color(0xFF2E5B8A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      localizations.settingsButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    _buildCompactLanguageToggle(localizations),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Settings Options
                Column(
                    children: [
                      _buildSettingCard(
                        icon: Icons.volume_up,
                        title: localizations.soundEffects,
                        child: Switch(
                          value: _soundEffects,
                          onChanged: (value) {
                            setState(() {
                              _soundEffects = value;
                            });
                          },
                          activeColor: const Color(0xFF4A90E2),
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(),
                      
                      const SizedBox(height: 20),
                      
                      _buildSettingCard(
                        icon: Icons.music_note,
                        title: localizations.music,
                        child: Switch(
                          value: _music,
                          onChanged: (value) {
                            setState(() {
                              _music = value;
                            });
                          },
                          activeColor: const Color(0xFF4A90E2),
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(),
                      
                      const SizedBox(height: 20),
                      
                      _buildSettingCard(
                        icon: Icons.speed,
                        title: localizations.difficulty,
                        child: DropdownButton<String>(
                          value: _difficulty,
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Color(0xFF2E5B8A)),
                          items: [
                            DropdownMenuItem(
                              value: 'easy',
                              child: Text(localizations.easy),
                            ),
                            DropdownMenuItem(
                              value: 'medium',
                              child: Text(localizations.medium),
                            ),
                            DropdownMenuItem(
                              value: 'hard',
                              child: Text(localizations.hard),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _difficulty = value!;
                            });
                          },
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideX(),
                      
                      const SizedBox(height: 40),
                      
                      // Language Settings
                      _buildLanguageSection(localizations)
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 600.ms)
                          .slideY(),
                    ],
                ),
                
                // Back Button
                _buildBackButton(localizations)
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 600.ms)
                    .slideY(begin: 0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildLanguageSection(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: Colors.white, size: 30),
              const SizedBox(width: 20),
              Text(
                localizations.languageButton,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildLanguageOption(
                  'en',
                  '🇺🇸',
                  localizations.english,
                  Localizations.localeOf(context).languageCode == 'en',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildLanguageOption(
                  'es',
                  '🇪🇸',
                  localizations.spanish,
                  Localizations.localeOf(context).languageCode == 'es',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String code, String flag, String name, bool isSelected) {
    return GestureDetector(
      onTap: () {
        final locale = Locale(code, '');
        widget.onLanguageChanged?.call(locale);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(flag, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 5),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2E5B8A) : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactLanguageToggle(AppLocalizations localizations) {
    final currentLanguage = Localizations.localeOf(context).languageCode;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCompactLanguageButton('en', '🇺🇸', currentLanguage),
          _buildCompactLanguageButton('es', '🇪🇸', currentLanguage),
        ],
      ),
    );
  }

  Widget _buildCompactLanguageButton(String languageCode, String flag, String currentLanguage) {
    final isSelected = currentLanguage == languageCode;
    
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          final locale = Locale(languageCode, '');
          widget.onLanguageChanged?.call(locale);
          setState(() {});
        }
      },
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
            color: isSelected ? const Color(0xFF4A90E2) : Colors.white,
          ),
        ),
      ),
    );
  }


  Widget _buildBackButton(AppLocalizations localizations) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: Text(
            'Back to Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
