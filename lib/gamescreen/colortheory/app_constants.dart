import 'package:flutter/material.dart';

abstract class FFAppConstants {
  static const List<String> ColorOrder = [
    'Green',
    'Yellow',
    'Red',
    'Purple',
    'Orange',
    'Brown',
    'Blue',
    'Pink'
  ];
  static const List<String> ColorOrderEs = [
    'Verde',
    'Amarillo',
    'Rojo',
    'Morado',
    'Naranja',
    'Marrón',
    'Azul',
    'Rosa'
  ];
  static const Color DefaultButtonColor = Color(4288516853);
  static const List<Color> ColorCodeOrder = [
    Color(4285178909),
    Color(4293972301),
    Color(4289272348),
    Color(4285085568),
    Color(4292894208),
    Color(4286988825),
    Color(4278229225),
    Color(4294405309)
  ];
  static const int StartGameButtonPadding = 20;
  static const int RestartGameButtonPadding = 50;
  static const bool EnableDebug = false;
  static const String MainMenuBgAudioAssetPath =
      'assets/colortheory/audios/main-menu-bg-final.mp3';
  static const List<String> ColorAudioAssetPathEs = [
    'assets/colortheory/audios/Verde.mp3',
    'assets/colortheory/audios/Amarillo.mp3',
    'assets/colortheory/audios/Rojo.mp3',
    'assets/colortheory/audios/Morado.mp3',
    'assets/colortheory/audios/Naranja.mp3',
    'assets/colortheory/audios/Marron.mp3',
    'assets/colortheory/audios/Azul.mp3',
    'assets/colortheory/audios/Rosa.mp3'
  ];
  static const List<String> ColorAudioAssetPathEn = [
    'assets/colortheory/audios/Green.mp3',
    'assets/colortheory/audios/Yellow.mp3',
    'assets/colortheory/audios/Red.mp3',
    'assets/colortheory/audios/Purple.mp3',
    'assets/colortheory/audios/Orange.mp3',
    'assets/colortheory/audios/Brown.mp3',
    'assets/colortheory/audios/Blue.mp3',
    'assets/colortheory/audios/Pink.mp3'
  ];
  static const String GameOverAudioAssetPath =
      'assets/colortheory/audios/game-over-final.mp3';
  static const int CurrentScoreTopPadding = 20;
  static const int CurrentScoreLeftPadding = 30;
  static const int HighScoreStackTitlePaddingTop = 36;
}
