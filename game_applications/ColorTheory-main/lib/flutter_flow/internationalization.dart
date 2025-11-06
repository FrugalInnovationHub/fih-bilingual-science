import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'es'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? esText = '',
  }) =>
      [enText, esText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    '1ntr7h2c': {
      'en': 'Restart Game',
      'es': 'Reiniciar juego',
    },
    '7hulvhkl': {
      'en': 'Main Menu',
      'es': 'Menú principal',
    },
    'bhm1blwh': {
      'en': 'SCORE',
      'es': '',
    },
    '6dnqp9fq': {
      'en': 'ENGLISH',
      'es': 'INGLÉS',
    },
    'mtpsq7iy': {
      'en': 'SPANISH',
      'es': 'ESPAÑOL',
    },
    '0fsb3od0': {
      'en': 'MAIN MENU',
      'es': 'MENÚ PRINCIPAL',
    },
    '7u3xay9i': {
      'en': 'On',
      'es': 'Encendido',
    },
    'yl3f8tio': {
      'en': 'Off',
      'es': 'Apagado',
    },
    'yojnlnie': {
      'en': 'MAIN MENU',
      'es': 'MENÚ PRINCIPAL',
    },
    'fx0yucmj': {
      'en': 'Rank',
      'es': '',
    },
    'mfq4dl6r': {
      'en': 'Score',
      'es': '',
    },
    '64joki1t': {
      'en': 'Date',
      'es': '',
    },
    '0qmfdaid': {
      'en': 'MAIN MENU',
      'es': 'MENÚ PRINCIPAL',
    },
    'zjy8k2fl': {
      'en': 'Start Game',
      'es': 'Iniciar juego',
    },
    '2c2jl43u': {
      'en': 'Highscore',
      'es': 'Récord',
    },
    'ncvlfxxc': {
      'en': 'Language',
      'es': 'Idioma',
    },
    '5ov1ctv1': {
      'en': 'Sound',
      'es': 'Sonido',
    },
    'pb720e6s': {
      'en': 'Home',
      'es': 'Hogar',
    },
  },
  // ReloadPage
  {
    '8t6fb1a1': {
      'en': 'Home',
      'es': '',
    },
  },
  // Miscellaneous
  {
    'uf4xd1dj': {
      'en': '',
      'es': '',
    },
    'vrifyz3k': {
      'en': '',
      'es': '',
    },
    'aw46j787': {
      'en': '',
      'es': '',
    },
    'q2an2t7d': {
      'en': '',
      'es': '',
    },
    'pj0osmw0': {
      'en': '',
      'es': '',
    },
    'eed28bru': {
      'en': '',
      'es': '',
    },
    '9q89r8am': {
      'en': '',
      'es': '',
    },
    '3mvqm1gn': {
      'en': '',
      'es': '',
    },
    'riydupja': {
      'en': '',
      'es': '',
    },
    'wccoozi2': {
      'en': '',
      'es': '',
    },
    'tz0ias21': {
      'en': '',
      'es': '',
    },
    'gr04gaow': {
      'en': '',
      'es': '',
    },
    'qh1maee6': {
      'en': '',
      'es': '',
    },
    'rb8wktbd': {
      'en': '',
      'es': '',
    },
    'i7c5ofaw': {
      'en': '',
      'es': '',
    },
    '1tee7usx': {
      'en': '',
      'es': '',
    },
    'n4c3iv8s': {
      'en': '',
      'es': '',
    },
    '07kq8tqc': {
      'en': '',
      'es': '',
    },
    'wjs1w45y': {
      'en': '',
      'es': '',
    },
    'lpn3thdd': {
      'en': '',
      'es': '',
    },
    'xxmp4m2k': {
      'en': '',
      'es': '',
    },
    'fmf13z4m': {
      'en': '',
      'es': '',
    },
    '3iswtuzg': {
      'en': '',
      'es': '',
    },
    '4f27urxr': {
      'en': '',
      'es': '',
    },
    '4w6r32xt': {
      'en': '',
      'es': '',
    },
  },
].reduce((a, b) => a..addAll(b));
