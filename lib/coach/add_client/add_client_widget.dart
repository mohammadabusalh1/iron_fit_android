import 'package:iron_fit/coach/coach_analytics/coach_analytics_widget.dart';
import 'package:iron_fit/coach/coach_home/coach_home_widget.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/services/firebase_messages.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:iron_fit/widgets/date_pocker.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_client_model.dart';
import 'add_client_service.dart';
import 'components/components.dart';
export 'add_client_model.dart';

class AddClientWidget extends StatefulWidget {
  const AddClientWidget({super.key});

  @override
  State<AddClientWidget> createState() => _AddClientWidgetState();
}

class _AddClientWidgetState extends State<AddClientWidget> {
  final _formKey = GlobalKey<FormState>();
  late AddClientService _service;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _service = AddClientService(context);
    Logger.info('AddClient: Initialize add client screen');
  }

  Future<void> _handleSubmit(
      CoachRecord coachRecord, AddClientModel model) async {
    if (!mounted) return;

    try {
      setState(() => _isLoading = true);
      Logger.info('AddClient: Submitting client form data');

      // Clear caches after modifying data
      CoachHomeCache.clear();
      // CoachTraineesCache.clear();
      CoachAnalyticsCache.clear();

      final email = model.emailTextController.text.trim();
      final user = await _service.findUser(email);
      final trainee = user != null ? await _service.findTrainee(user) : null;

      Logger.info('AddClient: Checking subscription for email: $email');

      // Check for existing user and subscription
      final subscriptionExist =
          await _service.checkExistingSubscription(coachRecord, trainee, email);

      if (subscriptionExist.exist && !subscriptionExist.isDeleted) {
        Logger.warning('AddClient: Subscription already exists for: $email');
        _showErrorMessage(FFLocalizations.of(context)
            .getText('error_subscription_already_exists'));
        return;
      } else if (subscriptionExist.exist && subscriptionExist.isDeleted) {
        Logger.info('AddClient: Updating deleted subscription for: $email');
        await _service.updateSubscription(
            coachRecord,
            trainee,
            subscriptionExist.subscription!,
            model.goalTextController.text.trim(),
            model.levelValue,
            model.nameTextController.text.trim(),
            model.notesController.text.trim(),
            model.startDateTextController.text,
            model.endDateTextController.text,
            double.parse(model.paidTextController.text.trim()),
            double.parse(model.debtsTextController.text.trim()),
            model.selectedTrainingPlan,
            model.selectedNutritionalPlan);

        try {
          // Send notification if user exists and has FCM token
          if (user != null &&
              user.fcmToken != null &&
              user.fcmToken.isNotEmpty) {
            Logger.info('AddClient: Sending notification to user with token');
            await FirebaseNotificationService.instance.sendPushNotification(
              token: user.fcmToken,
              title: FFLocalizations.of(context).getText('new_subscription'),
              body: FFLocalizations.of(context)
                  .getText('new_subscription_message'),
              data: {
                'type': 'subscription_update',
                'coachId': coachRecord.reference.id,
              },
            );
          }
        } catch (e) {
          Logger.error('AddClient: Error sending notification: $e');
        }

        if (!mounted) return;
        trainee == null
            ? Navigator.pop(context, 'Anonymous')
            : Navigator.pop(context, 'Existing');
      } else {
        if (trainee == null) {
          Logger.info('AddClient: Creating anonymous subscription for: $email');
          await _service.createAnonymousSubscription(
              coachRecord,
              email,
              model.nameTextController.text.trim(),
              model.goalTextController.text.trim(),
              model.levelValue,
              model.notesController.text.trim(),
              model.startDateTextController.text,
              model.endDateTextController.text,
              double.parse(model.paidTextController.text.trim()),
              double.parse(model.debtsTextController.text.trim()),
              model.selectedTrainingPlan,
              model.selectedNutritionalPlan);

          if (!mounted) return;
          Navigator.pop(context, 'Anonymous');
        } else {
          Logger.info(
              'AddClient: Creating subscription for existing user: $email');
          await _service.createSubscription(
              coachRecord,
              trainee,
              email,
              model.nameTextController.text.trim(),
              model.goalTextController.text.trim(),
              model.levelValue,
              model.notesController.text.trim(),
              model.startDateTextController.text,
              model.endDateTextController.text,
              double.parse(model.paidTextController.text.trim()),
              double.parse(model.debtsTextController.text.trim()),
              model.selectedTrainingPlan,
              model.selectedNutritionalPlan);

          // Send notification if user has FCM token
          try {
            if (user != null &&
                user.fcmToken != null &&
                user.fcmToken.isNotEmpty) {
              Logger.info('AddClient: Sending notification to existing user');
              await FirebaseNotificationService.instance.sendPushNotification(
                token: user.fcmToken,
                title: FFLocalizations.of(context).getText('new_subscription'),
                body:
                    '${FFLocalizations.of(context).getText('subscription_requests_from_coach')} ${currentUserDocument!.displayName} ${FFLocalizations.of(context).getText('in')} ${coachRecord.gymName}',
                data: {
                  'type': 'new_subscription',
                  'coachId': coachRecord.reference.id,
                },
              );
            }
          } catch (e) {
            Logger.error('AddClient: Error sending notification: $e');
          }

          if (!mounted) return;
          Navigator.pop(context, 'Existing');
        }
      }
    } catch (e, s) {
      Logger.error('AddClient: Error in handleSubmit',
          error: e,
          stackTrace: s,
          extras: {'email': model.emailTextController.text.trim()});
      if (!mounted) return;
      _showErrorMessage(
          FFLocalizations.of(context).getText('error_creating_subscription'));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppStyles.textCairo(
            context,
            color: FlutterFlowTheme.of(context).info,
            fontSize: ResponsiveUtils.fontSize(context, 14),
          ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).error,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserReference == null) {
      Logger.warning('AddClient: No current user reference found');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed('Login');
      });
      return const LoadingIndicator();
    }

    if (currentCoachDocument == null) {
      Logger.warning('AddClient: No coach document found for current user');
      return const LoadingIndicator();
    }

    return ChangeNotifierProvider(
      create: (_) {
        final model = AddClientModel();
        // Set initial focus after model is created
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _setFocusForCurrentStep(model);

            // Set up listeners for real-time validation
            _setupValidationListeners(model);
          }
        });
        return model;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _buildScaffold(currentCoachDocument!),
      ),
    );
  }

  void _setupValidationListeners(AddClientModel model) {
    // Set up real-time validation listeners for key fields
    model.emailTextController.addListener(() {
      final email = model.emailTextController.text.trim();
      if (email.isNotEmpty &&
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        model.emailError =
            FFLocalizations.of(context).getText('error_invalid_email');
      } else {
        model.emailError = null;
      }
    });

    model.paidTextController.addListener(() {
      final paid = model.paidTextController.text.trim();
      if (paid.isNotEmpty) {
        try {
          final amount = double.parse(paid);
          if (amount < 0) {
            model.paidError =
                FFLocalizations.of(context).getText('error_negative_number');
          } else {
            model.paidError = null;
          }
        } catch (e) {
          model.paidError =
              FFLocalizations.of(context).getText('error_invalid_paid_amount');
        }
      }
    });

    model.debtsTextController.addListener(() {
      final debts = model.debtsTextController.text.trim();
      if (debts.isNotEmpty) {
        try {
          final amount = double.parse(debts);
          if (amount < 0) {
            model.debtsError =
                FFLocalizations.of(context).getText('error_negative_number');
          } else {
            model.debtsError = null;
          }
        } catch (e) {
          model.debtsError =
              FFLocalizations.of(context).getText('error_invalid_debts_amount');
        }
      }
    });
  }

  Widget _buildScaffold(CoachRecord coachRecord) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FlutterFlowTheme.of(context).success.withValues(alpha: 0.5),
            FlutterFlowTheme.of(context).primaryBackground,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Consumer<AddClientModel>(
          builder: (context, model, child) {
            // Show loading indicator when processing
            if (_isLoading) {
              return Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: const Center(
                  child: LoadingIndicator(),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              80, // Reserve space for navigation
                          maxWidth: isDesktop ? 1200 : double.infinity,
                        ),
                        padding: ResponsiveUtils.padding(
                          context,
                          horizontal: isDesktop ? 48 : (isTablet ? 32 : 24),
                          vertical: MediaQuery.of(context).padding.top + 12,
                        ),
                        margin: isDesktop
                            ? const EdgeInsets.symmetric(horizontal: 24)
                            : null,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isDesktop
                                ? 800
                                : (isTablet ? 600 : double.infinity),
                          ),
                          child: Column(
                            children: [
                              StepHeader(
                                title: _getStepTitle(model.currentStep),
                                description:
                                    _getStepDescription(model.currentStep),
                                onClose: () => Navigator.pop(context),
                                currentStep: model.currentStep,
                                totalSteps: model.totalSteps,
                              ),
                              _buildCurrentStep(model),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: StepNavigation(
                    currentStep: model.currentStep,
                    totalSteps: model.totalSteps,
                    onNext: () => _handleNextStep(coachRecord, model),
                    onPrevious: () => model.previousStep(),
                    hasErrors: _hasValidationErrors(model),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
      case 1:
        return FFLocalizations.of(context).getText('client_information');
      case 2:
      case 3:
        return FFLocalizations.of(context).getText('training_details');
      case 4:
      case 5:
        return FFLocalizations.of(context).getText('plans_selection');
      case 6:
        return FFLocalizations.of(context).getText('additional_info');
      default:
        return FFLocalizations.of(context).getText('client_information');
    }
  }

  String _getStepDescription(int step) {
    switch (step) {
      case 0:
      case 1:
        return FFLocalizations.of(context).getText('client_information_desc');
      case 2:
      case 3:
        return FFLocalizations.of(context).getText('training_details_desc');
      case 4:
      case 5:
        return FFLocalizations.of(context).getText('plans_selection_desc');
      case 6:
        return FFLocalizations.of(context).getText('additional_info_desc');
      default:
        return FFLocalizations.of(context).getText('client_information_desc');
    }
  }

  bool _hasValidationErrors(AddClientModel model) {
    switch (model.currentStep) {
      case 0:
        return model.emailError != null ||
            (model.emailTextController.text.isEmpty ||
                model.nameTextController.text.isEmpty);
      case 1:
        return model.startDateTextController.text.isEmpty ||
            model.endDateTextController.text.isEmpty ||
            (model.startDateTextController.text.isNotEmpty &&
                model.endDateTextController.text.isNotEmpty &&
                DateTime.parse(model.startDateTextController.text)
                    .isAfter(DateTime.parse(model.endDateTextController.text)));
      case 2:
        return model.goalTextController.text.isEmpty;
      case 3:
        return model.levelValue.isEmpty;
      case 4:
      case 6:
        return model.paidError != null ||
            model.debtsError != null ||
            model.paidTextController.text.isEmpty ||
            model.debtsTextController.text.isEmpty;
      default:
        return false;
    }
  }

  Widget _buildCurrentStep(AddClientModel model) {
    // Consolidated steps from 7 to 5 effective steps
    switch (model.currentStep) {
      case 0:
        return ClientInfoStep(
          model: model,
          isFirstStep: true,
          onStartDateSelected: (value) {
            buildShowDatePicker((value) {
              model.updateStartDate(value);
            }, context);
          },
          onEndDateSelected: (value) {
            buildShowDatePicker((value) {
              model.updateEndDate(value);
            }, context);
          },
        );
      case 1:
        return ClientInfoStep(
          model: model,
          isFirstStep: false,
          onStartDateSelected: (value) {
            buildShowDatePicker((value) {
              model.updateStartDate(value);
            }, context);
          },
          onEndDateSelected: (value) {
            buildShowDatePicker((value) {
              model.updateEndDate(value);
            }, context);
          },
        );
      case 2:
        return TrainingDetailsStep(
          model: model,
          isFirstStep: true,
          onLevelChanged: (value) {
            model.updateLevelValue(value);
          },
        );
      case 3:
        return TrainingDetailsStep(
          model: model,
          isFirstStep: false,
          onLevelChanged: (value) {
            model.updateLevelValue(value);
          },
          levelValidationError: _getLevelValidationError(model),
        );
      case 4:
        // Combined plans and payment info
        return SelectPlans(
          model: model,
          isFirstStep: true,
        );
      case 5:
        // Combined plans and payment info
        return AdditionalInfoStep(
          model: model,
          isFirstStep: true,
        );
      case 6:
        return AdditionalInfoStep(
          model: model,
          isFirstStep: false,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // Get level validation error if any
  String? _getLevelValidationError(AddClientModel model) {
    if (model.levelValue.isEmpty) {
      return FFLocalizations.of(context).getText('error_level_required');
    }
    return null;
  }

  Future<void> _handleNextStep(CoachRecord coach, AddClientModel model) async {
    Logger.info(
        'AddClient: Attempting to move to next step: ${model.currentStep + 1}');

    // Validate current step before proceeding
    if (!_validateCurrentStep(model)) {
      Logger.warning(
          'AddClient: Validation failed for step ${model.currentStep}');
      return;
    }

    if (model.currentStep < model.totalSteps - 1) {
      model.nextStep();
      Logger.info('AddClient: Advanced to step ${model.currentStep}');

      // Focus on first field of the new step
      _setFocusForCurrentStep(model);
    } else {
      // Last step - submit form
      Logger.info('AddClient: Final step reached, submitting form');
      await _handleSubmit(coach, model);
    }
  }

  // Validate the current step and show errors in snackbar if validation fails
  bool _validateCurrentStep(AddClientModel model) {
    if (model.currentStep == 1) {
      if (model.startDateTextController.text.isEmpty) {
        _showErrorMessage(
            FFLocalizations.of(context).getText('error_start_date_required'));
        return false;
      }

      if (DateTime.parse(model.startDateTextController.text)
          .isAfter(DateTime.parse(model.endDateTextController.text))) {
        _showErrorMessage(
            FFLocalizations.of(context).getText('error_start_before_end'));
        return false;
      }
    }

    // Check for custom validation for level selection on step 3
    if (model.currentStep == 3) {
      if (model.levelValue.isEmpty) {
        _showValidationErrors(
            [FFLocalizations.of(context).getText('error_level_required')]);
        return false;
      }
      return true;
    }

    if (!_formKey.currentState!.validate()) {
      // Get validation error messages from form fields
      List<String> errorMessages = _getValidationErrorsForCurrentStep(model);

      if (errorMessages.isNotEmpty) {
        _showValidationErrors(errorMessages);
      }
      return false;
    }
    return true;
  }

  void _showValidationErrors(List<String> errors) {
    if (errors.isEmpty) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FFLocalizations.of(context).getText('validation_errors'),
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).info,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveUtils.fontSize(context, 14),
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 4)),
            ...errors.map((error) => Padding(
                  padding: EdgeInsets.only(
                      bottom: ResponsiveUtils.height(context, 2)),
                  child: Text(
                    '• $error',
                    style: AppStyles.textCairo(
                      context,
                      color: FlutterFlowTheme.of(context).info,
                      fontSize: ResponsiveUtils.fontSize(context, 12),
                    ),
                  ),
                )),
          ],
        ),
        backgroundColor: FlutterFlowTheme.of(context).error,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Get validation errors for the current step
  List<String> _getValidationErrorsForCurrentStep(AddClientModel model) {
    List<String> errors = [];

    switch (model.currentStep) {
      case 0:
        // Email and name validation
        if (model.emailTextController.text.isEmpty) {
          errors
              .add(FFLocalizations.of(context).getText('error_email_required'));
        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(model.emailTextController.text)) {
          errors
              .add(FFLocalizations.of(context).getText('error_invalid_email'));
        }

        if (model.nameTextController.text.isEmpty) {
          errors
              .add(FFLocalizations.of(context).getText('error_name_required'));
        }
        break;

      case 1:
        // Start date and end date validation
        if (model.startDateTextController.text.isEmpty) {
          errors.add(
              FFLocalizations.of(context).getText('error_start_date_required'));
          break;
        }

        if (model.endDateTextController.text.isEmpty) {
          errors.add(
              FFLocalizations.of(context).getText('error_end_date_required'));
          break;
        }

        if (DateTime.parse(model.startDateTextController.text)
            .isAfter(DateTime.parse(model.endDateTextController.text))) {
          errors.add(
              FFLocalizations.of(context).getText('error_start_before_end'));
        }
        break;

      case 2:
        // Goal validation
        if (model.goalTextController.text.isEmpty) {
          errors
              .add(FFLocalizations.of(context).getText('error_goal_required'));
        }
        break;

      case 3:
        // Level validation
        String? levelError = _getLevelValidationError(model);
        if (levelError != null) {
          errors.add(levelError);
        }
        break;

      case 4:
      case 5:
      case 6:
        // Payment validation
        if (model.paidTextController.text.isEmpty) {
          errors.add(FFLocalizations.of(context)
              .getText('error_paid_amount_required'));
        } else {
          try {
            double paidAmount = double.parse(model.paidTextController.text);
            if (paidAmount < 0) {
              errors.add(
                  FFLocalizations.of(context).getText('error_negative_number'));
            }
          } catch (e) {
            errors.add(FFLocalizations.of(context)
                .getText('error_invalid_paid_amount'));
          }
        }

        if (model.debtsTextController.text.isEmpty) {
          errors.add(FFLocalizations.of(context)
              .getText('error_debts_amount_required'));
        } else {
          try {
            double debts = double.parse(model.debtsTextController.text);
            if (debts < 0) {
              errors.add(
                  FFLocalizations.of(context).getText('error_negative_number'));
            }
          } catch (e) {
            errors.add(FFLocalizations.of(context)
                .getText('error_invalid_debts_amount'));
          }
        }
        break;
    }

    return errors;
  }

  void _setFocusForCurrentStep(AddClientModel model) {
    // Add a slight delay to ensure the UI has updated
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      switch (model.currentStep) {
        case 0:
          FocusScope.of(context).requestFocus(model.emailFocusNode);
          break;
        case 1:
          FocusScope.of(context).requestFocus(model.startDateFocusNode);
          break;
        case 2:
          FocusScope.of(context).requestFocus(model.goalFocusNode);
          break;
        case 3:
          // No text focus for level selection
          FocusScope.of(context).unfocus();
          break;
        case 4:
          FocusScope.of(context).requestFocus(model.paidFocusNode);
          break;
        case 6:
          FocusScope.of(context).requestFocus(model.notesFocusNode);
          break;
      }
    });
  }
}

class UserSubscriptionCheck {
  final bool exist;
  final bool isDeleted;
  final SubscriptionsRecord? subscription;

  UserSubscriptionCheck(this.exist, this.isDeleted, this.subscription);
}
