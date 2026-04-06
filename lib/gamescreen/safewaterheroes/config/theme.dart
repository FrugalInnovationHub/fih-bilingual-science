import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Stitch Color Palette cues
  static const Color primaryBlue = Color(0xFF4FC3F7);
  static const Color darkerBlue = Color(0xFF0288D1);
  static const Color accentOrange = Color(0xFFFFB74D);
  static const Color backgroundLight = Color(0xFFE1F5FE);
  static const Color textDark = Color(0xFF01579B);

  static const double cardBorderRadius = 24.0;

  static ThemeData get stitchTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        background: backgroundLight,
        primary: primaryBlue,
        secondary: accentOrange,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.fredokaTextTheme().apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      // Fix: Use CardThemeData here
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: darkerBlue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: textDark, fontSize: 24, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentOrange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  // Gradients extracted from Stitch style
  static const LinearGradient mainBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
  );
}