import 'package:flutter/services.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/flutter_flow/form_field_controller.dart';
import 'package:iron_fit/pages/login/componants/or_divider.dart';
import 'package:iron_fit/pages/pre_login/components/auth_service.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_up_model.dart';
import './sign_up_componants/index.dart';
export 'sign_up_model.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    super.key,
    String? type,
    String? type2,
  })  : type = type ?? 'Change to Trainee',
        type2 = type2 ?? 'coach';

  final String type;
  final String type2;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget>
    with SingleTickerProviderStateMixin {
  late final SignUpModel _model;
  bool _isLoading = false;
  bool _isSuccess = false;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  final _formKey = GlobalKey<FormState>();
  String? _verificationCode;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey userTypeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Call secure check login after build
    WidgetsBinding.instance
        .addPostFrameCallback((_) => AuthService.secureCheckLogin(context));
    _model = createModel(context, () => SignUpModel());
    _initializeControllers();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Create animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Setup all animations at once
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animation after setup is complete
    _animationController.forward();
  }

  void _initializeControllers() {
    // Initialize all controllers at once
    _model.emailTextController ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.phoneNumberController ??= TextEditingController();
    _model.phoneNumberFocusNode ??= FocusNode();
    _model.passwordTextController ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.userTypeController ??= FormFieldController<List<String>>(
        [context.read<FFAppState>().userType]);
    _model.countryCodeController ??= TextEditingController(text: "+970");
    _model.countryCodeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> createAccountByEmail() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _isSuccess = false;
    });

    // Navigate to UserType and wait for result
    final result = await context.pushNamed('UserType');

    // If user cancelled or didn't select a type, return early
    if (result == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 400), () {
        FocusScope.of(context).unfocus();
      });
    }

    try {
      // Store controller values in variables to avoid repeated access
      final email = _model.emailTextController.text;
      final password = _model.passwordTextController.text;
      final phoneNumber =
          _model.countryCodeController.text + _model.phoneNumberController.text;

      await authManager.signOut().then((_) async {
        if (await FirebaseService.isEmailInUse(email)) {
          if (mounted) {
            showErrorDialog(
                FFLocalizations.of(context).getText('emailIsAlreadyInUse'),
                context);
          }
          Logger.info('Email is already in use: $email');
        } else {
          _verificationCode =
              EmailVerificationService.generateVerificationCode();
          final sendEmailResult =
              await EmailVerificationService.sendVerificationEmail(
            recipientEmail: email,
            verificationCode: _verificationCode!,
          );

          if (sendEmailResult) {
            // Show verification code dialog
            final verificationResult =
                await EmailVerificationService.showVerificationDialog(
              context: context,
              email: email,
              verificationCode: _verificationCode!,
            );

            if (verificationResult == true) {
              await FirebaseService.createUserAccount(
                context: context,
                email: email,
                password: password,
                phoneNumber: phoneNumber,
                userType: context.read<FFAppState>().userType,
                onSuccess: (success) {
                  if (success) {
                    // Show success state
                    setState(() {
                      _isSuccess = true;
                    });
                    Logger.info('User account created successfully');
                  } else {
                    Logger.error('Failed to create user account');
                  }
                },
              );
            } else {
              if (mounted) {
                showErrorDialog(
                    FFLocalizations.of(context).getText('invalidCode'),
                    context);
                Logger.warning(
                    'User entered invalid verification code for $email');
              }
            }
          } else {
            if (mounted) {
              showErrorDialog(
                  FFLocalizations.of(context).getText('defaultErrorMessage'),
                  context);
              Logger.error('Failed to send verification email to $email');
            }
          }
        }
      });
    } catch (e) {
      Logger.error('Error during account creation',
          error: e, stackTrace: StackTrace.current);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
    } finally {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Stack(
          children: [
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
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Builder(
                        builder: (context) {
                          final screenHeight =
                              MediaQuery.of(context).size.height;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              screenHeight < 800
                                  ? SizedBox(height: screenHeight * 0.08)
                                  : SizedBox(
                                      height:
                                          screenHeight * 0.04), // 88.0 ~ 11%
                              FadeInDown(
                                duration: const Duration(milliseconds: 600),
                                child: const WelcomeSection(),
                              ),
                              SizedBox(
                                  height: screenHeight * 0.04), // 32.0 ~ 4%
                              FadeInUp(
                                duration: const Duration(milliseconds: 800),
                                child: Column(
                                  children: [
                                    EmailField(
                                      controller: _model.emailTextController!,
                                      focusNode: _model.textFieldFocusNode1!,
                                      fadeAnimation: _fadeAnimation,
                                      slideAnimation: _slideAnimation,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).requestFocus(
                                            _model.phoneNumberFocusNode);
                                      },
                                    ),
                                    SizedBox(
                                        height: screenHeight *
                                            0.015), // 12.0 ~ 1.5%
                                    PhoneField(
                                      controller: _model.phoneNumberController!,
                                      focusNode: _model.phoneNumberFocusNode!,
                                      countryCodeController:
                                          _model.countryCodeController!,
                                      fadeAnimation: _fadeAnimation,
                                      slideAnimation: _slideAnimation,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).requestFocus(
                                            _model.passwordFocusNode);
                                      },
                                    ),
                                    SizedBox(height: screenHeight * 0.015),
                                    PasswordField(
                                      controller:
                                          _model.passwordTextController!,
                                      focusNode: _model.textFieldFocusNode2!,
                                      fadeAnimation: _fadeAnimation,
                                      slideAnimation: _slideAnimation,
                                    ),
                                    SizedBox(
                                        height:
                                            screenHeight * 0.04), // 24.0 ~ 3%
                                    CaptchaVerification(
                                      isVerified: _model.isCaptchaVerified,
                                      onVerificationChanged: (isVerified) {
                                        setState(() {
                                          _model.isCaptchaVerified = isVerified;
                                        });
                                      },
                                    ),
                                    SizedBox(height: screenHeight * 0.015),
                                    CreateAccountButton(
                                      isLoading: _isLoading,
                                      isCaptchaVerified:
                                          _model.isCaptchaVerified,
                                      onPressed: () async {
                                        if (_model.phoneNumberController!.text
                                            .isEmpty) {
                                          showErrorDialog(
                                              FFLocalizations.of(context)
                                                  .getText('phoneHint'),
                                              context);
                                          return;
                                        }

                                        setState(() => _isLoading = true);
                                        HapticFeedback.mediumImpact();
                                        await createAccountByEmail();
                                      },
                                      scaleAnimation: _scaleAnimation,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: const OrDivider(),
                              ),
                              SizedBox(height: screenHeight * 0.01), // 8.0 ~ 1%
                              FadeInUp(
                                duration: const Duration(milliseconds: 1200),
                                child: SocialSignInButtons(
                                  onGooglePressed: () async {
                                    await FirebaseService.signInWithGoogle(
                                      context: context,
                                      onSuccess: (success) {
                                        if (!success &&
                                            currentUserReference != null) {
                                          UserRecord.collection
                                              .doc(currentUserReference!.id)
                                              .delete();
                                          currentUser!.delete();
                                        }
                                      },
                                    );
                                  },
                                  onApplePressed: () async {
                                    await FirebaseService.signInWithApple(
                                      context: context,
                                      onSuccess: (success) {
                                        // Optional success handler
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Loading Overlay
            LoadingOverlay(
              isLoading: _isLoading,
              isSuccess: _isSuccess,
            ),
            Positioned(
                right: 12,
                top: MediaQuery.of(context).padding.top + 12,
                child: FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: const LoginLink(),
                )),
          ],
        ),
      ),
    );
  }
}
