class TranslationService {
  static final Map<String, Map<String, String>> _translations = {};

  static Future<void> initialize() async {
    // No-op for now; reserved for future loading.
  }

  static void register(String key, Map<String, String> values) {
    _translations[key] = values;
  }

  static String get(String key, String lang) {
    final entry = _translations[key];
    if (entry == null) return key;
    return entry[lang] ?? entry.values.first;
  }
}
