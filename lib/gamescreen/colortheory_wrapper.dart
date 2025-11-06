import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'colortheory/flutter_flow/flutter_flow_theme.dart';
import 'colortheory/flutter_flow/flutter_flow_util.dart';
import 'colortheory/flutter_flow/internationalization.dart';
import 'colortheory/app_state.dart';
import 'colortheory/flutter_flow/nav/nav.dart';
import 'colortheory/index.dart';

class ColorTheoryWrapper extends StatefulWidget {
  final String userPin;

  const ColorTheoryWrapper({super.key, required this.userPin});

  @override
  State<ColorTheoryWrapper> createState() => _ColorTheoryWrapperState();
}

class _ColorTheoryWrapperState extends State<ColorTheoryWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize asynchronously without blocking
    // Note: usePathUrlStrategy() should not be called here as it's already set by the main app

    // Initialize in background
    FlutterFlowTheme.initialize();
    final appState = FFAppState();
    appState.initializePersistedState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = FFAppState();

    return ChangeNotifierProvider(
      create: (context) => appState,
      child: _ColorTheoryApp(),
    );
  }
}

class _ColorTheoryApp extends StatefulWidget {
  @override
  State<_ColorTheoryApp> createState() => _ColorTheoryAppState();
}

class _ColorTheoryAppState extends State<_ColorTheoryApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    // Create a new navigator key for each instance to avoid conflicts
    _navigatorKey = GlobalKey<NavigatorState>();
    _appStateNotifier = AppStateNotifier.instance;
    _router = _createRouter(_appStateNotifier);
  }

  // Create router with instance-specific navigator key
  GoRouter _createRouter(AppStateNotifier appStateNotifier) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: false,
      refreshListenable: appStateNotifier,
      navigatorKey: _navigatorKey,
      errorBuilder: (context, state) => HomePageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => HomePageWidget(),
        ).toRoute(appStateNotifier),
        FFRoute(
          name: HomePageWidget.routeName,
          path: HomePageWidget.routePath,
          builder: (context, params) => HomePageWidget(),
        ).toRoute(appStateNotifier),
        FFRoute(
          name: ReloadPageWidget.routeName,
          path: ReloadPageWidget.routePath,
          builder: (context, params) => ReloadPageWidget(),
        ).toRoute(appStateNotifier),
      ],
    );
  }

  void setLocale(String language) {
    setState(() {
      _locale = createLocale(language);
    });
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
      FlutterFlowTheme.saveThemeMode(mode);
    });
  }

  @override
  void dispose() {
    // Dispose router to clean up resources when widget is disposed
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Color Theory',
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
