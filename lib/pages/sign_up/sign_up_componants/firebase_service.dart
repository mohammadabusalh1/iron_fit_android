import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/pages/user_type/user_type_page.dart';
import 'package:iron_fit/services/firebase_messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/logger.dart';
import 'email_verification_service.dart';

class FirebaseService {
  // Check if email is already in use
  static Future<bool> isEmailInUse(String email) async {
    try {
      final emails = await queryUserRecord(
        queryBuilder: (userRecord) =>
            userRecord.where('email', isEqualTo: email),
      ).first;

      return emails.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      Logger.warning('Firebase Auth check for email in use: ${e.message}');
      // If error code is email-already-in-use, return true
      return e.code == 'email-already-in-use';
    } catch (e, stackTrace) {
      Logger.error('Unexpected error checking if email is in use',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Waits for authentication to become available, and if the user is a coach
  /// or trainee, waits for the respective document to become available.
  ///
  /// If the timeout is reached, navigates to the sign up page.
  ///
  /// [context] is an optional parameter that is used to navigate to the sign up
  /// page if the timeout is reached. If not provided, the function will use
  /// [FFAppState] to update the state and navigate.
  static Future<void> _waitForAuth(BuildContext context) async {
    // Check every 100ms until authentication is available
    const timeout = Duration(seconds: 20); // Timeout after 30 seconds
    final startTime = DateTime.now();

    while (currentUserReference == null) {
      // Check if timeout has been reached
      if (DateTime.now().difference(startTime) > timeout) {
        Logger.warning('Authentication timeout reached, navigating to Sign up');
        if (context != null && context.mounted) {
          context.goNamed('signUp');
        } else {
          // Fallback if no context is available
          FFAppState().update(() {});
        }
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (FFAppState().userType == 'coach') {
      authenticatedCoachStream.listen((_) {});

      final coachStartTime = DateTime.now();
      while (currentCoachDocument == null) {
        // Check if timeout has been reached
        if (DateTime.now().difference(coachStartTime) > timeout) {
          Logger.warning(
              'Coach authentication timeout reached, navigating to Sign up');
          if (context != null && context.mounted) {
            context.goNamed('signUp');
          } else {
            // Fallback if no context is available
            FFAppState().update(() {});
          }
          return;
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } else if (FFAppState().userType == 'trainee') {
      authenticatedTraineeStream.listen((_) {});

      final traineeStartTime = DateTime.now();
      while (currentTraineeDocument == null) {
        // Check if timeout has been reached
        if (DateTime.now().difference(traineeStartTime) > timeout) {
          Logger.warning(
              'Trainee authentication timeout reached, navigating to Sign up');
          if (context != null && context.mounted) {
            context.goNamed('signUp');
          } else {
            // Fallback if no context is available
            FFAppState().update(() {});
          }
          return;
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  // Create user account with email and password
  static Future<void> createUserAccount({
    required BuildContext context,
    required String email,
    required String password,
    required String phoneNumber,
    required String userType,
    required Function(bool) onSuccess,
  }) async {
    try {
      if (!context.mounted) return;
      Logger.info(
          'Creating user account for email: $email, userType: $userType');

      // Get FCM token before creating account
      final fcmToken = await FirebaseNotificationService.instance.getFcmToken();

      // Create user account
      final user = await authManager.createAccountWithEmail(
        context,
        email,
        password,
      );

      if (user == null) {
        Logger.error('Failed to create user account: null user returned');
        if (context.mounted) {
          showErrorDialog(
              FFLocalizations.of(context).getText('2184r6dy'), context);
        }
        onSuccess(false);
        return;
      }

      FFAppState().isLogined = true;

      // Update user record with additional information
      await currentUserReference!.update(createUserRecordData(
        role: userType,
        displayName: '',
        photoUrl: '',
        createdTime: DateTime.now(),
        phoneNumber: phoneNumber,
        fcmToken: fcmToken,
      ));

      // Create coach or trainee record based on user type
      if (userType == 'coach') {
        Logger.info('Creating coach record for user: ${user.uid}');

        await CoachRecord.collection.doc().set(createCoachRecordData(
              user: currentUserReference,
              isSub: false,
              dateOfBirth: DateTime.now(),
              experience: 0,
              price: 0,
              specialization: '',
              aboutMe: '',
              totalPaid: 0,
              gymName: '',
            ));

        await _waitForAuth(context);

        try {
          // get coach plans from defultPlans collection
          final coachPlans = await FirebaseFirestore.instance
              .collection('defultPlans')
              .where('lang',
                  isEqualTo: FFLocalizations.of(context).languageCode == 'ar'
                      ? 'ar'
                      : 'en')
              .get();

          if (coachPlans.docs.isNotEmpty) {
            Logger.info('Coach plans found for Google sign-in');
          }

          for (var plan in coachPlans.docs) {
            final planRecord = PlansRecord.fromSnapshot(plan);

            await PlansRecord.collection.doc().set(createPlansRecordData(
                  plan: updatePlanStruct(
                    PlanStruct(
                      name: planRecord.plan.name,
                      level: planRecord.plan.level,
                      description: planRecord.plan.description,
                      days: planRecord.plan.days,
                      totalSource: planRecord.plan.totalSource,
                      type: planRecord.plan.type,
                      coach: currentCoachDocument!.reference,
                      createdAt: getCurrentTimestamp,
                      draft: false,
                    ),
                    clearUnsetFields: false,
                    create: true,
                  ),
                ));
          }
        } catch (e, stackTrace) {
          Logger.error('Error getting coach plans',
              error: e, stackTrace: stackTrace);
        }
        if (context.mounted) {
          context.pushNamed('CoachEnterInfo', queryParameters: {
            'isEditing': serializeParam(false, ParamType.bool),
          });
        }
      } else {
        Logger.info('Creating trainee record for user: ${user.uid}');
        await TraineeRecord.collection.doc().set(createTraineeRecordData(
              user: currentUserReference,
              dateOfBirth: DateTime.now(),
              height: 0,
              weight: 0,
              gender: '',
              goal: '',
              progress: 0,
            ));

        // Handle anonymous subscriptions
        final subscriptions = await querySubscriptionsRecord(
          queryBuilder: (subscriptionRecord) => subscriptionRecord
              .where('isAnonymous', isEqualTo: true)
              .where('email', isEqualTo: email),
          singleRecord: true,
        ).first;

        final trainee = await queryTraineeRecord(
          queryBuilder: (traineeRecord) => traineeRecord.where(
            'user',
            isEqualTo: currentUserReference,
          ),
          singleRecord: true,
        ).first.then((s) => s.firstOrNull);

        if (trainee != null) {
          Logger.info('Updating anonymous subscriptions for email: $email');
          for (var subscription in subscriptions) {
            await subscription.reference.update({
              'trainee': trainee.reference,
              'isAnonymous': false,
              'email': FieldValue.delete(),
            });
          }
        }

        final prefs = await SharedPreferences.getInstance();
        final today = DateTime.now().toIso8601String();
        await prefs.setString('weight_reminder_last_shown', today);

        if (context.mounted) {
          context.goNamed('userEnterInfo');
        }
      }

      Logger.info('User account created successfully: ${user.uid}');
      onSuccess(true);
    } on FirebaseAuthException catch (e, stackTrace) {
      Logger.error('Firebase Auth error creating user account',
          error: e, stackTrace: stackTrace);
      String errorMessage = 'An error occurred during registration';

      // Provide more specific error messages based on Firebase error codes
      if (e.code == 'email-already-in-use') {
        errorMessage =
            FFLocalizations.of(context).getText('emailIsAlreadyInUse');
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid';
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
      onSuccess(false);
    } catch (e, stackTrace) {
      Logger.error('Unexpected error creating user account',
          error: e, stackTrace: stackTrace);
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
      onSuccess(false);
    }
  }

  // Sign in with Google
  static Future<void> signInWithGoogle({
    required BuildContext context,
    required Function(bool) onSuccess,
  }) async {
    try {
      Logger.info('Initiating Google sign-in');

      await authManager.signOut();

      // Get FCM token before sign in
      final fcmToken = await FirebaseNotificationService.instance.getFcmToken();

      GoRouter.of(context).prepareAuthEvent();
      BaseAuthUser? user = await authManager.signInWithGoogle(context);

      if (user == null) {
        Logger.error('Google sign-in failed: null user returned');
        if (context.mounted) {
          showErrorDialog(
              FFLocalizations.of(context).getText('emailIsAlreadyInUse'),
              context);
        }
        onSuccess(false);
        return;
      }
      Logger.info('User signed in with Google: ${user.uid}');
      // Navigate to UserType and wait for result
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UserTypePage()));

      // If user cancelled or didn't select a type, return early
      if (result == null) {
        Logger.info('User cancelled type selection during Google sign-in');
        onSuccess(false);
        return;
      }

      Logger.info('User selected type: $result');

      if (user.email != null && user.email!.isNotEmpty) {
        Logger.info('Sending welcome email to: ${user.email}');
        await EmailVerificationService.sendWelcomeEmail(
          recipientEmail: user.email!,
          userName: user.email!.split('@')[0], // Using email username as name
        );
      }

      FFAppState().isLogined = true;

      if (valueOrDefault(FFAppState().userType, '') == 'coach') {
        Logger.info('Creating coach record for Google user: ${user.uid}');
        await CoachRecord.collection.doc().set(createCoachRecordData(
              user: currentUserReference,
              isSub: false,
              dateOfBirth: DateTime.now(),
              experience: 0,
              price: 0,
              specialization: '',
              aboutMe: '',
              totalPaid: 0,
              gymName: '',
            ));
        await _waitForAuth(context);

        try {
          // get coach plans from defultPlans collection
          final coachPlans = await FirebaseFirestore.instance
              .collection('defultPlans')
              .where('lang',
                  isEqualTo: FFLocalizations.of(context).languageCode == 'ar'
                      ? 'ar'
                      : 'en')
              .get();

          if (coachPlans.docs.isNotEmpty) {
            Logger.info('Coach plans found for Google sign-in');
          }

          for (var plan in coachPlans.docs) {
            final planRecord = PlansRecord.fromSnapshot(plan);

            await PlansRecord.collection.doc().set(createPlansRecordData(
                  plan: updatePlanStruct(
                    PlanStruct(
                      name: planRecord.plan.name,
                      level: planRecord.plan.level,
                      description: planRecord.plan.description,
                      days: planRecord.plan.days,
                      totalSource: planRecord.plan.totalSource,
                      type: planRecord.plan.type,
                      coach: currentCoachDocument!.reference,
                      createdAt: getCurrentTimestamp,
                      draft: false,
                    ),
                    clearUnsetFields: false,
                    create: true,
                  ),
                ));
          }
        } catch (e, stackTrace) {
          Logger.error('Error getting coach plans',
              error: e, stackTrace: stackTrace);
        }
        if (context.mounted) {
          context.pushNamed('CoachEnterInfo', queryParameters: {
            'isEditing': serializeParam(false, ParamType.bool),
          });
        }
      } else if (valueOrDefault(FFAppState().userType, '') == 'trainee') {
        Logger.info('Creating trainee record for Google user: ${user.uid}');
        await TraineeRecord.collection.doc().set(createTraineeRecordData(
              user: currentUserReference,
              dateOfBirth: DateTime.now(),
              height: 0,
              weight: 0,
              gender: '',
              goal: '',
              progress: 0,
            ));

        // Handle anonymous subscriptions
        final subscriptions = await querySubscriptionsRecord(
          queryBuilder: (subscriptionRecord) => subscriptionRecord
              .where('isAnonymous', isEqualTo: true)
              .where('email', isEqualTo: user.email),
          singleRecord: true,
        ).first;

        final trainee = await queryTraineeRecord(
          queryBuilder: (traineeRecord) => traineeRecord.where(
            'user',
            isEqualTo: currentUserReference,
          ),
          singleRecord: true,
        ).first.then((s) => s.firstOrNull);

        if (trainee != null) {
          Logger.info(
              'Updating anonymous subscriptions for Google sign-in user: ${user.email}');
          for (var subscription in subscriptions) {
            await subscription.reference.update({
              'trainee': trainee.reference,
              'isAnonymous': false,
              'email': FieldValue.delete(),
            });
          }
        }

        await _waitForAuth(context);
        if (context.mounted) {
          context.goNamed('userEnterInfo');
        }
      }

      // Update user record with FCM token
      await currentUserReference?.update({
        'fcmToken': fcmToken,
        'role': FFAppState().userType,
      });

      Logger.info(
          'Google sign-in completed successfully for user: ${user.uid}');
      onSuccess(true);
    } on FirebaseAuthException catch (e, stackTrace) {
      Logger.error('Firebase Auth error during Google sign-in',
          error: e, stackTrace: stackTrace);
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('emailIsAlreadyInUse'),
            context);
      }
      onSuccess(false);
    } catch (e, stackTrace) {
      Logger.error('Unexpected error during Google sign-in',
          error: e, stackTrace: stackTrace);
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
      onSuccess(false);
    }
  }

  // Sign in with Apple
  static Future<void> signInWithApple({
    required BuildContext context,
    required Function(bool) onSuccess,
  }) async {
    try {
      if (!context.mounted) return;
      Logger.info('Initiating Apple sign-in');

      await authManager.signOut();

      // Get FCM token before sign in
      final fcmToken = await FirebaseNotificationService.instance.getFcmToken();

      GoRouter.of(context).prepareAuthEvent();
      BaseAuthUser? user = await authManager.signInWithApple(context);

      if (user == null) {
        Logger.error('Apple sign-in failed: null user returned');
        if (context.mounted) {
          showErrorDialog(
              FFLocalizations.of(context).getText('emailIsAlreadyInUse'),
              context);
        }
        onSuccess(false);
        return;
      }

      // Navigate to UserType and wait for result
      final result = await GoRouter.of(context).pushNamed('UserType');

      // If user cancelled or didn't select a type, return early
      if (result == null) {
        Logger.info('User cancelled type selection during Apple sign-in');
        onSuccess(false);
        return;
      }

      if (user.email != null && user.email!.isNotEmpty) {
        Logger.info('Sending welcome email to: ${user.email}');
        await EmailVerificationService.sendWelcomeEmail(
          recipientEmail: user.email!,
          userName: user.email!.split('@')[0], // Using email username as name
        );
      }

      FFAppState().isLogined = true;

      if (valueOrDefault(FFAppState().userType, '') == 'coach') {
        Logger.info('Creating coach record for Apple user: ${user.uid}');
        await CoachRecord.collection.doc().set(createCoachRecordData(
              user: currentUserReference,
              isSub: false,
              dateOfBirth: DateTime.now(),
              experience: 0,
              price: 0,
              specialization: '',
              aboutMe: '',
              totalPaid: 0,
              gymName: '',
            ));
        await _waitForAuth(context);

        try {
          // get coach plans from defultPlans collection
          final coachPlans = await FirebaseFirestore.instance
              .collection('defultPlans')
              .where('lang',
                  isEqualTo: FFLocalizations.of(context).languageCode == 'ar'
                      ? 'ar'
                      : 'en')
              .get();

          if (coachPlans.docs.isNotEmpty) {
            Logger.info('Coach plans found for Google sign-in');
          }

          for (var plan in coachPlans.docs) {
            final planRecord = PlansRecord.fromSnapshot(plan);

            await PlansRecord.collection.doc().set(createPlansRecordData(
                  plan: updatePlanStruct(
                    PlanStruct(
                      name: planRecord.plan.name,
                      level: planRecord.plan.level,
                      description: planRecord.plan.description,
                      days: planRecord.plan.days,
                      totalSource: planRecord.plan.totalSource,
                      type: planRecord.plan.type,
                      coach: currentCoachDocument!.reference,
                      createdAt: getCurrentTimestamp,
                      draft: false,
                    ),
                    clearUnsetFields: false,
                    create: true,
                  ),
                ));
          }
        } catch (e, stackTrace) {
          Logger.error('Error getting coach plans',
              error: e, stackTrace: stackTrace);
        }

        if (context.mounted) {
          context.pushNamed('CoachEnterInfo', queryParameters: {
            'isEditing': serializeParam(false, ParamType.bool),
          });
        }
      } else if (valueOrDefault(FFAppState().userType, '') == 'trainee') {
        Logger.info('Creating trainee record for Apple user: ${user.uid}');
        await TraineeRecord.collection.doc().set(createTraineeRecordData(
              user: currentUserReference,
              dateOfBirth: DateTime.now(),
              height: 0,
              weight: 0,
              gender: '',
              goal: '',
              progress: 0,
            ));

        // Handle anonymous subscriptions
        final subscriptions = await querySubscriptionsRecord(
          queryBuilder: (subscriptionRecord) => subscriptionRecord
              .where('isAnonymous', isEqualTo: true)
              .where('email', isEqualTo: user.email),
          singleRecord: true,
        ).first;

        final trainee = await queryTraineeRecord(
          queryBuilder: (traineeRecord) => traineeRecord.where(
            'user',
            isEqualTo: currentUserReference,
          ),
          singleRecord: true,
        ).first.then((s) => s.firstOrNull);

        if (trainee != null) {
          Logger.info(
              'Updating anonymous subscriptions for Apple sign-in user: ${user.email}');
          for (var subscription in subscriptions) {
            await subscription.reference.update({
              'trainee': trainee.reference,
              'isAnonymous': false,
              'email': FieldValue.delete(),
            });
          }
        }

        if (context.mounted) {
          context.goNamed('userEnterInfo');
        }
      }

      // Update user record with FCM token
      await currentUserReference?.update({
        'fcmToken': fcmToken,
        'role': FFAppState().userType,
      });

      Logger.info('Apple sign-in completed successfully for user: ${user.uid}');
      onSuccess(true);
    } on FirebaseAuthException catch (e, stackTrace) {
      if (!context.mounted) return;
      Logger.error('Firebase Auth error during Apple sign-in',
          error: e, stackTrace: stackTrace);
      String errorMessage = FFLocalizations.of(context).getText('2184r6dy');

      // Customize error message based on error code
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage =
            'An account already exists with the same email address but different sign-in credentials';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      if (context.mounted) {
        showErrorDialog(errorMessage, context);
      }
      onSuccess(false);
    } catch (e, stackTrace) {
      Logger.error('Unexpected error during Apple sign-in',
          error: e, stackTrace: stackTrace);
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
      onSuccess(false);
    }
  }
}
