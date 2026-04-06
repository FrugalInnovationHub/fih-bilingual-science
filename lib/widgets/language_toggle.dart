import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/language_provider.dart';

class LanguageToggle extends StatefulWidget {
  const LanguageToggle({super.key});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        // Update animation based on language
        final isSpanish = languageProvider.language == 'es';
        if (isSpanish && _animationController.value != 1.0) {
          _animationController.forward();
        } else if (!isSpanish && _animationController.value != 0.0) {
          _animationController.reverse();
        }

        return GestureDetector(
          onTap: () => languageProvider.toggleLanguage(),
          child: Container(
            width: 80,
            height: 32,
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  255, 255, 192, 18), // Same yellow as "Let's Play" button
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background labels - positioned absolutely
                Positioned(
                  left: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _buildLabel('EN', !isSpanish),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _buildLabel('ES', isSpanish),
                  ),
                ),
                // Sliding indicator
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Positioned(
                      left: 4 + (_slideAnimation.value * 40),
                      top: 4,
                      child: Container(
                        width: 32,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, bool isActive) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isActive ? Colors.black : Colors.black.withOpacity(0.7),
        fontFamily: 'Poppins',
      ),
    );
  }
}
