import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/logger.dart';

class AuthService {
  static Future<void> secureCheckLogin(BuildContext context) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && await _validateUserSession(currentUser)) {
        await _handleSecureNavigation(context, currentUser);
        FFAppState().isFirstTme = false;
      }
    } catch (e, stackTrace) {
      Logger.error('Failed to check login status', e, stackTrace);
    }
  }

  static Future<bool> _validateUserSession(User user) async {
    try {
      final token = await user.getIdToken();
      return token != null;
    } catch (e, stackTrace) {
      Logger.error('Failed to validate user session', e, stackTrace);
      return false;
    }
  }

  static Future<void> _handleSecureNavigation(
      BuildContext context, User currentUser) async {
    try {
      final user = await UserRecord.getDocument(
              UserRecord.collection.doc(currentUser.uid))
          .first;

      if (!context.mounted) return;

      if (user.role == 'coach') {
        context.pushNamed('CoachHome');
        Logger.info('Coach logged in: ${currentUser.uid}');
      } else if (user.role == 'trainee') {
        context.pushNamed('UserHome');
        Logger.info('Trainee logged in: ${currentUser.uid}');
      } else {
        final errorMessage = FFLocalizations.of(context)
            .getText('invalidUserRole' /* Invalid user role */);
        Logger.warning('Invalid user role: ${user.role}');
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      Logger.error('Navigation error after authentication', e, stackTrace);
    }
  }
}
