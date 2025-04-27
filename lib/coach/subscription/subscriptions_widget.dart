import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:iron_fit/utils/logger.dart';
import 'subscriptions_model.dart';
import 'package:iron_fit/coach/subscription/componants/subscriptions_header.dart';
import 'package:iron_fit/coach/subscription/componants/subscription_plan_card.dart';
export 'subscriptions_model.dart';

class SubscriptionsWidget extends StatefulWidget {
  const SubscriptionsWidget({super.key});

  @override
  State<SubscriptionsWidget> createState() => _SubscriptionsWidgetState();
}

class _SubscriptionsWidgetState extends State<SubscriptionsWidget> {
  late SubscriptionsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Subscription prices from Firebase
  Map<String, String> _subscriptionPrices = {
    'monthly': '20\$',
    'quarterly': '50\$',
    'annual': '180\$',
  };
  bool _isLoading = true;

  // Common subscription features
  final List<String> _subscriptionFeatures = [
    'registerAndManageTrainees', // Register and manage trainees
    'createTrainingPlans', // Create training plans
    'createNutritionPlans', // Create nutrition plans
    'monitorAnalytics', // Monitor analytics
    'adFreeExperience', // Ad-free experience
  ];

  // Memoized localized features
  late List<String> _localizedFeatures;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionsModel());
    _savePageView();
    _fetchPricesFromFirebase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Memoize the localized features once per locale change
    _localizedFeatures = _subscriptionFeatures
        .map((key) => FFLocalizations.of(context).getText(key))
        .toList();
  }

  Future<void> _fetchPricesFromFirebase() async {
    try {
      final pricesCollection =
          await FirebaseFirestore.instance.collection('price').get();

      if (pricesCollection.docs.isNotEmpty) {
        final data = pricesCollection.docs.first.data();
        setState(() {
          _subscriptionPrices = {
            'monthly':
                data['monthly'] != null ? '${data['monthly']}\$' : '20\$',
            'quarterly':
                data['quarterly'] != null ? '${data['quarterly']}\$' : '50\$',
            'annual': data['annual'] != null ? '${data['annual']}\$' : '180\$',
          };
          _isLoading = false;
        });
      } else {
        // Use default values if document doesn't exist
        setState(() => _isLoading = false);
        Logger.warning('Subscription prices document not found');
      }
    } catch (e) {
      Logger.error('Error fetching subscription prices: $e');
      // Use default values if there's an error
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _updateSubscriptionDate(DateTime endDate) {
    // Don't call setState if no state actually changes
    // This prevents unnecessary rebuilds
  }

  Future<void> _savePageView() async {
    try {
      await EventsRecord.collection.add(
        createEventsRecordData(
          type: 'page_view_subscriptions',
          timestamp: DateTime.now(),
          coach: currentCoachDocument!.reference,
          data: {
            'page': 'subscriptions',
            'email': currentUserEmail,
          },
        ),
      );
    } catch (e) {
      debugPrint('Error saving session duration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  FlutterFlowTheme.of(context).success.withValues(alpha: 0.5),
                  FlutterFlowTheme.of(context).secondaryBackground,
                ],
              ),
            ),
            child: _isLoading
                ? const LoadingIndicator()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Header section
                        const SubscriptionsHeader(),

                        // Monthly subscription plan
                        SubscriptionPlanCard(
                          key: const ValueKey('monthly_plan'),
                          title: FFLocalizations.of(context).getText('Monthly'),
                          price: _subscriptionPrices['monthly']!,
                          description: FFLocalizations.of(context)
                              .getText('perfectForGettingStarted'),
                          features: _localizedFeatures,
                          buttonText: FFLocalizations.of(context)
                              .getText('chooseMonthly'),
                          paypalAmount: _subscriptionPrices['monthly']!
                              .replaceAll('\$', ''),
                          updateSubscriptionDate: _updateSubscriptionDate,
                        ),

                        // Quarterly subscription plan
                        SubscriptionPlanCard(
                          key: const ValueKey('quarterly_plan'),
                          title:
                              FFLocalizations.of(context).getText('Quarterly'),
                          price: _subscriptionPrices['quarterly']!,
                          description: FFLocalizations.of(context)
                              .getText('mostPopularChoice'),
                          saveText:
                              FFLocalizations.of(context).getText('save27'),
                          saveBackgroundColor: const Color(0xFFE3F2FD),
                          saveTextColor: const Color(0xFF1565C0),
                          features: _localizedFeatures,
                          buttonText: FFLocalizations.of(context)
                              .getText('chooseQuarterly'),
                          paypalAmount: _subscriptionPrices['quarterly']!
                              .replaceAll('\$', ''),
                          updateSubscriptionDate: _updateSubscriptionDate,
                        ),

                        // Annual subscription plan
                        SubscriptionPlanCard(
                          key: const ValueKey('annual_plan'),
                          title: FFLocalizations.of(context).getText('annual'),
                          price: _subscriptionPrices['annual']!,
                          description: FFLocalizations.of(context)
                              .getText('bestValueForLongTerm'),
                          saveText:
                              FFLocalizations.of(context).getText('save25'),
                          saveBackgroundColor: const Color(0xFFE8F5E9),
                          saveTextColor: const Color(0xFF1565C0),
                          features: _localizedFeatures,
                          buttonText: FFLocalizations.of(context)
                              .getText('chooseAnnual'),
                          paypalAmount: _subscriptionPrices['annual']!
                              .replaceAll('\$', ''),
                          updateSubscriptionDate: _updateSubscriptionDate,
                        ),

                        const SizedBox(height: 24),
                      ].divide(const SizedBox(height: 24)),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
