import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/backend/backend.dart';
import 'package:stream_transform/stream_transform.dart';
import 'firebase_auth_manager.dart';

export 'firebase_auth_manager.dart';

final _authManager = FirebaseAuthManager();
FirebaseAuthManager get authManager => _authManager;

String get currentUserEmail =>
    currentUserDocument?.email ?? currentUser?.email ?? '';

String get currentUserUid => currentUser?.uid ?? '';

String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? currentUser?.displayName ?? '';

String get currentUserPhoto {
  final photoUrl = currentUserDocument?.photoUrl ?? currentUser?.photoUrl ?? '';
  // Validate URL to prevent "file:///" errors
  if (photoUrl.isEmpty ||
      photoUrl == 'file:///' ||
      !Uri.parse(photoUrl).hasAuthority) {
    return '';
  }
  return photoUrl;
}

String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? currentUser?.phoneNumber ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

/// Get the current trainee record if the user is a trainee
TraineeRecord? currentTraineeDocument;
final authenticatedTraineeStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((user) => user?.uid ?? '')
    .switchMap(
      (uid) => uid.isEmpty || currentUserReference == null
          ? Stream.value(null)
          : queryTraineeRecord(
              queryBuilder: (query) =>
                  query.where('user', isEqualTo: currentUserReference),
              singleRecord: true,
            ).handleError((_) {}),
    )
    .map((trainee) {
  if (trainee != null && trainee.isNotEmpty) {
    currentTraineeDocument = trainee.first;
  }
  return currentTraineeDocument;
}).asBroadcastStream();

/// Get the current coach record if the user is a coach
CoachRecord? currentCoachDocument;
final authenticatedCoachStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((user) => user?.uid ?? '')
    .switchMap(
      (uid) => uid.isEmpty
          ? Stream.value(null)
          : queryCoachRecord(
              queryBuilder: (query) =>
                  query.where('user', isEqualTo: currentUserReference),
              singleRecord: true,
            ).handleError((_) {}),
    )
    .map((coach) {
  if (coach != null && coach.isNotEmpty) {
    currentCoachDocument = coach.first;
  }
  return currentCoachDocument;
}).asBroadcastStream();

/// Create a Stream that listens to the current user's JWT Token, since Firebase
/// generates a new token every hour.
String? _currentJwtToken;
final jwtTokenStream = FirebaseAuth.instance
    .idTokenChanges()
    .map((user) async => _currentJwtToken = await user?.getIdToken())
    .asBroadcastStream();

DocumentReference? get currentUserReference =>
    loggedIn ? UserRecord.collection.doc(currentUser!.uid) : null;

UserRecord? currentUserDocument;
final authenticatedUserStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((user) => user?.uid ?? '')
    .switchMap(
      (uid) => uid.isEmpty
          ? Stream.value(null)
          : UserRecord.getDocument(UserRecord.collection.doc(uid))
              .handleError((_) {}),
    )
    .map((user) {
  currentUserDocument = user;

  return currentUserDocument;
}).asBroadcastStream();

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (context, _) => builder(context),
      );
}

class CoachUserStreamWidget extends StatelessWidget {
  const CoachUserStreamWidget({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedCoachStream,
        builder: (context, _) => builder(context),
      );
}

class TraineeUserStreamWidget extends StatelessWidget {
  const TraineeUserStreamWidget({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedTraineeStream,
        builder: (context, _) => builder(context),
      );
}

void clearUserData() {
  currentUserDocument = null;
  _currentJwtToken = null;
  currentUser = null;
}
