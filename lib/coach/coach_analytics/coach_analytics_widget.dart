import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/componants/loading_indicator/LoadingIndicator.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CoachAnalyticsCache {
  static List<SubscriptionsRecord> cachedSubscriptions = [];
  static DateTime? lastFetchTime;
  static List<TraineeRecord> cachedTrainees = [];
  static const Duration cacheValidity = Duration(minutes: 5);

  static bool get isValid {
    if (lastFetchTime == null) return false;
    return DateTime.now().difference(lastFetchTime!) < cacheValidity;
  }

  static void update(
      List<SubscriptionsRecord> subscriptions, List<TraineeRecord> trainees) {
    cachedSubscriptions = subscriptions;
    cachedTrainees = trainees;
    lastFetchTime = DateTime.now();
  }

  static void clear() {
    cachedSubscriptions = [];
    cachedTrainees = [];
    lastFetchTime = null;
  }
}

class CoachAnalyticsWidget extends StatefulWidget {
  const CoachAnalyticsWidget({super.key});

  @override
  State<CoachAnalyticsWidget> createState() => _CoachAnalyticsWidgetState();
}

class _CoachAnalyticsWidgetState extends State<CoachAnalyticsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cache data to avoid unnecessary rebuilds
  late final ValueNotifier<List<TraineeRecord>> traineeRecords =
      ValueNotifier([]);
  late final ValueNotifier<List<SubscriptionsRecord>> subscriptionsRecords =
      ValueNotifier([]);

  // Add time period state
  String selectedTimePeriod = 'all';

  @override
  void initState() {
    super.initState();
    _initializeData(true);
  }

  Future<void> _initializeData(bool useCache) async {
    if (CoachAnalyticsCache.isValid && useCache) {
      subscriptionsRecords.value = CoachAnalyticsCache.cachedSubscriptions;
      traineeRecords.value = CoachAnalyticsCache.cachedTrainees;
      return;
    }

    // Load coach data first
    if (currentUserReference == null) return;

    // Load subscriptions with time filter
    final subscriptions = await querySubscriptionsRecord(
      queryBuilder: (query) {
        var baseQuery =
            query.where('coach', isEqualTo: currentCoachDocument!.reference);

        // Apply time period filter
        if (selectedTimePeriod != 'all') {
          DateTime startDate;
          DateTime? endDate;
          final now = DateTime.now();

          switch (selectedTimePeriod) {
            case 'today':
              startDate = DateTime(now.year, now.month, now.day);
              endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
              break;
            case 'yesterday':
              final yesterday = now.subtract(const Duration(days: 1));
              startDate =
                  DateTime(yesterday.year, yesterday.month, yesterday.day);
              endDate = DateTime(
                  yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
              break;
            case 'week':
              startDate = now.subtract(Duration(days: now.weekday - 1));
              startDate =
                  DateTime(startDate.year, startDate.month, startDate.day);
              break;
            case 'lastWeek':
              final lastWeek = now.subtract(const Duration(days: 7));
              startDate =
                  lastWeek.subtract(Duration(days: lastWeek.weekday - 1));
              startDate =
                  DateTime(startDate.year, startDate.month, startDate.day);
              endDate = startDate.add(const Duration(days: 7));
              break;
            case 'month':
              startDate = DateTime(now.year, now.month, 1);
              break;
            case 'lastMonth':
              startDate = DateTime(now.year, now.month - 1, 1);
              endDate = DateTime(now.year, now.month, 1);
              break;
            case 'quarter':
              startDate = DateTime(now.year, (now.month - 1) ~/ 3 * 3 + 1, 1);
              break;
            case 'lastQuarter':
              final currentQuarter = (now.month - 1) ~/ 3;
              startDate = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
              endDate = DateTime(now.year, currentQuarter * 3 + 1, 1);
              break;
            case 'year':
              startDate = DateTime(now.year, 1, 1);
              break;
            case 'lastYear':
              startDate = DateTime(now.year - 1, 1, 1);
              endDate = DateTime(now.year, 1, 1);
              break;
            default:
              startDate = DateTime(1900); // Far past date for 'all'
          }

          baseQuery =
              baseQuery.where('startDate', isGreaterThanOrEqualTo: startDate);
          if (endDate != null) {
            baseQuery = baseQuery.where('startDate', isLessThan: endDate);
          }
        }

        return baseQuery;
      },
    ).first;

    final subscriptionsWithoutUnactive = subscriptions
        .where((subscription) =>
            subscription.isActive == true ||
            (subscription.isActive == false &&
                subscription.isAnonymous == true))
        .toList();
    // Load trainees in parallel
    final traineeFutures =
        subscriptionsWithoutUnactive.map((subscription) async {
      if (subscription.trainee == null) return null;
      return await TraineeRecord.getDocument(subscription.trainee!).first;
    });

    final traineeData = await Future.wait(traineeFutures);
    CoachAnalyticsCache.update(subscriptionsWithoutUnactive,
        traineeData.whereType<TraineeRecord>().toList());
    setState(() {
      subscriptionsRecords.value = subscriptionsWithoutUnactive;
      traineeRecords.value = traineeData.whereType<TraineeRecord>().toList();
    });
  }

  @override
  void dispose() {
    traineeRecords.dispose();
    subscriptionsRecords.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentCoachDocument == null) return const LoadingIndicator();
    return _buildMainContent(context, currentCoachDocument!);
  }

  Widget _buildMainContent(BuildContext context, CoachRecord coach) {
    final chartColors = [
      FlutterFlowTheme.of(context).primary,
      FlutterFlowTheme.of(context).tertiary,
      FlutterFlowTheme.of(context).success,
      FlutterFlowTheme.of(context).accent3,
    ];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).info.withOpacity(0.3),
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: CoachAppBar.coachAppBar(
            context,
            FFLocalizations.of(context).getText('gfyo8n2n' /* My Trainees */),
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
              onPressed: () {
                context.pushNamed('coachFeatures');
              },
            ),
            IconButton(
              icon: Icon(
                Icons.help_outline,
                color: FlutterFlowTheme.of(context).primaryText,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
              onPressed: () {
                context.pushNamed('Contact');
              },
            )),
        body: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top + ResponsiveUtils.height(context, 48)),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.5),
                FlutterFlowTheme.of(context).primaryBackground,
              ],
            ),
          ),
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => _initializeData(false),
                child: Padding(
                  padding: ResponsiveUtils.padding(context),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                        _buildTimePeriodSelector(),
                        SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                        performanceOverviewCard(coachRecord: coach),
                        SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                        ValueListenableBuilder<List<TraineeRecord>>(
                          valueListenable: traineeRecords,
                          builder: (context, trainees, _) => clientAgeChart(
                            colorsList: chartColors,
                            traineeRecords: trainees,
                            coachRecord: coach,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                        traineeStatusChart(
                          colorsList: chartColors,
                          coachRecord: coach,
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                        ValueListenableBuilder<List<SubscriptionsRecord>>(
                          valueListenable: subscriptionsRecords,
                          builder: (context, subscriptions, _) =>
                              goalTypesChart(
                            colorsList: chartColors,
                            subscriptions: subscriptions,
                            coachRecord: coach,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 100.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).withCoachNavBar(1),
    );
  }

  Widget performanceOverviewCard({
    required CoachRecord coachRecord,
    Key? key,
  }) {
    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.width(context, 20.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  FFLocalizations.of(context).getText('lknc4121'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                _buildStatisticsRow(context, coachRecord),
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(duration: const Duration(milliseconds: 600)).slideX(
          begin: -0.1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
  }

  Widget _buildStatisticsRow(BuildContext context, CoachRecord coachRecord) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAllClientsColumn(context, coachRecord),
            _buildProfitColumn(context, coachRecord),
          ],
        ),
        SizedBox(height: ResponsiveUtils.height(context, 20.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRemainingDebtColumn(context, coachRecord),
            _buildAverageRevenueColumn(context),
          ],
        ),
      ],
    );
  }

  Widget _buildAllClientsColumn(BuildContext context, CoachRecord coachRecord) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            valueOrDefault<String>(
              subscriptionsRecords.value.length.toString(),
              '0',
            ),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 32),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            FFLocalizations.of(context).getText('xvveezgw'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitColumn(BuildContext context, CoachRecord coachRecord) {
    double totalAmount = 0.0;

    try {
      // Safely filter and map the subscription records
      List<double> amounts =
          subscriptionsRecords.value.map((e) => e.amountPaid).toList();

      // Calculate the total amount safely
      totalAmount = functions.sunValues(amounts);
    } catch (e) {
      // Handle any exception that occurs during the filtering and mapping
      debugPrint('Error calculating totalAmount: $e');
    }

    // Format the amount safely
    String formattedAmount = totalAmount >= 1000
        ? '${(totalAmount / 1000).toStringAsFixed(1)}K'
        : totalAmount.toStringAsFixed(2);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            valueOrDefault<String>(
              formattedAmount,
              '0',
            ),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 32),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            FFLocalizations.of(context).getText('p0eikzd9'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingDebtColumn(
      BuildContext context, CoachRecord coachRecord) {
    final totalDebt = subscriptionsRecords.value.fold<double>(
      0,
      (sum, subscription) => sum + (subscription.debts),
    );
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            totalDebt > 1000
                ? '${(totalDebt / 1000).toStringAsFixed(1)}K'
                : totalDebt.toString(),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 32),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            FFLocalizations.of(context).getText('remainingDebt'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageRevenueColumn(BuildContext context) {
    double averageRevenue = 0.0;
    if (subscriptionsRecords.value.isNotEmpty) {
      double totalAmount = subscriptionsRecords.value
          .map((e) => e.amountPaid)
          .fold(0.0, (sum, amount) => sum + amount);
      averageRevenue = totalAmount / subscriptionsRecords.value.length;
    }

    String formattedAmount = averageRevenue >= 1000
        ? '${(averageRevenue / 1000).toStringAsFixed(1)}K'
        : averageRevenue.toStringAsFixed(2);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            valueOrDefault<String>(
              formattedAmount,
              '0',
            ),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 32),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            FFLocalizations.of(context).getText('avgRevenue'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }

  DateTime getLastDayOfMonth(DateTime date) {
    // Create a DateTime object for the first day of the next month
    DateTime firstDayOfNextMonth = DateTime(date.year, date.month + 1, 1);

    // Subtract one day to get the last day of the current month
    DateTime lastDayOfMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));

    return lastDayOfMonth;
  }

  Widget clientAgeChart({
    required List<Color> colorsList,
    required List<TraineeRecord?> traineeRecords,
    required CoachRecord coachRecord,
    Key? key,
  }) {
    Map<String, double> groupByAgeRange(List<TraineeRecord?> traineeRecords) {
      final Map<String, double> ageRangeCountMap = {
        '10-24': 0.0,
        '25-35': 0.0,
        '36-64': 0.0,
        '65+': 0.0,
        'other': 0.0
      };

      for (var record in traineeRecords) {
        if (record != null &&
            DateTime.now().year - record.dateOfBirth.year >= 10 &&
            DateTime.now().year - record.dateOfBirth.year <= 24) {
          ageRangeCountMap['10-24'] = ageRangeCountMap['10-24']! + 1;
        } else if (record != null &&
            DateTime.now().year - record.dateOfBirth.year >= 25 &&
            DateTime.now().year - record.dateOfBirth.year <= 35) {
          ageRangeCountMap['25-35'] = ageRangeCountMap['25-35']! + 1;
        } else if (record != null &&
            DateTime.now().year - record.dateOfBirth.year >= 36 &&
            DateTime.now().year - record.dateOfBirth.year <= 64) {
          ageRangeCountMap['36-64'] = ageRangeCountMap['36-64']! + 1;
        } else if (record != null &&
            DateTime.now().year - record.dateOfBirth.year >= 65) {
          ageRangeCountMap['65+'] = ageRangeCountMap['65+']! + 1;
        } else {
          ageRangeCountMap['other'] = ageRangeCountMap['other']! + 1;
        }
      }

      return ageRangeCountMap;
    }

    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.width(context, 20.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  FFLocalizations.of(context).getText('6ckgtnyk'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                Container(
                  decoration: const BoxDecoration(),
                  child: SizedBox(
                    width: ResponsiveUtils.width(context, 370.0),
                    height: ResponsiveUtils.height(context, 230.0),
                    child: traineeRecords.isEmpty
                        ? _buildNoDataWidget(context)
                        : PieChart(
                            PieChartData(
                              sections: groupByAgeRange(traineeRecords)
                                  .keys
                                  .map((title) {
                                final value =
                                    groupByAgeRange(traineeRecords)[title]!
                                        .toDouble();
                                return PieChartSectionData(
                                  value: value,
                                  title: "$title ($value)",
                                  color: colorsList[
                                      groupByAgeRange(traineeRecords)
                                              .keys
                                              .toList()
                                              .indexOf(title) %
                                          colorsList.length],
                                  radius: ResponsiveUtils.width(context, 100.0),
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fade(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
        )
        .slideX(
          begin: 0.1,
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
  }

  Widget _buildNoDataWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.bar_chart,
          size: ResponsiveUtils.iconSize(context, 48),
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
        SizedBox(height: ResponsiveUtils.height(context, 8)),
        Text(
          FFLocalizations.of(context).getText('noData'),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
      ],
    );
  }

  Widget traineeStatusChart({
    required List<Color> colorsList,
    required CoachRecord coachRecord,
    Key? key,
  }) {
    if (subscriptionsRecords.value.isEmpty) {
      return SizedBox(
        width: ResponsiveUtils.width(context, 370.0),
        height: ResponsiveUtils.height(context, 230.0),
        child: Container(
            padding: EdgeInsets.all(ResponsiveUtils.width(context, 20.0)),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(FFLocalizations.of(context).getText('traineeStatus'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 16),
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  width: ResponsiveUtils.width(context, 370.0),
                  height: ResponsiveUtils.height(context, 160.0),
                  child: _buildNoDataWidget(context),
                )
              ],
            )),
      );
    }

    int activeCount = 0;
    int inactiveCount = 0;

    try {
      // Filter for active subscriptions with null safety
      activeCount = subscriptionsRecords.value
          .where((s) => s.endDate != null && s.endDate!.isAfter(DateTime.now()))
          .length;
      inactiveCount = subscriptionsRecords.value.length - activeCount;
    } catch (e) {
      // Handle exceptions and log errors
      debugPrint('Error calculating subscription counts: $e');
    }

    // Ensure the colors list has at least two colors
    if (colorsList.length < 2) {
      debugPrint('Error: colorsList must contain at least two colors.');
      return SizedBox(
        width: ResponsiveUtils.width(context, 370.0),
        height: ResponsiveUtils.height(context, 230.0),
        child: Container(
            padding: EdgeInsets.all(ResponsiveUtils.width(context, 20.0)),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(FFLocalizations.of(context).getText('traineeStatus'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 16),
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  width: ResponsiveUtils.width(context, 370.0),
                  height: ResponsiveUtils.height(context, 160.0),
                  child: _buildNoDataWidget(context),
                )
              ],
            )),
      );
    }

    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.width(context, 20.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  FFLocalizations.of(context).getText('traineeStatus'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                SizedBox(
                  width: ResponsiveUtils.width(context, 370.0),
                  height: ResponsiveUtils.height(context, 230.0),
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: activeCount.toDouble(),
                          title:
                              '${FFLocalizations.of(context).getText('0gi3i7gz')} ($activeCount)',
                          color: colorsList[0],
                          radius: ResponsiveUtils.width(context, 100.0),
                        ),
                        PieChartSectionData(
                          value: inactiveCount.toDouble(),
                          title:
                              '${FFLocalizations.of(context).getText('inactive')} ($inactiveCount)',
                          color: colorsList[1],
                          radius: ResponsiveUtils.width(context, 100.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fade(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 400),
        )
        .slideX(
          begin: -0.1,
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
  }

  Widget goalTypesChart({
    required List<Color> colorsList,
    required List<SubscriptionsRecord?> subscriptions,
    required CoachRecord coachRecord,
    Key? key,
  }) {
    Map<String, int> groupByGoalType(List<SubscriptionsRecord?> subscriptions) {
      final Map<String, int> goalTypeCountMap = {};

      for (var record in subscriptions) {
        if (record != null) {
          goalTypeCountMap[record.goal] =
              (goalTypeCountMap[record.goal] ?? 0) + 1;
        }
      }

      return goalTypeCountMap;
    }

    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.width(context, 20.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  FFLocalizations.of(context).getText('goalTypes'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 16.0)),
                Container(
                  decoration: const BoxDecoration(),
                  child: SizedBox(
                    width: ResponsiveUtils.width(context, 370.0),
                    height: ResponsiveUtils.height(context, 230.0),
                    child: subscriptions.isEmpty
                        ? SizedBox(
                            width: ResponsiveUtils.width(context, 370.0),
                            height: ResponsiveUtils.height(context, 230.0),
                            child: _buildNoDataWidget(context),
                          )
                        : PieChart(
                            PieChartData(
                              sections: groupByGoalType(subscriptions)
                                  .entries
                                  .map((entry) {
                                    final value = entry.value.toDouble();
                                    final percentage =
                                        (value / subscriptions.length * 100)
                                            .toStringAsFixed(1);
                                    return PieChartSectionData(
                                      value: value,
                                      title: "${entry.key}\n($percentage%)",
                                      color: colorsList[
                                          groupByGoalType(subscriptions)
                                                  .keys
                                                  .toList()
                                                  .indexOf(entry.key) %
                                              colorsList.length],
                                      radius: ResponsiveUtils.width(context, 100.0),
                                    );
                                  })
                                  .toList()
                                  .take(5)
                                  .toList(),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fade(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 600),
        )
        .slideX(
          begin: 0.1,
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
  }

  Widget _buildTimePeriodSelector() {
    return Container(
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 8)),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTimePeriod,
          isExpanded: true,
          iconSize: ResponsiveUtils.iconSize(context, 24),
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, 14),
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          items: [
            DropdownMenuItem(
              value: 'all',
              child: Text(FFLocalizations.of(context).getText('allTime')),
            ),
            DropdownMenuItem(
              value: 'today',
              child: Text(FFLocalizations.of(context).getText('today')),
            ),
            DropdownMenuItem(
              value: 'yesterday',
              child: Text(FFLocalizations.of(context).getText('yesterday')),
            ),
            DropdownMenuItem(
              value: 'week',
              child: Text(FFLocalizations.of(context).getText('thisWeek')),
            ),
            DropdownMenuItem(
              value: 'lastWeek',
              child: Text(FFLocalizations.of(context).getText('lastWeek')),
            ),
            DropdownMenuItem(
              value: 'month',
              child: Text(FFLocalizations.of(context).getText('thisMonth')),
            ),
            DropdownMenuItem(
              value: 'lastMonth',
              child: Text(FFLocalizations.of(context).getText('lastMonth')),
            ),
            DropdownMenuItem(
              value: 'quarter',
              child: Text(FFLocalizations.of(context).getText('thisQuarter')),
            ),
            DropdownMenuItem(
              value: 'lastQuarter',
              child: Text(FFLocalizations.of(context).getText('lastQuarter')),
            ),
            DropdownMenuItem(
              value: 'year',
              child: Text(FFLocalizations.of(context).getText('thisYear')),
            ),
            DropdownMenuItem(
              value: 'lastYear',
              child: Text(FFLocalizations.of(context).getText('lastYear')),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedTimePeriod = value!;
              _initializeData(false); // Refresh data with new time period
            });
          },
        ),
      ),
    );
  }
}
