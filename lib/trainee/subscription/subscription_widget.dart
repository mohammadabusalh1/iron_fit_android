import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'subscription_model.dart';
export 'subscription_model.dart';
import 'components/subscription_header.dart';
import 'components/subscription_actions.dart';
import 'components/trainer_account_section.dart';
import 'components/current_plan_section.dart';
import 'components/payment_history_section.dart';
import 'components/subscription_empty_state.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:flutter/services.dart';

/// Create a page for me that displays subscription information: amount paid,
/// debts, trainer account, start date and end date.
///
/// In addition to a button to view the nutrition plan and another button to
/// view the training plan.
class SubscriptionWidget extends StatefulWidget {
  const SubscriptionWidget({super.key});

  @override
  State<SubscriptionWidget> createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget>
    with TickerProviderStateMixin {
  late SubscriptionModel _model;

  late AnimationController _slideController;
  SubscriptionsRecord? _subscriptionRecord;
  CoachRecord? _coachRecord;
  UserRecord? _userCoachRecord;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionModel());
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController.forward();
    _loadData();
  }

  Future<void> _loadData() async {
    if (currentTraineeDocument == null) return;
    try {
      // Load subscription record
      final subscriptionRecords = await querySubscriptionsRecord(
        queryBuilder: (subscriptionsRecord) => subscriptionsRecord
            .where('trainee', isEqualTo: currentTraineeDocument!.reference)
            .where('isActive', isEqualTo: true)
            .where('isDeleted', isEqualTo: false),
        singleRecord: true,
      ).first;

      if (subscriptionRecords.isEmpty) {
        if (mounted) setState(() => _subscriptionRecord = null);
        return;
      }

      final subscriptionRecord = subscriptionRecords.first;
      if (mounted) setState(() => _subscriptionRecord = subscriptionRecord);

      if (subscriptionRecord.coach == null) return;

      // Load coach record
      final coachRecord = await CoachRecord.getDocument(
        subscriptionRecord.coach!,
      ).first;

      if (coachRecord == null || coachRecord.user == null) return;
      if (mounted) setState(() => _coachRecord = coachRecord);

      // Load coach user record
      final userCoachRecord = await UserRecord.getDocument(
        coachRecord.user!,
      ).first;

      if (mounted) setState(() => _userCoachRecord = userCoachRecord);
    } catch (e, stackTrace) {
      Logger.error('Error loading subscription data', e, stackTrace);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<NutPlanRecord> getNutPlanRecord() async {
    try {
      // Fetch the trainee document
      final traineeQuery = await FirebaseFirestore.instance
          .collection('trainee')
          .where('user', isEqualTo: currentUserReference)
          .limit(1)
          .get();

      if (traineeQuery.docs.isEmpty) {
        Logger.warning(
            'Trainee not found for user: ${currentUserReference?.id}');
        throw Exception('Trainee not found');
      }

      final traineeDoc = traineeQuery.docs.first;
      Logger.debug('Found trainee document: ${traineeDoc.id}');

      // Fetch the subscription document
      final subQuery = await FirebaseFirestore.instance
          .collection('subscriptions')
          .where('trainee', isEqualTo: traineeDoc.reference)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (subQuery.docs.isEmpty) {
        Logger.warning(
            'Active subscription not found for trainee: ${traineeDoc.id}');
        throw Exception('Subscription not found');
      }

      final subDoc = subQuery.docs.first;
      Logger.debug('Found subscription document: ${subDoc.id}');

      // Fetch the nutrition plan document
      final nutPlanRef = subDoc.data()['nutPlan'];
      if (nutPlanRef == null) {
        Logger.warning(
            'Nutrition plan reference is null in subscription: ${subDoc.id}');
        throw Exception('Nutrition plan not found in subscription');
      }

      final nutPlanDoc = NutPlanRecord.getDocument(nutPlanRef);
      final nutPlan = await nutPlanDoc.first;

      if (nutPlan == null) {
        Logger.warning('Nutrition plan document not found: ${nutPlanRef.id}');
        return NutPlanRecord.empty();
      }

      Logger.debug('Successfully retrieved nutrition plan: ${nutPlanRef.id}');
      return nutPlan;
    } catch (e, stackTrace) {
      Logger.error('Error fetching nutrition plan', e, stackTrace);
      return NutPlanRecord.empty();
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
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        extendBodyBehindAppBar: true,
        body: _buildContent(context),
      ).withUserNavBar(1),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Show loading indicator if data is still loading
    if (currentTraineeDocument == null) {
      return const LoadingIndicator();
    }

    // Show empty state if no subscription found
    if (_subscriptionRecord == null ||
        _coachRecord == null ||
        _userCoachRecord == null) {
      return SubscriptionEmptyState(
        loadData: _loadData,
      );
    }

    // Show subscription content
    return Container(
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.05),
            FlutterFlowTheme.of(context).primaryBackground,
          ],
        ),
      ),
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SubscriptionHeader(),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SubscriptionActions(),
                    TrainerAccountSection(
                      coachRecord: _coachRecord!,
                      userCoachRecord: _userCoachRecord!,
                    ),
                    CurrentPlanSection(
                      coachRecord: _coachRecord!,
                      subscriptionsRecord: _subscriptionRecord!,
                    ),
                    PaymentHistorySection(
                      subscriptionsRecord: _subscriptionRecord!,
                    ),
                  ].divide(const SizedBox(height: 24)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
