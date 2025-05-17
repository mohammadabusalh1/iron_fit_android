// ignore_for_file: constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/pages/pre_login/components/auth_service.dart';
import 'package:iron_fit/services/firebase_messages.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'login_model.dart';
import 'package:iron_fit/componants/captcha_widget.dart';
import 'dart:async';

// Import component widgets
import 'componants/welcome_section.dart';
import 'componants/email_field.dart';
import 'componants/password_field.dart';
import 'componants/sign_in_button.dart';
import 'componants/forgot_password_button.dart';
import 'componants/or_divider.dart';
import 'componants/social_login_buttons.dart';
import 'componants/create_account_button.dart';

export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _lastLoginAttempt;
  static const int MAX_LOGIN_ATTEMPTS = 15;
  static const int LOCKOUT_DURATION_MINUTES = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Call secure check login after build
    WidgetsBinding.instance
        .addPostFrameCallback((_) => AuthService.secureCheckLogin(context));
    _initializeState();
  }

  Future<void> _initializeState() async {
    try {
      _model = createModel(context, () => LoginModel());
      _model.emailTextController = TextEditingController();
      _model.textFieldFocusNode1 = FocusNode();
      _model.passwordTextController = TextEditingController();
      _model.textFieldFocusNode2 = FocusNode();
    } catch (e) {
      Logger.error('Failed to initialize login state',
          error: e, stackTrace: StackTrace.current);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('failedToInitializeLoginState'),
            context);
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Stack(
          children: [
            // Gradient overlay background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    FlutterFlowTheme.of(context).primary.withOpacity(0.05),
                    FlutterFlowTheme.of(context).secondaryBackground,
                    FlutterFlowTheme.of(context).secondaryBackground,
                  ],
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: ResponsiveUtils.padding(
                      context,
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Welcome section
                        FadeInDown(
                          duration: const Duration(milliseconds: 600),
                          child: const WelcomeSection(),
                        ),

                        SizedBox(height: ResponsiveUtils.height(context, 36.0)),

                        FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          child: LoginFormSection(
                            model: _model,
                            emailController: _model.emailTextController!,
                            passwordController: _model.passwordTextController!,
                            onCaptchaVerified: (isVerified) {
                              // Update only the captcha state without rebuilding the entire widget
                              _model.isCaptchaVerified = isVerified;
                            },
                            onSignInPressed: _handleSignIn,
                            onForgotPasswordPressed: _handleForgotPassword,
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveUtils.height(
                                context, screenHeight * 0.03)),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: const OrDivider(),
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 8.0)),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: SocialLoginButtons(
                            onGooglePressed: _handleGoogleSignIn,
                            onApplePressed: _handleAppleSignIn,
                            isLoading: _isLoading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top +
                  ResponsiveUtils.height(context, 12.0),
              right: ResponsiveUtils.width(context, 24.0),
              child: FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: CreateAccountButton(
                  onPressed: () => context.pushNamed('SignUp'),
                ),
              ),
            ),

            // Full screen loading overlay
            if (_isLoading)
              Container(
                color: FlutterFlowTheme.of(context).black.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Container(
                    padding: ResponsiveUtils.padding(context, all: 16.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                        Text(
                          FFLocalizations.of(context).getText('pleaseWait'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: ResponsiveUtils.fontSize(context, 16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    // if (!_model.isCaptchaVerified) {
    //   Logger.warning('Login attempt without captcha verification');
    //   if (mounted) {
    //     showErrorDialog(
    //         FFLocalizations.of(context).getText('pleaseVerifyYouAreHuman'),
    //         context);
    //   }
    //   return;
    // }

    if (!_validateLoginAttempts()) {
      Logger.warning('Too many login attempts detected');
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('tooManyLoginAttempts'),
            context);
      }
      return;
    }

    if (!_validateInputs()) {
      Logger.warning('Invalid input validation during login');
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context)
                .getText('pleaseCheckYourInputAndTryAgain'),
            context);
      }
      return;
    }

    try {
      if (!mounted) return;
      GoRouter.of(context).prepareAuthEvent();
      final user = await _secureSignIn();

      if (user == null) {
        _incrementLoginAttempts();
        Logger.warning(
            'Invalid credentials for email: ${_model.emailTextController?.text}');
        if (mounted) {
          showErrorDialog(
              FFLocalizations.of(context).getText('invalidCredentials'),
              context);
        }
        return;
      }

      final userRecordList = await queryUserRecord(
          singleRecord: true,
          queryBuilder: (userRecord) => userRecord.where(
                'uid',
                isEqualTo: valueOrDefault(user.uid, ''),
              )).first;
      final userDocument = userRecordList.first;

      final fcmToken = await FirebaseNotificationService.instance.getFcmToken();
      if (fcmToken != null) {
        await userDocument.reference.update({'fcmToken': fcmToken});
      }

      FFAppState().isLogined = true;

      final role = valueOrDefault(currentUserDocument?.role, '');
      Logger.info('User ${user.uid} signed in successfully with role: $role');

      if (!mounted) return;

      if (role == 'coach') {
        FFAppState().userType = 'coach';
        await _handleCoachSignIn();
      } else {
        FFAppState().userType = 'trainee';
        await _handleTraineeSignIn();
      }

      // Reset attempts on successful login
      FFAppState().prefs.setInt('loginAttempts', 0);
      _lastLoginAttempt = null;
    } catch (e) {
      _incrementLoginAttempts();
      Logger.error('Authentication failed',
          error: e, stackTrace: StackTrace.current);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('authenticationFailed'),
            context);
      }
    }
  }

  bool _validateLoginAttempts() {
    int loginAttempts = FFAppState().prefs.getInt('loginAttempts') ?? 0;
    if (loginAttempts >= MAX_LOGIN_ATTEMPTS) {
      if (_lastLoginAttempt != null) {
        final lockoutEnd = _lastLoginAttempt!
            .add(const Duration(minutes: LOCKOUT_DURATION_MINUTES));
        if (DateTime.now().isBefore(lockoutEnd)) {
          return false;
        }
        // Reset after lockout period
        loginAttempts = 0;
      }
    }
    return true;
  }

  void _incrementLoginAttempts() {
    // Don't use setState here since we're just updating app state
    int loginAttempts = FFAppState().prefs.getInt('loginAttempts') ?? 0;
    FFAppState().prefs.setInt('loginAttempts', loginAttempts + 1);
    _lastLoginAttempt = DateTime.now();
  }

  bool _validateInputs() {
    final email = _model.emailTextController!.text.trim();
    final password = _model.passwordTextController!.text;

    if (email.isEmpty) {
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('emailIsRequired'), context);
      }
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('pleaseEnterAValidEmail'),
            context);
      }
      return false;
    }

    if (password.isEmpty) {
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('passwordIsRequired'), context);
      }
      return false;
    }

    return true;
  }

  Future<BaseAuthUser?> _secureSignIn() async {
    try {
      final user = await authManager.signInWithEmail(
        context,
        _model.emailTextController!.text.trim(),
        _model.passwordTextController!.text,
      );
      return user;
    } on FirebaseAuthException catch (e) {
      if (!mounted) return null;

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = FFLocalizations.of(context).getText(
              'noUserFoundWithThisEmail' /* No user found with this email. */);
          break;
        case 'wrong-password':
          errorMessage = FFLocalizations.of(context)
              .getText('invalidPassword' /* Invalid password. */);
          break;
        case 'user-disabled':
          errorMessage = FFLocalizations.of(context).getText(
              'thisAccountHasBeenDisabled' /* This account has been disabled. */);
          break;
        default:
          errorMessage = FFLocalizations.of(context).getText(
              'authenticationFailed' /* Authentication failed. Please try again. */);
      }
      Logger.error('Firebase authentication error',
          error: e, stackTrace: StackTrace.current);
      throw Exception(errorMessage);
    }
  }

  Future<void> waitForAuth() async {
    // Define a maximum wait time (in seconds)
    const maxWaitTimeInSeconds = 10;
    final stopwatch = Stopwatch()..start();

    // Check every 100ms until authentication is available or timeout
    while (currentUserReference == null) {
      if (stopwatch.elapsed.inSeconds > maxWaitTimeInSeconds) {
        Logger.warning('Authentication timed out, refreshing page');
        if (mounted) {
          // Reset the application state
          setState(() {
            _isLoading = false;
          });
          // Show timeout dialog with improved UI
          await _showTimeoutDialog(
            'authenticationTimeout',
            'authenticationTakingTooLong',
            Icons.timer_off_outlined,
          );
          return;
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (FFAppState().userType == 'coach') {
      authenticatedCoachStream.listen((coachDoc) {
        if (coachDoc == null) {
          Logger.warning('Coach document not found or stream returned null');
        } else {
          Logger.info('Coach document loaded successfully: ${coachDoc.reference.id}');
        }
      }, onError: (error) {
        Logger.error('Error in authenticatedCoachStream', error: error);
      });

      stopwatch.reset();
      while (currentCoachDocument == null) {
        if (stopwatch.elapsed.inSeconds > maxWaitTimeInSeconds) {
          Logger.warning('Coach document loading timed out, refreshing page');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            // Show timeout dialog with improved UI
            await _showTimeoutDialog(
              'dataLoadingTimeout',
              'dataLoadingTakingTooLong',
              Icons.cloud_off_outlined,
            );
            return;
          }
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } else if (FFAppState().userType == 'trainee') {
      authenticatedTraineeStream.listen((traineeDoc) {
        if (traineeDoc == null) {
          Logger.warning('Trainee document not found or stream returned null');
        } else {
          Logger.info('Trainee document loaded successfully: ${traineeDoc.reference.id}');
        }
      }, onError: (error) {
        Logger.error('Error in authenticatedTraineeStream', error: error);
      });

      stopwatch.reset();
      while (currentTraineeDocument == null) {
        if (stopwatch.elapsed.inSeconds > maxWaitTimeInSeconds) {
          Logger.warning('Trainee document loading timed out, refreshing page');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            // Show timeout dialog with improved UI
            await _showTimeoutDialog(
              'dataLoadingTimeout', 
              'dataLoadingTakingTooLong',
              Icons.cloud_off_outlined,
            );
            return;
          }
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  /// Shows a styled timeout dialog with appropriate icon and messaging
  Future<void> _showTimeoutDialog(
    String titleKey, 
    String contentKey,
    IconData icon,
  ) async {
    if (!mounted) return;
    
    final title = FFLocalizations.of(context).getText(titleKey);
    final content = FFLocalizations.of(context).getText(contentKey);
    final okText = FFLocalizations.of(context).getText('ok');
    final retryText = FFLocalizations.of(context).getText('retry');
    
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                ResponsiveUtils.width(context, 16.0)),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: ResponsiveUtils.padding(context,
                horizontal: 20.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(
                  ResponsiveUtils.width(context, 16.0)),
              boxShadow: [
                BoxShadow(
                  color: FlutterFlowTheme.of(context).black.withOpacity(0.3),
                  blurRadius: ResponsiveUtils.width(context, 10.0),
                  offset: Offset(0.0, ResponsiveUtils.height(context, 5.0)),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: ResponsiveUtils.padding(context,
                      horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .error
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: FlutterFlowTheme.of(context).error,
                    size: ResponsiveUtils.iconSize(context, 40.0),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 20.0)),
                Text(
                  title,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 10.0)),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 24.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          // Refresh the login page
                          context.goNamed('Login');
                        },
                        text: okText,
                        options: FFButtonOptions(
                          height: ResponsiveUtils.height(context, 45.0),
                          padding: ResponsiveUtils.padding(
                            context,
                            horizontal: 0.0,
                            vertical: 0.0,
                          ),
                          iconPadding: ResponsiveUtils.padding(
                            context,
                            horizontal: 0.0,
                            vertical: 0.0,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: AppStyles.textCairo(
                            context,
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveUtils.fontSize(context, 16),
                            color: FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          elevation: 2.0,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                              ResponsiveUtils.width(context, 8.0)),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 12.0)),
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          // Try again with current user credentials
                          setState(() {
                            _isLoading = true;
                          });
                          if (FFAppState().userType == 'coach') {
                            _handleCoachSignIn();
                          } else {
                            _handleTraineeSignIn();
                          }
                        },
                        text: retryText,
                        options: FFButtonOptions(
                          height: ResponsiveUtils.height(context, 45.0),
                          padding: ResponsiveUtils.padding(
                            context,
                            horizontal: 0.0,
                            vertical: 0.0,
                          ),
                          iconPadding: ResponsiveUtils.padding(
                            context,
                            horizontal: 0.0,
                            vertical: 0.0,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle: AppStyles.textCairo(
                            context,
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveUtils.fontSize(context, 16),
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                              ResponsiveUtils.width(context, 8.0)),
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
    );
  }

  Future<void> _handleCoachSignIn() async {
    try {
      if (!mounted) return;
      
      // Ensure the coach document is loaded correctly
      try {
        // Try to fetch the coach document directly
        final coachQuery = await queryCoachRecord(
          queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
          singleRecord: true,
        ).first;
        
        if (coachQuery.isNotEmpty) {
          // Manually set the current coach document
          currentCoachDocument = coachQuery.first;
          Logger.info('Coach document loaded manually: ${currentCoachDocument?.reference.id}');
        } else {
          Logger.warning('No coach document found for current user');
        }
      } catch (e) {
        Logger.error('Error loading coach document', error: e);
      }
      
      await waitForAuth();
      
      // If coach document is still null after waitForAuth, try one more time
      if (currentCoachDocument == null) {
        Logger.warning('Coach document still null after waitForAuth, trying again');
        try {
          await Future.delayed(const Duration(seconds: 1));
          final coachQuery = await queryCoachRecord(
            queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
            singleRecord: true,
          ).first;
          
          if (coachQuery.isNotEmpty) {
            currentCoachDocument = coachQuery.first;
            Logger.info('Coach document loaded on retry: ${currentCoachDocument?.reference.id}');
          }
        } catch (e) {
          Logger.error('Error on retry loading coach document', error: e);
        }
      }
      
      context.goNamed('CoachHome');
    } catch (e) {
      Logger.error('Error signing in as coach', error: e);
    }
  }

  Future<void> _handleTraineeSignIn() async {
    try {
      if (!mounted) return;
      
      // Ensure the trainee document is loaded correctly
      try {
        // Try to fetch the trainee document directly
        final traineeQuery = await queryTraineeRecord(
          queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
          singleRecord: true,
        ).first;
        
        if (traineeQuery.isNotEmpty) {
          // Manually set the current trainee document
          currentTraineeDocument = traineeQuery.first;
          Logger.info('Trainee document loaded manually: ${currentTraineeDocument?.reference.id}');
        } else {
          Logger.warning('No trainee document found for current user');
        }
      } catch (e) {
        Logger.error('Error loading trainee document', error: e);
      }
      
      await waitForAuth();
      
      // If trainee document is still null after waitForAuth, try one more time
      if (currentTraineeDocument == null) {
        Logger.warning('Trainee document still null after waitForAuth, trying again');
        try {
          await Future.delayed(const Duration(seconds: 1));
          final traineeQuery = await queryTraineeRecord(
            queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
            singleRecord: true,
          ).first;
          
          if (traineeQuery.isNotEmpty) {
            currentTraineeDocument = traineeQuery.first;
            Logger.info('Trainee document loaded on retry: ${currentTraineeDocument?.reference.id}');
          }
        } catch (e) {
          Logger.error('Error on retry loading trainee document', error: e);
        }
      }
      
      // Update FCM token
      try {
        final fcmToken = await FirebaseNotificationService.instance.getFcmToken();
        if (fcmToken != null && currentUserDocument != null) {
          await currentUserDocument!.reference.update({'fcmToken': fcmToken});
        }
      } catch (e) {
        Logger.error('Error updating FCM token', error: e);
      }
      
      context.goNamed('UserHome');
    } catch (e) {
      Logger.error('Error signing in as trainee', error: e);
      if (mounted) {
        _showErrorDialog(context, 'Error signing in as trainee', e.toString());
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext),
              child: Text(FFLocalizations.of(context).getText('ok' /* Ok */)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleForgotPassword() async {
    if (_model.emailTextController!.text.isEmpty) {
      Logger.warning('Forgot password attempt with empty email');
      showSuccessDialog(
          FFLocalizations.of(context).getText('emailRequired'), context);
      return;
    }

    // Store localized text before async
    final resetPasswordText =
        FFLocalizations.of(context).getText('reset_password');
    final thankYouText =
        FFLocalizations.of(context).getText('thankYou' /* Thank you */);
    final emailSentText = FFLocalizations.of(context).getText(
        'weSendEmailForYouItHasBeenSentSuccessfully' /* We send Email for you, It has been sent successfully! */);
    final okText = FFLocalizations.of(context).getText('ok' /* Ok */);

    try {
      Logger.info(
          'Sending password reset email to: ${_model.emailTextController!.text}');
      await authManager.resetPassword(
        email: _model.emailTextController!.text,
        context: context,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: ResponsiveUtils.padding(context,
                  horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
                borderRadius:
                    BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
                boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context).black,
                    blurRadius: ResponsiveUtils.width(context, 10.0),
                    offset: Offset(0.0, ResponsiveUtils.height(context, 10.0)),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: ResponsiveUtils.padding(context,
                        horizontal: 16.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.email_outlined,
                      color: FlutterFlowTheme.of(context).primary,
                      size: ResponsiveUtils.iconSize(context, 40.0),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 20.0)),
                  Text(
                    thankYouText,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 10.0)),
                  Text(
                    emailSentText,
                    textAlign: TextAlign.center,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 10.0)),
                  Text(
                    resetPasswordText,
                    textAlign: TextAlign.center,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 12),
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 24.0)),
                  SizedBox(
                    width: double.infinity,
                    child: FFButtonWidget(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      text: okText,
                      options: FFButtonOptions(
                        height: ResponsiveUtils.height(context, 45.0),
                        padding: ResponsiveUtils.padding(
                          context,
                          horizontal: 0.0,
                          vertical: 0.0,
                        ),
                        iconPadding: ResponsiveUtils.padding(
                          context,
                          horizontal: 0.0,
                          vertical: 0.0,
                        ),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: AppStyles.textCairo(
                          context,
                          fontWeight: FontWeight.w700,
                          fontSize: ResponsiveUtils.fontSize(context, 16),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        elevation: 2.0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(
                            ResponsiveUtils.width(context, 8.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      Logger.error('Failed to send password reset email',
          error: e, stackTrace: StackTrace.current);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('failedToSendResetEmail'),
            context);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    try {
      setState(() => _isLoading = true);

      if (!mounted) return;
      // Prepare the auth event
      GoRouter.of(context).prepareAuthEvent();

      if (!_validateLoginAttempts()) {
        Logger.warning('Too many login attempts for Google sign-in');
        if (mounted) {
          showErrorDialog(
              FFLocalizations.of(context).getText('tooManyLoginAttempts'),
              context);
        }
        return;
      }

      Logger.info('Attempting Google sign-in');
      // Attempt to sign in with Google
      final user = await authManager.signInWithGoogle(context, isLogin: true);

      if (!mounted) return;

      // Check if the user is null
      if (user == null) {
        Logger.warning('Google sign-in failed - user not found');
        showErrorDialog(
            FFLocalizations.of(context)
                .getText('makeSureYouHaveCreatedAnAccountWithThisEmail'),
            context);
        return;
      }

      Logger.info('Google sign-in successful for user: ${user.uid}');
      // Determine the role of the user
      final role = valueOrDefault(currentUserDocument?.role, '');

      // Store the result of context.mounted to avoid repeated checks

      FFAppState().isLogined = true;

      // Navigate based on the user's role
      if (role == 'coach') {
        Logger.info('Navigating to Coach Home');
        FFAppState().userType = 'coach';
        
        // Ensure the coach document is loaded correctly
        try {
          // Try to fetch the coach document directly
          final coachQuery = await queryCoachRecord(
            queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
            singleRecord: true,
          ).first;
          
          if (coachQuery.isNotEmpty) {
            // Manually set the current coach document
            currentCoachDocument = coachQuery.first;
            Logger.info('Coach document loaded manually: ${currentCoachDocument?.reference.id}');
          } else {
            Logger.warning('No coach document found for user: ${user.uid}');
          }
        } catch (e) {
          Logger.error('Error loading coach document', error: e);
        }
        
        await waitForAuth();
        
        // If coach document is still null after waitForAuth, try one more time
        if (currentCoachDocument == null) {
          Logger.warning('Coach document still null after waitForAuth, trying again');
          try {
            await Future.delayed(const Duration(seconds: 1));
            final coachQuery = await queryCoachRecord(
              queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
              singleRecord: true,
            ).first;
            
            if (coachQuery.isNotEmpty) {
              currentCoachDocument = coachQuery.first;
              Logger.info('Coach document loaded on retry: ${currentCoachDocument?.reference.id}');
            }
          } catch (e) {
            Logger.error('Error on retry loading coach document', error: e);
          }
        }
        
        final fcmToken = await FirebaseNotificationService.instance.getFcmToken();
        if (fcmToken != null && currentUserDocument != null) {
          await currentUserDocument!.reference.update({'fcmToken': fcmToken});
        }
        
        context.goNamed('CoachHome');
      } else if (role == 'trainee') {
        Logger.info('Navigating to User Home');
        FFAppState().userType = 'trainee';
        
        // Ensure the trainee document is loaded correctly
        try {
          // Try to fetch the trainee document directly
          final traineeQuery = await queryTraineeRecord(
            queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
            singleRecord: true,
          ).first;
          
          if (traineeQuery.isNotEmpty) {
            // Manually set the current trainee document
            currentTraineeDocument = traineeQuery.first;
            Logger.info('Trainee document loaded manually: ${currentTraineeDocument?.reference.id}');
          } else {
            Logger.warning('No trainee document found for user: ${user.uid}');
          }
        } catch (e) {
          Logger.error('Error loading trainee document', error: e);
        }
        
        await waitForAuth();
        
        // If trainee document is still null after waitForAuth, try one more time
        if (currentTraineeDocument == null) {
          Logger.warning('Trainee document still null after waitForAuth, trying again');
          try {
            await Future.delayed(const Duration(seconds: 1));
            final traineeQuery = await queryTraineeRecord(
              queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
              singleRecord: true,
            ).first;
            
            if (traineeQuery.isNotEmpty) {
              currentTraineeDocument = traineeQuery.first;
              Logger.info('Trainee document loaded on retry: ${currentTraineeDocument?.reference.id}');
            }
          } catch (e) {
            Logger.error('Error on retry loading trainee document', error: e);
          }
        }
        
        final fcmToken =
            await FirebaseNotificationService.instance.getFcmToken();
        if (fcmToken != null && currentUserDocument != null) {
          await currentUserDocument!.reference.update({'fcmToken': fcmToken});
        }
        
        context.goNamed('UserHome');
      }
    } catch (e) {
      _incrementLoginAttempts();
      Logger.error('Error during Google sign-in', error: e);
      // Improve error handling by providing more informative messages
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    if (_isLoading) return;

    try {
      setState(() => _isLoading = true);

      if (!mounted) return;
      // Prepare the auth event
      GoRouter.of(context).prepareAuthEvent();

      if (!_validateLoginAttempts()) {
        Logger.warning('Too many login attempts for Apple sign-in');
        if (mounted) {
          showErrorDialog(
              FFLocalizations.of(context).getText('tooManyLoginAttempts'),
              context);
        }
        return;
      }

      Logger.info('Attempting Apple sign-in');
      // Attempt to sign in with Apple
      final user = await authManager.signInWithApple(context, isLogin: true);

      if (!mounted) return;

      // Check if the user is null
      if (user == null) {
        Logger.warning('Apple sign-in failed - user not found');
        showErrorDialog(
            FFLocalizations.of(context)
                .getText('makeSureYouHaveCreatedAnAccountWithThisEmail'),
            context);
        return;
      }

      Logger.info('Apple sign-in successful for user: ${user.uid}');
      // Determine the role of the user
      final role = valueOrDefault(currentUserDocument?.role, '');

      // Store the result of context.mounted to avoid repeated checks

      FFAppState().isLogined = true;

      // Navigate based on the user's role
      if (role == 'coach') {
        Logger.info('Navigating to Coach Home');
        FFAppState().userType = 'coach';
        
        // Ensure the coach document is loaded correctly
        try {
          // Try to fetch the coach document directly
          final coachQuery = await queryCoachRecord(
            queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
            singleRecord: true,
          ).first;
          
          if (coachQuery.isNotEmpty) {
            // Manually set the current coach document
            currentCoachDocument = coachQuery.first;
            Logger.info('Coach document loaded manually: ${currentCoachDocument?.reference.id}');
          } else {
            Logger.warning('No coach document found for user: ${user.uid}');
          }
        } catch (e) {
          Logger.error('Error loading coach document', error: e);
        }
        
        await waitForAuth();
        
        // If coach document is still null after waitForAuth, try one more time
        if (currentCoachDocument == null) {
          Logger.warning('Coach document still null after waitForAuth, trying again');
          try {
            await Future.delayed(const Duration(seconds: 1));
            final coachQuery = await queryCoachRecord(
              queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
              singleRecord: true,
            ).first;
            
            if (coachQuery.isNotEmpty) {
              currentCoachDocument = coachQuery.first;
              Logger.info('Coach document loaded on retry: ${currentCoachDocument?.reference.id}');
            }
          } catch (e) {
            Logger.error('Error on retry loading coach document', error: e);
          }
        }
        
        final fcmToken = await FirebaseNotificationService.instance.getFcmToken();
        if (fcmToken != null && currentUserDocument != null) {
          await currentUserDocument!.reference.update({'fcmToken': fcmToken});
        }
        
        context.goNamed('CoachHome');
      } else if (role == 'trainee') {
        Logger.info('Navigating to User Home');
        FFAppState().userType = 'trainee';
        
        // Ensure the trainee document is loaded correctly
        try {
          // Try to fetch the trainee document directly
          final traineeQuery = await queryTraineeRecord(
            queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
            singleRecord: true,
          ).first;
          
          if (traineeQuery.isNotEmpty) {
            // Manually set the current trainee document
            currentTraineeDocument = traineeQuery.first;
            Logger.info('Trainee document loaded manually: ${currentTraineeDocument?.reference.id}');
          } else {
            Logger.warning('No trainee document found for user: ${user.uid}');
          }
        } catch (e) {
          Logger.error('Error loading trainee document', error: e);
        }
        
        await waitForAuth();
        
        // If trainee document is still null after waitForAuth, try one more time
        if (currentTraineeDocument == null) {
          Logger.warning('Trainee document still null after waitForAuth, trying again');
          try {
            await Future.delayed(const Duration(seconds: 1));
            final traineeQuery = await queryTraineeRecord(
              queryBuilder: (q) => q.where('user', isEqualTo: currentUserReference),
              singleRecord: true,
            ).first;
            
            if (traineeQuery.isNotEmpty) {
              currentTraineeDocument = traineeQuery.first;
              Logger.info('Trainee document loaded on retry: ${currentTraineeDocument?.reference.id}');
            }
          } catch (e) {
            Logger.error('Error on retry loading trainee document', error: e);
          }
        }
        
        final fcmToken =
            await FirebaseNotificationService.instance.getFcmToken();
        if (fcmToken != null && currentUserDocument != null) {
          await currentUserDocument!.reference.update({'fcmToken': fcmToken});
        }
        
        context.goNamed('UserHome');
      }
    } catch (e) {
      _incrementLoginAttempts();
      Logger.error('Error during Apple sign-in', error: e);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

// New LoginFormSection widget to encapsulate form state
class LoginFormSection extends StatefulWidget {
  const LoginFormSection({
    super.key,
    required this.model,
    required this.emailController,
    required this.passwordController,
    required this.onCaptchaVerified,
    required this.onSignInPressed,
    required this.onForgotPasswordPressed,
  });

  final LoginModel model;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(bool) onCaptchaVerified;
  final VoidCallback onSignInPressed;
  final VoidCallback onForgotPasswordPressed;

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Form Section - These don't change with captcha verification
        const _FormFields(),

        // Captcha widget in its own stateful widget to limit rebuild scope
        // CaptchaVerificationWidget(
        //   onCaptchaVerified: (isVerified) {
        //     setState(() {
        //       _isCaptchaVerified = isVerified;
        //     });
        //     widget.onCaptchaVerified(isVerified);
        //   },
        // ),

        // const SizedBox(height: 12.0),

        // Sign in button that depends on captcha state
        SignInButton(
          isEnabled: true,
          onPressed: widget.onSignInPressed,
        ),
        // These widgets don't depend on state changes
        const _ForgotPasswordSection(),
      ],
    );
  }

  // Helper method to get the parent widget
  LoginFormSection get parentWidget => widget;
}

// Extracted widget for form fields that don't need to rebuild on captcha verification
class _FormFields extends StatelessWidget {
  const _FormFields();

  @override
  Widget build(BuildContext context) {
    // Get parent widget to access properties
    final parent = context.findAncestorWidgetOfExactType<LoginFormSection>()!;

    return Column(
      children: [
        EmailField(
          controller: parent.emailController,
          focusNode: parent.model.textFieldFocusNode1,
          validator:
              parent.model.emailTextControllerValidator.asValidator(context),
          onFieldSubmitted: (value) {
            FocusScope.of(context)
                .requestFocus(parent.model.textFieldFocusNode2);
          },
        ),
        SizedBox(height: ResponsiveUtils.height(context, 12.0)),
        PasswordField(
          controller: parent.passwordController,
          focusNode: parent.model.textFieldFocusNode2,
          validator:
              parent.model.passwordTextControllerValidator.asValidator(context),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 24.0)),
      ],
    );
  }
}

// Extracted widget for forgot password to avoid rebuilds
class _ForgotPasswordSection extends StatelessWidget {
  const _ForgotPasswordSection();

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<LoginFormSection>()!;
    return ForgotPasswordButton(
      onPressed: parent.onForgotPasswordPressed,
    );
  }
}

// Dedicated widget for captcha verification to isolate state changes
class CaptchaVerificationWidget extends StatefulWidget {
  final Function(bool) onCaptchaVerified;

  const CaptchaVerificationWidget({
    super.key,
    required this.onCaptchaVerified,
  });

  @override
  State<CaptchaVerificationWidget> createState() =>
      _CaptchaVerificationWidgetState();
}

class _CaptchaVerificationWidgetState extends State<CaptchaVerificationWidget> {
  @override
  Widget build(BuildContext context) {
    return CaptchaWidget.simpleCaptcha(
      context,
      (isVerified) {
        widget.onCaptchaVerified(isVerified);
        if (context.mounted) {
          Future.delayed(const Duration(milliseconds: 200), () {
            FocusScope.of(context).unfocus();
          });
        }
      },
    );
  }
}
