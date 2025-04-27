import 'package:iron_fit/coach/coach_analytics/coach_analytics_widget.dart';
import 'package:iron_fit/coach/coach_home/coach_home_widget.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/services/firebase_messages.dart';
import 'package:iron_fit/widgets/date_pocker.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
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
  final _logger = Logger('AddClientWidget');
  late AddClientService _service;

  // Add screen breakpoints
  static const double kTabletBreakpoint = 768.0;
  static const double kDesktopBreakpoint = 1024.0;

  @override
  void initState() {
    super.initState();
    _service = AddClientService(context);
  }

  Future<void> _handleSubmit(
      CoachRecord coachRecord, AddClientModel model) async {
    if (!mounted) return;

    try {
      // Clear caches after modifying data
      CoachHomeCache.clear();
      // CoachTraineesCache.clear();
      CoachAnalyticsCache.clear();

      final email = model.emailTextController.text.trim();
      final user = await _service.findUser(email);
      final trainee = user != null ? await _service.findTrainee(user) : null;

      // Check for existing user and subscription
      final subscriptionExist =
          await _service.checkExistingSubscription(coachRecord, trainee, email);

      if (subscriptionExist.exist && !subscriptionExist.isDeleted) {
        showErrorDialog(
            FFLocalizations.of(context)
                .getText('error_subscription_already_exists'),
            context);
        return;
      } else if (subscriptionExist.exist && subscriptionExist.isDeleted) {
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

        // Send notification if user exists and has FCM token
        if (user != null && user.fcmToken != null && user.fcmToken.isNotEmpty) {
          await FirebaseNotificationService.instance.sendPushNotification(
            token: user.fcmToken,
            title: FFLocalizations.of(context).getText('new_subscription'),
            body:
                FFLocalizations.of(context).getText('new_subscription_message'),
            data: {
              'type': 'subscription_update',
              'coachId': coachRecord.reference.id,
            },
          );
        }

        if (!mounted) return;
        trainee == null
            ? Navigator.pop(context, 'Anonymous')
            : Navigator.pop(context, 'Existing');
      } else {
        if (trainee == null) {
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
          if (user != null &&
              user.fcmToken != null &&
              user.fcmToken.isNotEmpty) {
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

          if (!mounted) return;
          Navigator.pop(context, 'Existing');
        }
      }
    } catch (e, s) {
      _logger.severe('Error in _handleSubmit: $e');
      _logger.severe('Stack trace: $s');
      if (!mounted) return;
      showErrorDialog(FFLocalizations.of(context).getText('2184r6dy'), context);
      // if (context.mounted) {
      //   Navigator.pop(context);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserReference == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed('Login');
      });
      return const LoadingIndicator();
    }

    if (currentCoachDocument == null) {
      return const LoadingIndicator();
    }

    return ChangeNotifierProvider(
      create: (_) {
        final model = AddClientModel();
        // Set initial focus after model is created
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _setFocusForCurrentStep(model);
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

  Widget _buildScaffold(CoachRecord coachRecord) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).info.withOpacity(0.3),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= kDesktopBreakpoint;
          final isTablet = constraints.maxWidth >= kTabletBreakpoint &&
              constraints.maxWidth < kDesktopBreakpoint;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                  maxWidth: isDesktop ? 1200 : double.infinity,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      FlutterFlowTheme.of(context)
                          .success
                          .withValues(alpha: 0.5),
                      FlutterFlowTheme.of(context).primaryBackground,
                    ],
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 48 : (isTablet ? 32 : 24),
                  48,
                  isDesktop ? 48 : (isTablet ? 32 : 24),
                  0,
                ),
                margin: isDesktop
                    ? const EdgeInsets.symmetric(horizontal: 24)
                    : null,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          isDesktop ? 800 : (isTablet ? 600 : double.infinity),
                    ),
                    child: _buildContentArea(coachRecord, isDesktop, isTablet),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentArea(
      CoachRecord coachRecord, bool isDesktop, bool isTablet) {
    return Consumer<AddClientModel>(
      builder: (context, model, child) {
        return Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StepHeader(
                title:
                    FFLocalizations.of(context).getText('client_information'),
                description: FFLocalizations.of(context)
                    .getText('client_information_desc'),
                onClose: () => Navigator.pop(context),
                currentStep: model.currentStep,
                totalSteps: model.totalSteps,
              ),
              _buildCurrentStep(model),
              StepNavigation(
                currentStep: model.currentStep,
                totalSteps: model.totalSteps,
                onNext: () => _handleNextStep(coachRecord, model),
                onPrevious: () => model.previousStep(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentStep(AddClientModel model) {
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
        return AdditionalInfoStep(
          model: model,
          isFirstStep: true,
        );
      case 5:
        return SelectPlans(
          model: model,
          isFirstStep: false,
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
    if (model.levelValue == null || model.levelValue.isEmpty) {
      return FFLocalizations.of(context).getText('error_level_required');
    }
    return null;
  }

  Future<void> _handleNextStep(CoachRecord coach, AddClientModel model) async {
    // Validate current step before proceeding
    if (!_validateCurrentStep(model)) {
      return;
    }

    if (model.currentStep < model.totalSteps - 1) {
      model.nextStep();
      // Focus on first field of the new step
      _setFocusForCurrentStep(model);
    } else {
      await _handleSubmit(coach, model);
    }
  }

  // Validate the current step and show errors in snackbar if validation fails
  bool _validateCurrentStep(AddClientModel model) {
    // Check for custom validation for level selection on step 3
    if (model.currentStep == 3) {
      if (model.levelValue == null || model.levelValue.isEmpty) {
        // Show errors in snackbar
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• ${FFLocalizations.of(context).getText('error_level_required')}',
                  style: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).info,
                  ),
                ),
              ],
            ),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: const Duration(seconds: 4),
          ),
        );
        return false;
      }
      return true;
    }

    if (!_formKey.currentState!.validate()) {
      // Get validation error messages from form fields
      List<String> errorMessages = _getValidationErrorsForCurrentStep(model);

      if (errorMessages.isNotEmpty) {
        // Show errors in snackbar
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
                  ),
                ),
                const SizedBox(height: 4),
                ...errorMessages.map((error) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '• $error',
                        style: AppStyles.textCairo(
                          context,
                          color: FlutterFlowTheme.of(context).info,
                        ),
                      ),
                    )),
              ],
            ),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return false;
    }
    return true;
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
        // Goal and level validation
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
