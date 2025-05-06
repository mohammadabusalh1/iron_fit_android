import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/coach/coach_home/coach_home_widget.dart';
import 'package:iron_fit/coach/coach_profile/coach_profile_widget.dart';
import 'package:iron_fit/coach/trainees/trainees_widget.dart';
import 'package:iron_fit/coach/coach_exercises_plans/coach_exercises_plans_widget.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/utils/logger.dart';

void logout(BuildContext context) async {
  final shouldLogout = await _shouldLogout(context);

  if (shouldLogout) {
    _showLoadingDialog(context);
    try {
      try {
        FFAppState().prefs.clear();
      } catch (e) {
        Logger.warning('Error clearing shared preferences: $e');
      }

      // Clear user data before signing out
      clearUserData();

      // Clear cached coach data
      await CoachProfileCache.clear();
      await CoachHomeCache.clear();
      await CoachTraineesCache.clear();
      await CoachExercisesPlansCache.clear();

      await authManager.signOut();

      // Wait for auth state to fully update
      await FirebaseAuth.instance.authStateChanges().first;
      GoRouter.of(context).clearRedirectLocation();
      context.goNamed('Login');
    } catch (e) {
      Logger.error('Error logging out: $e');
      _dismissLoadingDialog(context);
      showErrorDialog(
          FFLocalizations.of(context).getText('logout_error'), context);
    }
  }
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primary,
        ),
      );
    },
  );
}

void _dismissLoadingDialog(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

Future<bool> _shouldLogout(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return _buildLogoutDialog(context);
        },
      ) ??
      false;
}

Widget _buildLogoutDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.logout_rounded,
            color: FlutterFlowTheme.of(context).error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            FFLocalizations.of(context).getText('logout_title'),
            style: AppStyles.textCairo(
              context,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            FFLocalizations.of(context).getText('logout_confirm'),
            textAlign: TextAlign.center,
            style: AppStyles.textCairo(
              context,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FFButtonWidget(
                  onPressed: () => Navigator.of(context).pop(false),
                  text: FFLocalizations.of(context).getText('cancel'),
                  options: FFButtonOptions(
                    height: 44,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    textStyle: AppStyles.textCairo(
                      context,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FFButtonWidget(
                  onPressed: () => Navigator.of(context).pop(true),
                  text: FFLocalizations.of(context).getText('logout'),
                  options: FFButtonOptions(
                    height: 44,
                    color: FlutterFlowTheme.of(context).error,
                    textStyle: AppStyles.textCairo(
                      context,
                      color: FlutterFlowTheme.of(context).info,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<void> deleteAccount(
    CoachRecord coachSnapshot, BuildContext context) async {
  try {
    // Show confirmation dialog and show loading indicator
    final success = await _showReAuthDialog(context);

    if (!success) return;

    _showLoadingDialog(context);

    final user = currentUserReference;
    if (user != null) {
      try {
        final userDoc =
            await UserRecord.getDocument(currentUserReference!).first;

        if (coachSnapshot != null) {
          final coachRef = coachSnapshot.reference;

          // Delete all related records in parallel
          await Future.wait([
            // Delete subscriptions
            querySubscriptionsRecord(
              queryBuilder: (q) => q.where('coach', isEqualTo: coachRef),
            ).first.then((subscriptions) {
              return Future.wait(
                subscriptions.map((doc) => doc.reference.delete()),
              );
            }),

            // Delete exercise plans
            queryPlansRecord(
              queryBuilder: (q) => q.where('plan.coach', isEqualTo: coachRef),
            ).first.then((plans) {
              return Future.wait(
                plans.map((doc) => doc.reference.delete()),
              );
            }),

            // Delete nutrition plans
            queryNutPlanRecord(
              queryBuilder: (q) => q.where('coachRef', isEqualTo: coachRef),
            ).first.then((plans) {
              return Future.wait(
                plans.map((doc) => doc.reference.delete()),
              );
            }),

            UserRecord.getDocument(currentUserReference!).first.then((user) {
              return user.reference.delete();
            }),

            queryAlertRecord(
              queryBuilder: (q) => q.where('coach', isEqualTo: coachRef),
            ).first.then((alerts) {
              return Future.wait(
                alerts.map((doc) => doc.reference.delete()),
              );
            }),

            // Delete gym if it exists
            if (coachSnapshot.hasGym()) coachSnapshot.gym!.delete(),

            // Delete coach record
            coachRef.delete(),
          ]);
        }

        try {
          if (userDoc != null &&
              userDoc.photoUrl != null &&
              userDoc.photoUrl.isNotEmpty) {
            await FirebaseStorage.instance
                .refFromURL(userDoc.photoUrl)
                .delete();
          }
        } catch (e) {
          Logger.warning('Error deleting user photo: $e');
        }

        // Delete Firebase user account
        try {
          await currentUser?.delete();
        } catch (e) {
          Logger.warning('Error deleting user: $e');
        }

        // Clear preferences and delete user account
        await FFAppState().clear();

        // Clear cached coach profile
        CoachProfileCache.clear();
        CoachHomeCache.clear();
        CoachTraineesCache.clear();
        CoachExercisesPlansCache.clear();
      } catch (e) {
        rethrow;
      }
    }

    // Navigate to login
    _dismissLoadingDialog(context);
    if (context.mounted) {
      context.goNamed('Login');
    }
  } catch (e) {
    Logger.error('Error deleting account: $e');

    // Close loading dialog if it's open
    _dismissLoadingDialog(context);

    showErrorDialog(
        e.toString().contains('requires-recent-login')
            ? FFLocalizations.of(context).getText('relogin_required')
            : FFLocalizations.of(context).getText('delete_account_error'),
        context);
  }
}

Future<bool> _showReAuthDialog(BuildContext context) async {
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return _buildReAuthDialog(context, passwordController, isLoading);
        },
      ) ??
      false;
}

Widget _buildReAuthDialog(BuildContext context,
    TextEditingController passwordController, bool isLoading) {
  return StatefulBuilder(builder: (context, setState) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.security_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              FFLocalizations.of(context).getText('reauth_required'),
              style: AppStyles.textCairo(
                context,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              FFLocalizations.of(context).getText('reauth_message'),
              textAlign: TextAlign.center,
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: FFLocalizations.of(context).getText('1z6uu7dq'),
                labelStyle: AppStyles.textCairo(
                  context,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary.withAlpha(30),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
              ),
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FFButtonWidget(
                    onPressed: isLoading
                        ? null
                        : () => Navigator.of(context).pop(false),
                    text: FFLocalizations.of(context).getText('cancel'),
                    options: FFButtonOptions(
                      height: 44,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      textStyle: AppStyles.textCairo(
                        context,
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FFButtonWidget(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (passwordController.text.isEmpty) {
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            try {
                              // Get credentials for re-authentication
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null && user.email != null) {
                                // Create credential
                                final credential = EmailAuthProvider.credential(
                                  email: user.email!,
                                  password: passwordController.text,
                                );

                                // Re-authenticate
                                await user
                                    .reauthenticateWithCredential(credential);

                                // Close dialog with success
                                if (context.mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              }
                            } catch (e) {
                              Logger.warning('Re-authentication failed: $e');
                              setState(() {
                                isLoading = false;
                              });

                              if (context.mounted) {
                                showErrorDialog(
                                    FFLocalizations.of(context)
                                        .getText('errorVerifyingPassword'),
                                    context);
                              }
                            }
                          },
                    text: isLoading
                        ? FFLocalizations.of(context).getText('verifying')
                        : FFLocalizations.of(context).getText('verify'),
                    options: FFButtonOptions(
                      height: 44,
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: AppStyles.textCairo(
                        context,
                        color: FlutterFlowTheme.of(context).info,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
}
