import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:integration_test/integration_test.dart';
import 'package:iron_fit/app_state.dart';
import 'package:iron_fit/backend/firebase/firebase_config.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/main.dart';
import 'package:provider/provider.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is! Exception) {
        FlutterError.presentError(details);
      }
    };
  });

  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  usePathUrlStrategy();
  await initFirebase();
  await FlutterFlowTheme.initialize();
  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();
  await dotenv.load(fileName: '.env');

  group('trainee Test', () {
    testWidgets('Full Trainee Flow', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => appState,
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle(); // Wait until UI is fully loaded

      // Verify if the sign-up button exists before tapping
      final signUpButton = find.byKey(const ValueKey('signUpButton'));
      expect(signUpButton, findsOneWidget);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // ---------------- Sign-up flow---------------------
      final signUpEmail = find.byKey(const ValueKey('sign_up_email'));
      expect(signUpEmail, findsOneWidget);
      final signUpPassword = find.byKey(const ValueKey('sign_up_password'));
      expect(signUpPassword, findsOneWidget);
      final createAccountButton =
          find.byKey(const ValueKey('create_account_button'));
      expect(createAccountButton, findsOneWidget);

      // Enter credentials
      await tester.enterText(signUpEmail, 'a66@gmail.com');
      await tester.enterText(signUpPassword, '1234567');

      // Tap create account button
      await tester.tap(createAccountButton);
      await tester.pumpAndSettle();
      // ---------------- end sign-up flow ---------------------

      expect(
          find.byKey(const ValueKey('user_enter_info_page')), findsOneWidget);

      final goToLoginPage = find.byKey(const ValueKey('goToLoginPage'));
      expect(goToLoginPage, findsOneWidget);
      await tester.tap(goToLoginPage);
      await tester.pumpAndSettle();

      final emailInput = find.byKey(const ValueKey('login_email'));
      final passwordInput = find.byKey(const ValueKey('login_password'));
      final loginButton = find.byKey(const ValueKey('login_button'));

      // Ensure the fields exist before entering text
      expect(emailInput, findsOneWidget);
      expect(passwordInput, findsOneWidget);

      // Enter credentials
      await tester.enterText(emailInput, 'a1@gmail.com');
      await tester.enterText(passwordInput, '1234567');

      // Tap login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 4));

      // Verify the next screen is displayed
      expect(find.byKey(const ValueKey('coach_home_screen')), findsOneWidget);
    });
  });
}
