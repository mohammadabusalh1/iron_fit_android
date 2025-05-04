// ignore_for_file: avoid_print
import 'package:iron_fit/Ad/AdService.dart';
import 'package:iron_fit/coach/trainee/components/notes_section.dart';
import 'package:iron_fit/coach/trainee/components/payment_history.dart';
import 'package:iron_fit/coach/trainee/components/subscription_management.dart';
import 'package:iron_fit/coach/trainee/components/subscription_status.dart';
import 'package:iron_fit/coach/trainee/components/trainee_card.dart';
import 'package:iron_fit/coach/trainee/components/trainee_handlers.dart';
import 'package:iron_fit/coach/trainee/components/training_plans.dart';
import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/flutter_flow/form_field_controller.dart';
import 'package:iron_fit/pages/error_page/error_page_widget.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'trainee_model.dart';
import 'package:flutter/services.dart';

// Import services
import 'package:iron_fit/services/trainee_service.dart';

export 'trainee_model.dart';

class TraineeWidget extends StatefulWidget {
  /// I want you to create a trainee training page to show trainee details and
  /// also renew subscription! to cancel subscription! and add or remove debts and
  /// attach a plan for the trainee.
  const TraineeWidget({
    super.key,
    required this.sub,
  });

  final DocumentReference? sub;

  @override
  State<TraineeWidget> createState() => _TraineeWidgetState();
}

class _TraineeWidgetState extends State<TraineeWidget> {
  late TraineeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AdService _adService;
  final TraineeService _traineeService = TraineeService();
  final TextEditingController _notesController = TextEditingController();
  bool _isLoadingData = true;
  bool _hasError = false;
  late SubscriptionsRecord? subscription;
  TraineeRecord? _traineeRecord;
  UserRecord? _userRecord;
  TraineeService get traineeService => _traineeService;

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => TraineeModel());
    _adService = AdService();
    // Add delay to ad loading
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _adService.loadAd(context);
      }
    });

    _loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _model.dispose();

    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      Logger.info('Loading trainee data');

      subscription = await SubscriptionsRecord.getDocument(widget.sub!).first;
      _notesController.text = subscription!.notes;

      if (currentCoachDocument == null) {
        Logger.warning('No coach record found for current user');
      } else {
        Logger.info('Coach record loaded successfully');
      }

      // Load trainee plans
      await _traineeService.loadTraineePlans(
        widget.sub!,
        (trainingPlanController, nutritionalPlanController) {
          if (mounted) {
            setState(() {
              _model.trainingPlanValueController =
                  trainingPlanController ?? FormFieldController<String>('none');
              _model.nutritionalPlanValueController =
                  nutritionalPlanController ??
                      FormFieldController<String>('none');
            });
          }
          Logger.info('Trainee plans loaded successfully');
        },
      );
      // Load trainee and user data
      if (subscription!.trainee != null) {
        try {
          _traineeRecord =
              await TraineeRecord.getDocumentOnce(subscription!.trainee!);

          if (_traineeRecord != null && _traineeRecord!.user != null) {
            _userRecord =
                await UserRecord.getDocumentOnce(_traineeRecord!.user!);
          }
        } catch (e) {
          Logger.error(
              'Error loading trainee or user data', e, StackTrace.current);
          _hasError = true;
        }
      }

      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
    } catch (e) {
      Logger.error('Failed to load trainee data', e, StackTrace.current);
      if (mounted) {
        setState(() {
          _isLoadingData = false;
          _hasError = true;
        });
        showErrorDialog(
            FFLocalizations.of(context).getText('errorOccurred'), context);
      }
    }
  }

  Future<void> _refreshSubscription() async {
    try {
      setState(() {
        _isLoadingData = true;
      });

      Logger.info('Refreshing subscription data');
      subscription = await SubscriptionsRecord.getDocument(widget.sub!).first;

      // Refresh trainee and user data
      if (subscription!.trainee != null) {
        try {
          _traineeRecord =
              await TraineeRecord.getDocumentOnce(subscription!.trainee!);

          if (_traineeRecord != null && _traineeRecord!.user != null) {
            _userRecord =
                await UserRecord.getDocumentOnce(_traineeRecord!.user!);
          }
        } catch (e) {
          Logger.error(
              'Error loading trainee or user data', e, StackTrace.current);
          _hasError = true;
        }
      }

      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
      Logger.info('Subscription data refreshed successfully');
    } catch (e) {
      Logger.error(
          'Failed to refresh subscription data', e, StackTrace.current);
      if (mounted) {
        setState(() {
          _isLoadingData = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        extendBodyBehindAppBar: true,
        appBar: CoachAppBar.coachAppBar(
            context,
            FFLocalizations.of(context).getText('8yqvtl51'),
            IconButton(
              onPressed: () {
                context.pushNamed('trainees');
              },
              icon: Icon(
                Icons.arrow_back,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
            ),
            null),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoadingData) {
      return const LoadingIndicator();
    }

    if (_hasError) {
      return const ErrorPageWidget();
    }

    // if (_traineeRecord == null) {
    //   return const ErrorPageWidget();
    // }

    return _buildMainContent();
  }

  Widget _buildMainContent() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + ResponsiveUtils.height(context, 80)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.5),
            FlutterFlowTheme.of(context).primaryBackground,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  TraineeCard(
                    subscription: subscription!,
                    traineeRecord: _traineeRecord,
                    userRecord: _userRecord,
                    subscriptionStatus: SubscriptionStatusWidget(
                      subscription: subscription!,
                    ),
                    traineeService: traineeService,
                    refreshSubscription: _refreshSubscription,
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 16)),
                  SubscriptionManagementWidget(
                    subscription: subscription!,
                    onRenewPressed: () async {
                      await TraineeHandlers.handleRenewSubscription(
                          context, subscription!, _refreshSubscription);
                    },
                    onCancelPressed: () async {
                      await TraineeHandlers.showCancelSubscriptionDialog(
                          context, subscription!);
                    },
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 16)),
                  PaymentHistoryWidget(
                    subscription: subscription!,
                    onAddDebtsPressed: () async {
                      await TraineeHandlers.handleAddDebts(
                          context, subscription!, _refreshSubscription);
                    },
                    onRemoveDebtsPressed: () async {
                      await TraineeHandlers.handleRemoveDebts(
                          context, subscription!, _refreshSubscription);
                    },
                    onViewBillsPressed: () =>
                        TraineeHandlers.handleViewBills(context, subscription!),
                    onViewDebtsPressed: () =>
                        showDebtsModal(subscription!, context),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 16)),
                  if (currentCoachDocument != null)
                    TrainingPlansWidget(
                      subscription: subscription!,
                      coachRecord: currentCoachDocument!,
                      trainingPlanController:
                          _model.trainingPlanValueController,
                      nutritionalPlanController:
                          _model.nutritionalPlanValueController,
                      onTrainingPlanChanged: (plan) {
                        if (plan == null) return;
                        setState(() {
                          _model.plan = plan;
                          _model.trainingPlanValueController.value =
                              plan.plan.name;
                        });
                      },
                      onNutritionalPlanChanged: (plan) {
                        if (plan == null) return;
                        setState(() {
                          _model.nutPlan = plan;
                          _model.nutritionalPlanValueController.value =
                              plan.nutPlan.name;
                        });
                      },
                      onDeleteTrainingPlan: () async {
                        await TraineeHandlers.handleDeleteTrainingPlan(
                            context, subscription!);
                        await _refreshSubscription();
                      },
                      onDeleteNutritionalPlan: () async {
                        await TraineeHandlers.handleDeleteNutritionalPlan(
                            context, subscription!);
                        await _refreshSubscription();
                      },
                      onSavePlans: () async {
                        await TraineeHandlers.handleSavePlans(context,
                            subscription!, _model.plan, _model.nutPlan);
                        await _refreshSubscription();
                      },
                    ),
                  SizedBox(height: ResponsiveUtils.height(context, 16)),
                  NotesSectionWidget(
                    controller: _notesController,
                    onSavePressed: () => TraineeHandlers.handleSaveNotes(
                        context, subscription!, _notesController),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget billItem({
    required Map<String, dynamic> bill,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.height(context, 12)),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate.withAlpha(60),
        ),
      ),
      child: ListTile(
        contentPadding: ResponsiveUtils.padding(
          context,
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: ResponsiveUtils.padding(context, horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.receipt_rounded,
            color: FlutterFlowTheme.of(context).primary,
            size: ResponsiveUtils.iconSize(context, 24),
          ),
        ),
        title: Text(
          '${bill['paid']} \$',
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 16),
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).success,
          ),
        ),
        subtitle: Text(
          dateTimeFormat(
            'relative',
            (bill['date'] as DateTime),
            locale: FFLocalizations.of(context).languageCode,
          ),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
      ),
    );
  }
}
