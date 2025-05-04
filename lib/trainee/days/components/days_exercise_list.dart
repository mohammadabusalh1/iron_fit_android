import 'package:flutter/material.dart';
import 'package:iron_fit/componants/loading_indicator/LoadingIndicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'day_card.dart';
import 'no_data_placeholder.dart';
import '/trainee/days/days_service.dart';

class DaysExerciseList extends StatefulWidget {
  final TraineeRecord traineeRecord;

  const DaysExerciseList({
    super.key,
    required this.traineeRecord,
  });

  @override
  State<DaysExerciseList> createState() => _DaysExerciseListState();
}

class _DaysExerciseListState extends State<DaysExerciseList> {
  final RefreshController _refreshController = RefreshController();
  String? _errorMessage;

  // Cache for subscription and plan data
  SubscriptionsRecord? _cachedSubscription;
  PlansRecord? _cachedPlan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch data using the DaysService
  Future<void> _fetchData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final result = await DaysService.prefetchData(widget.traineeRecord);

      if (mounted) {
        setState(() {
          _cachedSubscription = result['subscription'];
          _cachedPlan = result['plan'];
          _errorMessage = result['error'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  bool _isToday(String dayName) {
    final now = DateTime.now();
    final weekday = now.weekday;

    final dayMap = {
      'Monday': 1,
      'الاثنين': 1,
      'الإثنين': 1,
      'Tuesday': 2,
      'الثلاثاء': 2,
      'Wednesday': 3,
      'الأربعاء': 3,
      'الاربعاء': 3,
      'Thursday': 4,
      'الخميس': 4,
      'Friday': 5,
      'الجمعة': 5,
      'Saturday': 6,
      'السبت': 6,
      'Sunday': 7,
      'الاحد': 7,
      'الأحد': 7,
    };

    return dayMap[dayName] == weekday;
  }

  void _navigateToExercises(BuildContext context, PlansRecord columnPlansRecord,
      dynamic daysItem) async {
    try {
      if (!context.mounted) return;
      _errorMessage = null;

      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(
          'todayDate', dateTimeFormat('yyyy-MM-dd', DateTime.now()));

      if (!context.mounted) return;
      context.pushNamed(
        'userExercises',
        queryParameters: {
          'exercises': serializeParam(
            columnPlansRecord.plan.days
                .where((e) => e.day == daysItem.day)
                .toList()
                .first
                .exercises,
            ParamType.DataStruct,
            isList: true,
          ),
          'maxProgress': serializeParam(
            columnPlansRecord.plan.days
                .where((e) => e.day == daysItem.day)
                .toList()
                .first
                .source,
            ParamType.int,
          ),
          'day': serializeParam(
            daysItem.day == 'Saturday' || daysItem.day == 'السبت'
                ? 6
                : daysItem.day == 'Sunday' ||
                        daysItem.day == 'الاحد' ||
                        daysItem.day == 'الأحد'
                    ? 7
                    : daysItem.day == 'Monday' ||
                            daysItem.day == 'الاثنين' ||
                            daysItem.day == 'الإثنين'
                        ? 1
                        : daysItem.day == 'Tuesday' ||
                                daysItem.day == 'الثلاثاء'
                            ? 2
                            : daysItem.day == 'Wednesday' ||
                                    daysItem.day == 'الأربعاء' ||
                                    daysItem.day == 'الاربعاء'
                                ? 3
                                : daysItem.day == 'Thursday' ||
                                        daysItem.day == 'الخميس'
                                    ? 4
                                    : daysItem.day == 'Friday' ||
                                            daysItem.day == 'الجمعة'
                                        ? 5
                                        : 0,
            ParamType.int,
          ),
        }.withoutNulls,
      );
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, e.toString());
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
          ),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          title: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: FlutterFlowTheme.of(context).error,
                size: ResponsiveUtils.iconSize(context, 28),
              ),
              SizedBox(width: ResponsiveUtils.width(context, 12)),
              Expanded(
                child: Text(
                  FFLocalizations.of(context).getText('error'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 18),
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).error,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                FFLocalizations.of(context).getText('ok'),
                style: AppStyles.textCairo(
                  context,
                  color: FlutterFlowTheme.of(context).primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String errorMessage) {
    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: FlutterFlowTheme.of(context).error,
            size: ResponsiveUtils.iconSize(context, 48),
          ),
          SizedBox(height: ResponsiveUtils.height(context, 16)),
          Text(
            FFLocalizations.of(context).getText('dataLoadError'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.height(context, 8)),
          Text(
            FFLocalizations.of(context).getText('pleaseReviewYourCoach'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.height(context, 24)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _errorMessage = null;
              });
              _refreshController.requestRefresh();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              FFLocalizations.of(context).getText('2ic7dbdd'),
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).info,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _buildErrorWidget(context, _errorMessage!);
    }

    if (_isLoading) {
      return const LoadingIndicator();
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          try {
            await _fetchData(); // Refresh cached data
            _refreshController.refreshCompleted();
          } catch (e) {
            _refreshController.refreshFailed();
            setState(() {
              _errorMessage = e.toString();
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Text(
                FFLocalizations.of(context).getText(
                    'weeklyExercisesDesc') /* Your weekly exercise plan */,
                style: AppStyles.textCairo(
                  context,
                  color: FlutterFlowTheme.of(context).info.withOpacity(0.7),
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                ),
                textAlign: TextAlign.center,
              ),
              // Use cached data with fallback to StreamBuilder
              _cachedSubscription != null && _cachedPlan != null
                  ? _buildPlanContentFromCache()
                  : _buildPlanContentFromStream(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanContentFromCache() {
    if (_cachedSubscription == null || _cachedPlan == null) {
      return const NoDataPlaceholder();
    }

    try {
      final days = _cachedPlan!.plan.days.toList();
      if (days.isEmpty) {
        return const NoDataPlaceholder();
      }

      return Column(
        mainAxisSize: MainAxisSize.max,
        children: days.asMap().entries.map((entry) {
          final int index = entry.key;
          final daysItem = entry.value;
          return DayCard(
            key: ValueKey('day_${daysItem.day}_$index'),
            daysItem: daysItem,
            isToday: _isToday(daysItem.day),
            onTap: () => _navigateToExercises(
              context,
              _cachedPlan!,
              daysItem,
            ),
          );
        }).toList(),
      );
    } catch (e) {
      return _BuildErrorWidget(errorMessage: e.toString());
    }
  }

  Widget _buildPlanContentFromStream() {
    return StreamBuilder<List<SubscriptionsRecord>>(
      key: const ValueKey('subscriptions_stream'),
      stream: querySubscriptionsRecord(
        queryBuilder: (subscriptionsRecord) => subscriptionsRecord
            .where(
              'trainee',
              isEqualTo: widget.traineeRecord.reference,
            )
            .where('isActive', isEqualTo: true),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        // Handle error
        if (snapshot.hasError) {
          return _buildErrorWidget(context, snapshot.error.toString());
        }

        // Check data
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const NoDataPlaceholder();
        }

        final columnSubscriptionsRecord = snapshot.data!.first;

        // Handle null subscription plan reference
        if (columnSubscriptionsRecord.plan == null) {
          return const NoDataPlaceholder();
        }

        // Cache the subscription for future use
        _cachedSubscription = columnSubscriptionsRecord;

        return _BuildPlanContent(
          planReference: columnSubscriptionsRecord.plan!,
          isToday: _isToday,
          navigateToExercises: _navigateToExercises,
          onPlanLoaded: (plan) {
            // Cache the plan when loaded
            _cachedPlan = plan;
          },
        );
      },
    );
  }
}

class _BuildPlanContent extends StatelessWidget {
  final DocumentReference planReference;
  final bool Function(String) isToday;
  final void Function(BuildContext, PlansRecord, dynamic) navigateToExercises;
  final Function(PlansRecord)? onPlanLoaded;

  const _BuildPlanContent({
    required this.planReference,
    required this.isToday,
    required this.navigateToExercises,
    this.onPlanLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlansRecord>(
      stream: PlansRecord.getDocument(planReference),
      builder: (context, snapshot) {
        // Show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        // Handle error
        if (snapshot.hasError) {
          return _BuildErrorWidget(errorMessage: snapshot.error.toString());
        }

        // Check data
        if (!snapshot.hasData) {
          return const NoDataPlaceholder();
        }

        final columnPlansRecord = snapshot.data!;

        // Cache the plan data
        if (onPlanLoaded != null) {
          onPlanLoaded!(columnPlansRecord);
        }

        try {
          final days = columnPlansRecord.plan.days.toList();
          if (days.isEmpty) {
            return const NoDataPlaceholder();
          }

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: days.asMap().entries.map((entry) {
              final int index = entry.key;
              final daysItem = entry.value;
              return DayCard(
                key: ValueKey('day_${daysItem.day}_$index'),
                daysItem: daysItem,
                isToday: isToday(daysItem.day),
                onTap: () => navigateToExercises(
                  context,
                  columnPlansRecord,
                  daysItem,
                ),
              );
            }).toList(),
          );
        } catch (e) {
          return _BuildErrorWidget(errorMessage: e.toString());
        }
      },
    );
  }
}

class _BuildErrorWidget extends StatelessWidget {
  final String errorMessage;

  const _BuildErrorWidget({
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: FlutterFlowTheme.of(context).error,
            size: ResponsiveUtils.iconSize(context, 48),
          ),
          SizedBox(height: ResponsiveUtils.height(context, 16)),
          Text(
            FFLocalizations.of(context).getText('dataLoadError'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.height(context, 8)),
          Text(
            errorMessage,
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
