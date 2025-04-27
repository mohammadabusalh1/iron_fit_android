import 'package:firebase_storage/firebase_storage.dart';
import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/componants/loading_indicator/LoadingIndicator.dart';
import 'package:iron_fit/dialogs/edit_user_info_dialog/edit_user_info_dialog_widget.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/trainee/user_profile/user_profile_widget.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/settings_section.dart';
import 'components/logout_button.dart';
import 'components/delete_account_dialog.dart';
import 'components/password_reauth_dialog.dart';

export 'trainee_settings_model.dart';

class TraineeSettingsWidget extends StatefulWidget {
  const TraineeSettingsWidget({
    super.key,
    required this.traineeRef,
  });

  final DocumentReference traineeRef;

  @override
  State<TraineeSettingsWidget> createState() => _TraineeSettingsWidgetState();
}

class _TraineeSettingsWidgetState extends State<TraineeSettingsWidget>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Create constant widgets that don't need to be recreated on each build
  static const SizedBox _sizedBox16 = SizedBox(height: 16);
  static const SizedBox _sizedBox20 = SizedBox(height: 20);
  static const SizedBox _sizedBox24 = SizedBox(height: 24);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Loading indicator widget that doesn't change
  Widget _buildLoadingIndicator(BuildContext context) =>
      CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          FlutterFlowTheme.of(context).primary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    if (_isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLoadingIndicator(context),
              _sizedBox16,
              Text(
                FFLocalizations.of(context).getText('deleting_account'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 16,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (currentTraineeDocument == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('Login');
        }
      });
      return const LoadingIndicator();
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        extendBodyBehindAppBar: true,
        appBar: CoachAppBar.coachAppBar(
          context,
          FFLocalizations.of(context).getText('l71wmkbu'),
          IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 22,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.info_outline_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 22,
              )),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                FlutterFlowTheme.of(context).primaryBackground,
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Stack(
                children: [
                  // Decorative background elements
                  // Positioned(
                  //   top: -100,
                  //   right: -100,
                  //   child: Container(
                  //     width: 200,
                  //     height: 200,
                  //     decoration: BoxDecoration(
                  //       color: FlutterFlowTheme.of(context)
                  //           .primary
                  //           .withOpacity(0.05),
                  //       shape: BoxShape.circle,
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: -80,
                  //   left: -80,
                  //   child: Container(
                  //     width: 180,
                  //     height: 180,
                  //     decoration: BoxDecoration(
                  //       color: FlutterFlowTheme.of(context)
                  //           .tertiary
                  //           .withOpacity(0.05),
                  //       shape: BoxShape.circle,
                  //     ),
                  //   ),
                  // ),

                  // Main content
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sizedBox20,
                          SettingsSection(
                            trainee: currentTraineeDocument!,
                            onEditProfile: () =>
                                _editProfile(context, currentTraineeDocument!),
                            onDeleteAccount: () =>
                                _showDeleteAccountDialog(context),
                            currentUserEmail: currentUserEmail,
                          ),
                          _sizedBox24,
                          LogoutButton(
                            onLogout: () => _logout(context),
                          ),
                          _sizedBox24,
                          Center(
                            child: Text(
                              'v1.0.0',
                              style: AppStyles.textCairo(
                                context,
                                fontSize: 12,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                          _sizedBox20,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    // Show confirmation dialog first
    final shouldLogout = await _shouldLogout(context);

    if (shouldLogout) {
      try {
        // Create a key to manage the dialog properly
        GlobalKey<State> dialogKey = GlobalKey<State>();

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                key: dialogKey,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  width: 160,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            FlutterFlowTheme.of(context).black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: _buildLoadingIndicator(context),
                      ),
                      _sizedBox16,
                      Text(
                        FFLocalizations.of(context).getText('logging_out'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

        try {
          // Remove app preferences
          await FFAppState().prefs.remove('ff_userType');
          await FFAppState()
              .prefs
              .remove('notificationsInitialized_$currentUserEmail');
          FFAppState().isLogined = false;
        } catch (e) {
          Logger.error('Error clearing shared preferences during logout', e);
        }

        // Stop any streams
        // StreamManager.stopUserStream();

        // Prepare for auth event
        GoRouter.of(context).prepareAuthEvent();

        // Sign out from Firebase
        await authManager.signOut();
        clearUserData();

        UserCache.clearTraineeRecord();

        // Clear redirect location
        GoRouter.of(context).clearRedirectLocation();

        // Dismiss the dialog if possible
        if (context.mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        // Navigate to login screen
        if (context.mounted) {
          context.goNamed('Login');
        }
      } catch (e, stackTrace) {
        Logger.error('Error during logout process', e, stackTrace);
        // Show error message if logout fails
        // if (context.mounted) {
        //   showErrorDialog(
        //       FFLocalizations.of(context).getText('logout_error'), context);
        // }
      }
    }
  }

  Future<bool> _shouldLogout(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          FlutterFlowTheme.of(context).black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            FlutterFlowTheme.of(context).error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: FlutterFlowTheme.of(context).error,
                        size: 32,
                      ),
                    ),
                    _sizedBox16,
                    Text(
                      FFLocalizations.of(context).getText('logout_title'),
                      style: AppStyles.textCairo(
                        context,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      FFLocalizations.of(context).getText('logout_confirm'),
                      textAlign: TextAlign.center,
                      style: AppStyles.textCairo(
                        context,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    _sizedBox24,
                    Row(
                      children: [
                        Expanded(
                          child: FFButtonWidget(
                            onPressed: () => Navigator.of(context).pop(false),
                            text: FFLocalizations.of(context).getText('cancel'),
                            options: FFButtonOptions(
                              height: 48,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              textStyle: AppStyles.textCairo(
                                context,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 2,
                              ),
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
                              height: 48,
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
          },
        ) ??
        false;
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDialog(
          onDelete: () => _deleteAccount(),
        );
      },
    );
  }

  // This method only sets state once at the beginning and once at the end
  Future<void> _deleteAccount() async {
    if (currentTraineeDocument == null) return;
    try {
      // Close confirmation dialog
      Navigator.of(context).pop();

      setState(() {
        _isLoading = true;
      });

      final currentUser = FirebaseAuth.instance.currentUser;
      final userRef = currentUserReference;
      if (currentUser == null || userRef == null) {
        Logger.error('Cannot delete account: User not found or not logged in');
        showErrorDialog(
            FFLocalizations.of(context).getText('userNotFound'), context);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Show enhanced password dialog
      final password = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return const PasswordReauthDialog();
        },
      );

      if (password == null || password.isEmpty) {
        Logger.info('Account deletion cancelled: No password provided');
        setState(() {
          _isLoading = false;
        });
        showErrorDialog(
            FFLocalizations.of(context).getText('confirmPasswordIsRequired'),
            context);
        return; // User cancelled or provided empty password
      }

      try {
        Logger.info('Reauthenticating user for account deletion');
        // Reauthenticate user
        await currentUser.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: currentUserEmail,
            password: password,
          ),
        );

        // Fetch user and trainee data
        final userDoc = await UserRecord.getDocument(userRef).first;

        // Store email for later reference
        final userEmail = currentUserEmail;
        Logger.info('Starting deletion process for user: $userEmail');

        // Delete user photo if exists
        await _deleteUserPhoto(userDoc);

        await queryEventsRecord(
          queryBuilder: (q) =>
              q.where('trainee', isEqualTo: currentTraineeDocument!.reference),
        ).first.then((events) {
          return Future.wait(
            events.map((doc) => doc.reference.delete()),
          );
        });

        // Update subscriptions to anonymous
        await _updateSubscriptionsToAnonymous(
            currentTraineeDocument!.reference, userEmail);

        // Delete trainee record
        await currentTraineeDocument!.reference.delete();
        Logger.info('Trainee record deleted successfully');

        // Delete user record in Firestore
        await userRef.delete();
        Logger.info('User Firestore record deleted successfully');

        // Clear local storage and app preferences
        await _clearLocalStorage();

        // Delete Firebase Auth user
        await currentUser.delete();
        Logger.info('Firebase Auth user deleted successfully');

        // Only now set state back to not loading
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Navigate to login screen if context is still valid

          context.goNamed('Login');
        }
      } catch (e, stackTrace) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        String logMessage = 'Account deletion failed';

        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'requires-recent-login':
              logMessage = 'Account deletion failed: requires recent login';
              break;
            case 'wrong-password':
              logMessage = 'Account deletion failed: wrong password provided';
              break;
            default:
              logMessage = 'Account deletion failed with auth error: ${e.code}';
          }
        }

        Logger.error(logMessage, e, stackTrace);

        String errorMessage = FFLocalizations.of(context).getText('2184r6dy');

        if (context.mounted) {
          if (e is FirebaseAuthException) {
            switch (e.code) {
              case 'requires-recent-login':
                errorMessage = FFLocalizations.of(context)
                    .getText('requires-recent-login');
                break;
              case 'invalid-credential':
                errorMessage = FFLocalizations.of(context)
                    .getText('errorUpdatingPassword');
                break;
              default:
                errorMessage = FFLocalizations.of(context).getText('2184r6dy');
            }
          }
          showErrorDialog(errorMessage, context);
        }
      }
    } catch (e, stackTrace) {
      Logger.error(
          'Unexpected error during account deletion process', e, stackTrace);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
    }
  }

  // Delete user photo if exists
  Future<void> _deleteUserPhoto(UserRecord userDoc) async {
    if (userDoc.photoUrl.isNotEmpty) {
      try {
        final photoRef = FirebaseStorage.instance.refFromURL(userDoc.photoUrl);
        await photoRef.delete();
        Logger.info('User profile photo deleted successfully');
      } catch (e, stackTrace) {
        // Continue with account deletion even if photo deletion fails
        Logger.warning(
            'Failed to delete user profile photo: ${e.toString()} stackTrace: ${stackTrace.toString()}');
      }
    }
  }

  // Update subscriptions to anonymous
  Future<void> _updateSubscriptionsToAnonymous(
      DocumentReference traineeRef, String email) async {
    try {
      final subscriptions = await querySubscriptionsRecord(
        queryBuilder: (subscriptionsRecord) =>
            subscriptionsRecord.where('trainee', isEqualTo: traineeRef),
      ).first;

      if (subscriptions.isNotEmpty) {
        Logger.info(
            'Updating ${subscriptions.length} subscriptions to anonymous');
        final updateFutures = subscriptions.map((doc) => doc.reference
            .update({'isAnonymous': true, 'email': email, 'trainee': null}));

        await Future.wait(updateFutures);
        Logger.info('All subscriptions updated to anonymous successfully');
      }
    } catch (e, stackTrace) {
      Logger.error('Error updating subscriptions to anonymous', e, stackTrace);
      // Continue with account deletion even if updating subscriptions fails
    }
  }

  // Clear local storage and app preferences
  Future<void> _clearLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Clear app state
      await FFAppState().prefs.remove('ff_userType');
      await FFAppState()
          .prefs
          .remove('notificationsInitialized_$currentUserEmail');
      FFAppState().isLogined = false;
      Logger.info('Local storage and app preferences cleared successfully');
    } catch (e, stackTrace) {
      Logger.error('Error clearing local storage', e, stackTrace);
      // Continue even if clearing preferences fails
    }
  }

  void _editProfile(BuildContext context, TraineeRecord traineeRecord) async {
    try {
      await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: EditUserInfoDialogWidget(
                name: currentUserDisplayName,
                trainee: traineeRecord,
                onProfileUpdated: () {},
              ),
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Error showing edit profile dialog', e, stackTrace);
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
    }
  }
}
