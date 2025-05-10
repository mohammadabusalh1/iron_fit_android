// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iron_fit/Ad/AdService.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/services/firebase_messages.dart';
import 'package:iron_fit/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';
import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart'; // Add this import for debug flags

// Global cache for text styles to avoid recreating them
final _textStyleCache = <String, TextStyle>{};

Future<void> initializeApp() async {
  // Initialize Firebase first, before any other Firebase services
  await initFirebase();
  
  // Then initialize other services
  final initFutures = <Future<dynamic>>[
    FlutterFlowTheme.initialize(),
    FFLocalizations.initialize(),
    dotenv.load(fileName: '.env'),
  ];

  // Only initialize mobile ads on mobile platforms
  if (!kIsWeb) {
    // Initialize MobileAds first before any ad service
    initFutures.add(MobileAds.instance.initialize());
    
    // Initialize AdService only after MobileAds is ready
    // We don't want to load ads yet, just initialize the service
    await Future.wait(initFutures);
    await AdService().initialize();
  } else {
    // For web, just wait for the other initialization futures
    await Future.wait(initFutures);
  }

  usePathUrlStrategy();

  // Initialize app state
  final appState = FFAppState();
  await appState.initializePersistedState();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optimize Flutter engine settings
  WidgetsBinding.instance.platformDispatcher.onBeginFrame = null;
  WidgetsBinding.instance.platformDispatcher.onDrawFrame = null;

  // Optimize image cache
  PaintingBinding.instance.imageCache.maximumSize = 1000;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;

  // Initialize app
  await initializeApp();

  // await authManager.signOut();
  // FFAppState().prefs.clear();

  // Initialize firebase notifications only after Firebase is fully initialized
  await FirebaseNotificationService.instance.initialize();
  
  // Initialize local notifications
  final notificationService = NotificationService();
  await notificationService.initializeNotification();

  // Run the app with error boundary
  runApp(ChangeNotifierProvider(
    create: (context) => FFAppState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  // App state management
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  // Stream subscriptions
  final authUserSub = authenticatedUserStream.listen((_) {});
  late Stream<BaseAuthUser> userStream;
  StreamSubscription? _userStreamSub;

  // Cached theme data for performance
  ThemeData? _lightTheme;
  ThemeData? _darkTheme;
  bool _themesInitialized = false;

  @override
  void initState() {
    super.initState();

    // Listen to user stream for updates with proper subscription management
    userStream = ironFitFirebaseUserStream();
    _userStreamSub = userStream.listen((user) {
      _appStateNotifier.update(user);
    });

    // Initialize app state and router
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    // Initialize stream manager
    // StreamManager().initialize(_appStateNotifier);

    // Listen to JWT token stream once
    jwtTokenStream.listen((_) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_themesInitialized) {
      _precacheThemes();
      _themesInitialized = true;
    }
  }

  // Pre-compute theme data to avoid rebuilds
  void _precacheThemes() {
    _lightTheme = ThemeData(
      brightness: Brightness.light,
      useMaterial3: false,
      textTheme: ThemeData.light().textTheme.copyWith(
            bodySmall: _getCachedTextStyle('bodySmall_light'),
            bodyMedium: _getCachedTextStyle('bodyMedium_light'),
            bodyLarge: _getCachedTextStyle('bodyLarge_light'),
            displayLarge: _getCachedTextStyle('displayLarge_light'),
            displayMedium: _getCachedTextStyle('displayMedium_light'),
            displaySmall: _getCachedTextStyle('displaySmall_light'),
            labelSmall: _getCachedTextStyle('labelSmall_light', fontSize: 12),
            headlineMedium:
                _getCachedTextStyle('headlineMedium_light', fontSize: 16),
          ),
    );

    _darkTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: false,
      textTheme: ThemeData.dark().textTheme.copyWith(
            bodySmall: _getCachedTextStyle('bodySmall_dark'),
            bodyMedium: _getCachedTextStyle('bodyMedium_dark'),
            bodyLarge: _getCachedTextStyle('bodyLarge_dark'),
            displayLarge: _getCachedTextStyle('displayLarge_dark'),
            displayMedium: _getCachedTextStyle('displayMedium_dark'),
            displaySmall: _getCachedTextStyle('displaySmall_dark'),
            labelSmall: _getCachedTextStyle('labelSmall_dark', fontSize: 12),
            headlineMedium:
                _getCachedTextStyle('headlineMedium_dark', fontSize: 16),
          ),
    );
  }

  // Get cached text style or create and cache a new one
  TextStyle _getCachedTextStyle(String key, {double? fontSize}) {
    if (!_textStyleCache.containsKey(key)) {
      _textStyleCache[key] = AppStyles.textCairo(
        context,
        fontSize: fontSize ?? 14.0,
      );
    }
    return _textStyleCache[key]!;
  }

  @override
  void dispose() {
    // Clean up all subscriptions
    authUserSub.cancel();
    _userStreamSub?.cancel();
    // StreamManager.stopUserStream();
    // StreamManager().dispose(); // Dispose the StreamManager instance

    super.dispose();
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    // Update cached text styles with current context if needed
    if (MediaQuery.of(context).textScaler != TextScaler.noScaling &&
        _themesInitialized) {
      _precacheThemes();
    }

    return MaterialApp.router(
      title: 'IronFit',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

// Extension to add debounce functionality to streams
extension StreamDebounceExtension<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    return transform(
      StreamTransformer<T, T>.fromHandlers(
        handleData: (data, sink) {
          Future.delayed(duration, () => sink.add(data));
        },
      ),
    );
  }
}
