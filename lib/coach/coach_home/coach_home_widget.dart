// Flutter core imports
import 'package:flutter/material.dart';
import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/utils/logger.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// Third-party package imports
import 'package:collection/collection.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:lottie/lottie.dart';

// FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Firebase and authentication imports
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/componants/CheckSubscribe/check_subscribe.dart';
import '/componants/Styles.dart';
// Local components
import 'components/dashboard_card.dart';
import 'components/statistic_box.dart';
import 'components/quick_action_button.dart';
import 'components/subscription_card.dart';
// Utils
import 'utils/coach_home_utils.dart';
import '/utils/responsive_utils.dart';
// Model
import 'coach_home_model.dart';
export 'coach_home_model.dart';

class CoachHomeCache {
  static DateTime? lastFetchTime;
  static const Duration cacheValidity = Duration(minutes: 5);
  static int activeSubscriptionsCount = 0;
  static double _totalEarnings = 0;
  static List<SubscriptionsRecord> _recentSubscriptions = [];

  static bool get isValid {
    if (lastFetchTime == null) return false;
    return DateTime.now().difference(lastFetchTime!) < cacheValidity;
  }

  static void updateSubscriptionData(
      int activeCount, double earnings, List<SubscriptionsRecord> recentSubs) {
    activeSubscriptionsCount = activeCount;
    _totalEarnings = earnings;
    _recentSubscriptions = List.from(recentSubs);
    lastFetchTime = DateTime.now();
  }

  static Future<void> clear() async{
    Logger.info('Clearing coach home cache');
    lastFetchTime = null;
    activeSubscriptionsCount = 0;
    _totalEarnings = 0;
    _recentSubscriptions = [];
  }
}

class CoachHomeWidget extends StatefulWidget {
  const CoachHomeWidget({super.key});

  @override
  State<CoachHomeWidget> createState() => _CoachHomeWidgetState();
}

class _CoachHomeWidgetState extends State<CoachHomeWidget>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late CoachHomeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Replace instance variables with ValueNotifiers
  final ValueNotifier<int> activeSubscriptionsCount = ValueNotifier<int>(0);
  final ValueNotifier<double> _totalEarnings = ValueNotifier<double>(0.0);
  final ValueNotifier<List<SubscriptionsRecord>> _recentSubscriptions =
      ValueNotifier<List<SubscriptionsRecord>>([]);
  final ValueNotifier<bool> _isSubscriptionsLoading =
      ValueNotifier<bool>(false);
  final ValueNotifier<String?> _subscriptionsError =
      ValueNotifier<String?>(null);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = createModel(context, () => CoachHomeModel());

    // Load ad with a slight delay to allow the UI to initialize first
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _model.adService.loadAd(context);
      }
    });

    _initializeData();

    // Check if subscription reminder should be shown
    _checkAndShowSubscriptionReminder();
  }

  Future<void> _initializeData() async {
    try {
      if (CoachHomeCache.isValid) {
        activeSubscriptionsCount.value =
            CoachHomeCache.activeSubscriptionsCount;
        _totalEarnings.value = CoachHomeCache._totalEarnings;
        _recentSubscriptions.value = CoachHomeCache._recentSubscriptions;
        return;
      }

      _model.isLoading.value = true;
      _model.error.value = null;

      if (currentCoachDocument == null) {
        throw Exception('User not authenticated');
      }

      try {
        await _fetchSubscriptionsData(currentCoachDocument!.reference);
      } catch (e) {
        Logger.error('Error processing coach data: $e');
        _model.isLoading.value = false;
      }
    } catch (e) {
      Logger.error('Error initializing data: $e');
      _model.isLoading.value = false;
    }
  }

  Future<void> _fetchSubscriptionsData(DocumentReference coachRef) async {
    try {
      _isSubscriptionsLoading.value = true;
      _subscriptionsError.value = null;

      // 1. Fetch active subscriptions count
      querySubscriptionsRecord(
        queryBuilder: (subscriptionsRecord) => subscriptionsRecord
            .where('coach', isEqualTo: coachRef)
            .where('endDate', isGreaterThan: DateTime.now())
            .where('isDeleted', isEqualTo: false),
      ).listen((subscriptions) {
        final subscriptionsWithoutUnactive = subscriptions
            .where((subscription) =>
                subscription.isActive == true ||
                (subscription.isActive == false &&
                    subscription.isAnonymous == true))
            .toList();
        final count = subscriptionsWithoutUnactive.length;
        if (mounted) {
          activeSubscriptionsCount.value = count;
          CoachHomeCache.activeSubscriptionsCount = count;
        }
      }, onError: (e) {
        Logger.warning('Error fetching active subscriptions count: $e');
        if (mounted) {
          _subscriptionsError.value =
              FFLocalizations.of(context).getText('subscription_count_error');
        }
      });

      // 2. Fetch total earnings
      querySubscriptionsRecord(
        queryBuilder: (subscriptionsRecord) => subscriptionsRecord.where(
          'coach',
          isEqualTo: coachRef,
        ),
      ).listen((subscriptions) {
        try {
          final subscriptionsWithoutUnactive = subscriptions
              .where((subscription) =>
                  subscription.isActive == true ||
                  (subscription.isActive == false &&
                      subscription.isAnonymous == true))
              .toList();
          final earnings =
              subscriptionsWithoutUnactive.map((e) => e.amountPaid).sum;
          if (mounted) {
            _totalEarnings.value = earnings;
            CoachHomeCache._totalEarnings = earnings;
          }
        } catch (e) {
          Logger.warning('Error calculating total earnings: $e');
          if (mounted) {
            _subscriptionsError.value =
                FFLocalizations.of(context).getText('earnings_calc_error');
          }
        }
      }, onError: (e) {
        Logger.warning('Error fetching earnings data: $e');
        if (mounted) {
          _subscriptionsError.value =
              FFLocalizations.of(context).getText('earnings_fetch_error');
        }
      });

      // 3. Fetch recent subscriptions
      try {
        final subscriptions = await CoachHomeUtils.getSubscriptions(coachRef);
        if (mounted) {
          _recentSubscriptions.value = subscriptions;
          CoachHomeCache._recentSubscriptions = subscriptions;

          // Update all cache data at once when all data is fetched
          CoachHomeCache.updateSubscriptionData(
            activeSubscriptionsCount.value,
            _totalEarnings.value,
            subscriptions,
          );
        }
      } catch (e) {
        Logger.warning('Error fetching recent subscriptions: $e');
        if (mounted) {
          _subscriptionsError.value =
              FFLocalizations.of(context).getText('recent_subscriptions_error');
        }
      }
    } catch (e) {
      Logger.error('Error in subscription data fetch: $e');
      if (mounted) {
        _subscriptionsError.value =
            FFLocalizations.of(context).getText('subscription_fetch_error');
      }
    } finally {
      if (mounted) {
        _isSubscriptionsLoading.value = false;
        _model.isLoading.value = false;
      }
    }
  }

  Future<void> _checkAndShowSubscriptionReminder() async {
    try {
      // Skip reminder if user is already subscribed
      if (currentCoachDocument?.isSub == true) {
        return;
      }

      if (currentUserReference == null) {
        Logger.warning(
            'Cannot show subscription reminder: User not authenticated');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final userId = currentUserReference!.id;
      final prefKey = 'last_subscription_reminder_$userId';

      final lastShownTimestamp = prefs.getInt(prefKey) ?? 0;
      final lastShownDate =
          DateTime.fromMillisecondsSinceEpoch(lastShownTimestamp);
      final now = DateTime.now();

      // Show reminder if a week has passed since the last reminder
      if (now.difference(lastShownDate).inDays >= 7) {
        // Add a small delay to ensure the UI is built
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            _showSubscriptionReminder(context);
            // Save current timestamp using the same key as when retrieving
            prefs.setInt(prefKey, now.millisecondsSinceEpoch);
          }
        });
      }
    } catch (e) {
      Logger.error('Error checking subscription reminder: $e');
    }
  }

  @override
  void dispose() {
    // Dispose ValueNotifiers
    activeSubscriptionsCount.dispose();
    _totalEarnings.dispose();
    _recentSubscriptions.dispose();
    _isSubscriptionsLoading.dispose();
    _subscriptionsError.dispose();

    WidgetsBinding.instance.removeObserver(this);
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder<bool>(
      valueListenable: _model.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const LoadingIndicator();
        }

        return ValueListenableBuilder<String?>(
          valueListenable: _model.error,
          builder: (context, error, _) {
            if (error != null) {
              return _buildErrorScreen(error);
            }

            if (currentCoachDocument == null) {
              return const LoadingIndicator();
            }

            return _buildMainScaffold(context, currentCoachDocument!);
          },
        );
      },
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: FlutterFlowTheme.of(context).error,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: AppStyles.textCairo(
                context,
                fontSize: 16,
                color: FlutterFlowTheme.of(context).error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initializeData,
              child: Text(
                FFLocalizations.of(context).getText('retry'),
                style: AppStyles.textCairo(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainScaffold(BuildContext context, CoachRecord coachRecord) {
    return GestureDetector(
      key: const Key('coach_home_screen'),
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).info.withOpacity(0.2),
          extendBody: true,
          extendBodyBehindAppBar: true,
          key: const Key('coach_home_screen'),
          appBar: CoachAppBar.coachAppBar(
              context,
              FFLocalizations.of(context).getText('y6lkmf4w' /* My Trainees */),
              null,
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24,
                ),
                onPressed: () {
                  context.pushNamed('Contact');
                },
              )),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.5),
                      FlutterFlowTheme.of(context).primaryBackground,
                    ],
                  ),
                ),
              ),
              _buildMainContent(context, coachRecord),
              if (!coachRecord.isSub)
                Positioned(
                  bottom: ResponsiveUtils.height(context, 100),
                  left: ResponsiveUtils.width(context, 12),
                  child: _buildSubscriptionButton(),
                ),
            ],
          )).withCoachNavBar(0),
    );
  }

  Widget _buildMainContent(BuildContext context, CoachRecord coachRecord) {
    return Container(
      padding: ResponsiveUtils.padding(context, horizontal: 8, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: MediaQuery.of(context).padding.top +
                    ResponsiveUtils.height(context, 80)),
            _buildWelcomeCard(coachRecord),
            SizedBox(height: ResponsiveUtils.height(context, 0)),
            _buildNewUsersCard(coachRecord),
            SizedBox(height: ResponsiveUtils.height(context, 0)),
            _buildQuickActionsCard(coachRecord),
            SizedBox(height: ResponsiveUtils.height(context, 88)),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(CoachRecord coachRecord) {
    return DashboardCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.waving_hand_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: ResponsiveUtils.iconSize(context, 24),
                      ),
                      SizedBox(width: ResponsiveUtils.width(context, 8)),
                      Text(
                        FFLocalizations.of(context).getText('hct5x4gc'),
                        style: AppStyles.textCairo(
                          context,
                          color: FlutterFlowTheme.of(context)
                              .info
                              .withOpacity(0.7),
                          fontSize: ResponsiveUtils.fontSize(context, 16),
                        ),
                      ),
                    ],
                  ),
                  AuthUserStreamWidget(
                      builder: (context) => SizedBox(
                            width: ResponsiveUtils.width(context, 230),
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              currentUserDisplayName.length > 16
                                  ? currentUserDisplayName.split(' ')[0]
                                  : currentUserDisplayName,
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 22),
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                          )),
                ],
              ),
              Container(
                width: ResponsiveUtils.width(context, 60.0),
                height: ResponsiveUtils.height(context, 60.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: FlutterFlowTheme.of(context).primary.withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: currentUserPhoto.isNotEmpty
                      ? Image.network(
                          currentUserPhoto,
                          width: ResponsiveUtils.width(context, 60.0),
                          height: ResponsiveUtils.height(context, 60.0),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              color: FlutterFlowTheme.of(context).primary,
                              size: ResponsiveUtils.iconSize(context, 30),
                            );
                          },
                        )
                      : Icon(
                          Icons.person,
                          color: FlutterFlowTheme.of(context).primary,
                          size: ResponsiveUtils.iconSize(context, 30),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 24)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Using ValueListenableBuilder instead of cached variables directly
              ValueListenableBuilder<int>(
                valueListenable: activeSubscriptionsCount,
                builder: (context, count, _) {
                  return StatisticBox(
                    icon: Icons.people,
                    label: FFLocalizations.of(context).getText('wuiqzsk2'),
                    value: count.toString(),
                  );
                },
              ),
              ValueListenableBuilder<double>(
                valueListenable: _totalEarnings,
                builder: (context, earnings, _) {
                  return StatisticBox(
                    icon: Icons.attach_money_rounded,
                    label: FFLocalizations.of(context).getText('o6oyyl6j'),
                    showCurrency: true,
                    value: earnings.toString(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewUsersCard(CoachRecord coachRecord) {
    return DashboardCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.group_add_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                  SizedBox(width: ResponsiveUtils.width(context, 8)),
                  Text(
                    FFLocalizations.of(context).getText('iplgncry'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 18),
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.width(context, 12),
                    vertical: ResponsiveUtils.height(context, 6)),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  FFLocalizations.of(context).getText('recent'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 12),
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 16)),
          // Using ValueListenableBuilder instead of FutureBuilder
          _buildSubscriptionsList(),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsList() {
    return ValueListenableBuilder<List<SubscriptionsRecord>>(
      valueListenable: _recentSubscriptions,
      builder: (context, subscriptions, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isSubscriptionsLoading,
          builder: (context, isLoading, _) {
            if (isLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primary,
              ));
            }

            return ValueListenableBuilder<String?>(
              valueListenable: _subscriptionsError,
              builder: (context, error, _) {
                if (error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: FlutterFlowTheme.of(context).error,
                          size: ResponsiveUtils.iconSize(context, 40),
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 8)),
                        Text(
                          error,
                          style: AppStyles.textCairo(
                            context,
                            color: FlutterFlowTheme.of(context).error,
                            fontSize: ResponsiveUtils.fontSize(context, 14),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 16)),
                        ElevatedButton(
                          onPressed: () => _initializeData(),
                          child: Text(
                            FFLocalizations.of(context).getText('retry'),
                            style: AppStyles.textCairo(context),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (subscriptions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: ResponsiveUtils.padding(context,
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_search_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: ResponsiveUtils.iconSize(context, 40),
                          ),
                          SizedBox(height: ResponsiveUtils.height(context, 8)),
                          Text(
                            FFLocalizations.of(context).getText('noData'),
                            style: AppStyles.textCairo(
                              context,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: ResponsiveUtils.fontSize(context, 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: subscriptions.map((subscription) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: ResponsiveUtils.height(context, 12)),
                      child: SubscriptionCard(subscription: subscription),
                    );
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQuickActionsCard(CoachRecord coachRecord) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
          0.0, 0.0, 0.0, ResponsiveUtils.height(context, 48.0)),
      child: DashboardCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: ResponsiveUtils.iconSize(context, 24),
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 8)),
                    Text(
                      FFLocalizations.of(context).getText('smxiy5uk'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 18),
                        fontWeight: FontWeight.w600,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.width(context, 12),
                      vertical: ResponsiveUtils.height(context, 6)),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    FFLocalizations.of(context).getText('actions'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 12),
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.height(context, 24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickActionButton(
                  icon: Icons.person_add,
                  label: FFLocalizations.of(context).getText('vecicunb'),
                  onTap: () => _handleAddClientTap(coachRecord),
                  gradient: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).tertiary,
                  ],
                ),
                QuickActionButton(
                  icon: Icons.event,
                  label: FFLocalizations.of(context).getText('f90f3w9k'),
                  onTap: () => context.pushNamed('CoachExercisesPlans'),
                  gradient: [
                    FlutterFlowTheme.of(context).tertiary,
                    FlutterFlowTheme.of(context).primary,
                  ],
                ),
                QuickActionButton(
                  icon: Icons.message_rounded,
                  label: FFLocalizations.of(context).getText('vj2epgx9'),
                  onTap: () => context.pushNamed('Mesagess'),
                  gradient: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).tertiary,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddClientTap(CoachRecord coachRecord) async {
    final currentContext = context;
    if (coachRecord.isSub == true) {
      currentContext.pushNamed('AddClient').then((result) {
        if (!mounted) return;
        if (result == 'none' || result == null) {
          return;
        } else if (result == 'Anonymous') {
          showSuccessDialog(
              FFLocalizations.of(currentContext).getText('y22ou22a'),
              currentContext);
        } else {
          showSuccessDialog(
              FFLocalizations.of(currentContext)
                  .getText('success_client_added'),
              currentContext);
        }
      });
    } else {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: currentContext,
        builder: (context) {
          return CheckSubscribe(
            showInterstitialAd: () {
              _model.adService.showInterstitialAd(context);
              currentContext.pushNamed('AddClient').then((result) {
                if (!mounted) return;
                if (result == 'none' || result == null) {
                  return;
                } else if (result == 'Anonymous') {
                  showSuccessDialog(
                      FFLocalizations.of(currentContext).getText('y22ou22a'),
                      currentContext);
                } else {
                  showSuccessDialog(
                      FFLocalizations.of(currentContext)
                          .getText('success_client_added'),
                      currentContext);
                }
              });
            },
            page: '',
          );
        },
      );
    }
  }

  void showSuccessDialog(String message, BuildContext dialogContext) {
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                // Success animation
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: ResponsiveUtils.padding(context,
                            horizontal: 16, vertical: 16),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Lottie.asset(
                          'assets/lottie/success.json',
                          fit: BoxFit.cover,
                          animate: true,
                          repeat: true,
                          width: ResponsiveUtils.width(context, 64),
                          height: ResponsiveUtils.height(context, 64),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
                // Success title
                Text(
                  FFLocalizations.of(context).getText('success'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 24),
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                // Success message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.height(context, 16)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      FFLocalizations.of(context).getText('ok'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildSubscriptionButton() {
    return ElevatedButton(
      onPressed: () => context.pushNamed('Subscription'),
      style: ElevatedButton.styleFrom(
        backgroundColor: FlutterFlowTheme.of(context).info,
        shape: CircleBorder(
          side: BorderSide(
            color: FlutterFlowTheme.of(context).tertiary,
            width: 2,
          ),
        ),
        fixedSize: Size(ResponsiveUtils.width(context, 66),
            ResponsiveUtils.height(context, 66)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: ResponsiveUtils.height(context, 10)),
        child: Column(
          children: [
            Icon(
              Icons.workspace_premium,
              color: FlutterFlowTheme.of(context).primary,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            Text(
              FFLocalizations.of(context).getText('premium'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 7),
                color: FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionReminder(BuildContext context) {
    if (!mounted) return;

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: Container(
              padding: ResponsiveUtils.padding(context,
                  horizontal: 24, vertical: 24),
              height: ResponsiveUtils.height(context, 320),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: ResponsiveUtils.iconSize(context, 24),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: FlutterFlowTheme.of(context).primary,
                            size: ResponsiveUtils.iconSize(context, 40),
                          ),
                          SizedBox(height: ResponsiveUtils.height(context, 16)),
                          Text(
                            FFLocalizations.of(context)
                                .getText('subscription_reminder'),
                            style: AppStyles.textCairo(
                              context,
                              fontSize: ResponsiveUtils.fontSize(context, 16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            FFLocalizations.of(context)
                                .getText('subscription_reminder_description'),
                            textAlign: TextAlign.center,
                            style: AppStyles.textCairo(
                              context,
                              fontSize: ResponsiveUtils.fontSize(context, 12),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveUtils.height(context, 16)),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.pushNamed('Subscription');
                        },
                        icon: Icon(
                          Icons.star,
                          size: ResponsiveUtils.iconSize(context, 24),
                        ),
                        label: Text(
                          FFLocalizations.of(context).getText('subscribe_now'),
                          style: AppStyles.textCairo(
                            context,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveUtils.fontSize(context, 14),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          foregroundColor: FlutterFlowTheme.of(context).info,
                          minimumSize: Size(double.infinity,
                              ResponsiveUtils.height(context, 45)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
