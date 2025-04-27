import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBRiaHZteVhE_1145laCGoAGYyn7Iaomwk",
            authDomain: "iron-fit-e6mbki.firebaseapp.com",
            projectId: "iron-fit-e6mbki",
            storageBucket: "iron-fit-e6mbki.firebasestorage.app",
            messagingSenderId: "1002025941772",
            appId: "1:1002025941772:web:b45b9b7cf6414fd5072729"));
  } else {
    await Firebase.initializeApp();
  }

  // Initialize App Check with appropriate provider
  await FirebaseAppCheck.instance.activate(
    // Use debug provider for development, switch to production provider for release
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );
}
