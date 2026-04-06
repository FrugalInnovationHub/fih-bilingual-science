class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Safe Water Heroes',
      'getStarted': 'Get Started',
      'home': 'Home',
      'dashboardBtnLearning': 'Learning Hub',
      'dashboardBtnGames': 'Games Hub',
      'dashboardBtnProgress': 'My Progress',
      'settingsAudioHover': 'Hover to Speak (Web)',
      'settingsAudioMute': 'Mute Audio',
      'loading': 'Loading...',
      'interactiveOn': 'Interactive: ON',
      'goodJob': 'Good Job!',
      'tryAgain': 'Oops, try again!',
    },
    'es': {
      'appTitle': 'Héroes del Agua Segura',
      'getStarted': 'Comenzar',
      'home': 'Inicio',
      'dashboardBtnLearning': 'Centro de Aprendizaje',
      'dashboardBtnGames': 'Centro de Juegos',
      'dashboardBtnProgress': 'Mi Progreso',
      'settingsAudioHover': 'Pasar cursor para hablar (Web)',
      'settingsAudioMute': 'Silenciar Audio',
      'loading': 'Cargando...',
      'interactiveOn': 'Interactivo: ENCENDIDO',
      'goodJob': '¡Buen trabajo!',
      'tryAgain': '¡Ups, inténtalo de nuevo!',
    },
  };

  // English to Spanish translation map for audio
  static const Map<String, String> _audioTranslations = {
    // App titles and navigation
    'Safe Water Heroes': 'Héroes del Agua Segura',
    'Get Started': 'Comenzar',
    'Home': 'Inicio',
    'Learning Hub': 'Centro de Aprendizaje',
    'Games Hub': 'Centro de Juegos',
    'My Progress': 'Mi Progreso',
    'Welcome back, Hero!': '¡Bienvenido de nuevo, Héroe!',
    'Repeat': 'Repetir',
    
    // Progress screen
    'Coins': 'Monedas',
    'Game Badges': 'Insignias de Juegos',
    'Lessons Completed': 'Lecciones Completadas',
    'Total Score': 'Puntuación Total',
    
    // Games
    'Sorting Game': 'Juego de Clasificación',
    'Filter Game': 'Juego de Filtros',
    'Adventure Game': 'Juego de Aventura',
    'Start Game': 'Iniciar Juego',
    'Play Again': 'Jugar de Nuevo',
    'Next Level': 'Siguiente Nivel',
    'Good Job!': '¡Buen trabajo!',
    'Great work!': '¡Excelente trabajo!',
    'Well done!': '¡Bien hecho!',
    'Oops, try again!': '¡Ups, inténtalo de nuevo!',
    'Try again!': '¡Inténtalo de nuevo!',
    'Correct!': '¡Correcto!',
    'Wrong!': '¡Incorrecto!',
    
    // Learning
    'Lesson': 'Lección',
    'Continue': 'Continuar',
    'Back': 'Atrás',
    'Next': 'Siguiente',
    'Finish': 'Terminar',
    
    // Water related terms
    'Clean Water': 'Agua Limpia',
    'Dirty Water': 'Agua Sucia',
    'Safe Water': 'Agua Segura',
    'Filter': 'Filtro',
    'Germs': 'Gérmenes',
    'Bacteria': 'Bacterias',
    'Healthy': 'Saludable',
    
    // Common UI
    'Loading...': 'Cargando...',
    'Yes': 'Sí',
    'No': 'No',
    'OK': 'OK',
    'Cancel': 'Cancelar',
    'Save': 'Guardar',
    'Close': 'Cerrar',
  };

  static String get(String key, String langCode) {
    return _localizedValues[langCode]?[key] ?? _localizedValues['en']![key] ?? key;
  }

  /// Translates English text to Spanish for audio playback
  /// Returns original text if no translation found
  static String translateForAudio(String englishText, String targetLang) {
    if (targetLang != 'es') return englishText;
    
    // Direct match
    if (_audioTranslations.containsKey(englishText)) {
      return _audioTranslations[englishText]!;
    }
    
    // Case-insensitive match
    final lowerText = englishText.toLowerCase();
    for (var entry in _audioTranslations.entries) {
      if (entry.key.toLowerCase() == lowerText) {
        return entry.value;
      }
    }
    
    // Return original if no translation found
    return englishText;
  }
}