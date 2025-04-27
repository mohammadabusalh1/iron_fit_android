import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iron_fit/backend/backend.dart';

final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  await signOutWithGoogle().catchError((_) => null);

  final googleUser = await _googleSignIn.signIn();
  if (googleUser == null) {
    return null;
  }
  final auth = await (googleUser).authentication;
  final credential = GoogleAuthProvider.credential(
      idToken: auth.idToken, accessToken: auth.accessToken);

  final existingUser = await UserRecord.collection
      .where('email', isEqualTo: googleUser.email)
      .get()
      .then((u) => u);
  if (existingUser.docs.isNotEmpty) {
    return null;
  }

  return FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential?> googleSignInFuncLogin() async {
  if (kIsWeb) {
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  await signOutWithGoogle().catchError((_) => null);

  final googleUser = await _googleSignIn.signIn();
  if (googleUser == null) {
    return null;
  }
  final auth = await (googleUser).authentication;
  final credential = GoogleAuthProvider.credential(
      idToken: auth.idToken, accessToken: auth.accessToken);

  final existingUser = await UserRecord.collection
      .where('email', isEqualTo: googleUser.email)
      .get()
      .then((u) => u);
  if (existingUser.docs.isEmpty) {
    return null;
  }

  return FirebaseAuth.instance.signInWithCredential(credential);
}

Future signOutWithGoogle() => _googleSignIn.signOut();
