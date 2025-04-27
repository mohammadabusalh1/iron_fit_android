import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/componants/timer/timer_model.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/services/notification_service.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/trainee/days/days_service.dart';
import 'package:iron_fit/dialogs/weight_input_dialog/weight_input_dialog_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {super.key,
      required this.day,
      required this.sets,
      required this.reps,
      this.time,
      this.onProgressUpdated});
  final int day;
  final int sets;
  final int reps;
  final int? time;
  final void Function(TraineeRecord)? onProgressUpdated;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late TimerModel _model;
  static bool isTimerRunning = false;
  late Stream<List<TraineeRecord>> _traineeStream;

  final NotificationService _notificationService = NotificationService();

  // Memoized values to prevent recalculations in build
  int? _cachedSetsRun;
  String? _cachedExerciseKey;

  // Additional cache for theme values
  late Color _cachedPrimaryColor;

  bool hasAchievement(
      List<dynamic> achievements, String type, String exerciseKey) {
    return achievements.any((achievement) =>
        achievement['type'] == type && achievement['exercise'] == exerciseKey);
  }

  bool isConsecutiveDays(List<DateTime> dates) {
    dates.sort((a, b) => a.compareTo(b));
    for (int i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays != 1) {
        return false;
      }
    }
    return true;
  }

  Future<void> updateUserProgress() async {
    try {
      // Store all localized text values before async operations
      final Map<String, dynamic> localizedTexts = {
        'weekWarrior': FFLocalizations.of(context).getText('week_warrior'),
        'weekWarriorDescription':
            FFLocalizations.of(context).getText('week_warrior_description'),
        'monthlyMaster': FFLocalizations.of(context).getText('monthly_master'),
        'monthlyMasterDescription':
            FFLocalizations.of(context).getText('monthly_master_description'),
        'centurion': FFLocalizations.of(context).getText('centurion'),
        'centurionDescription':
            FFLocalizations.of(context).getText('centurion_description'),
        'firstStep': FFLocalizations.of(context).getText('first_step'),
        'firstStepDescription':
            FFLocalizations.of(context).getText('first_step_description'),
        'repsMaster': FFLocalizations.of(context).getText('reps_master'),
        'repsMasterDescription':
            FFLocalizations.of(context).getText('reps_master_description'),
        'consistencyChampion':
            FFLocalizations.of(context).getText('consistency_champion'),
        'consistencyChampionDescription': FFLocalizations.of(context)
            .getText('consistency_champion_description'),
        'personalBest': FFLocalizations.of(context).getText('personal_best'),
        'personalBestDescription':
            FFLocalizations.of(context).getText('personal_best_description'),
      };

      _cachedExerciseKey ??= (widget.key as ValueKey<String>).value;
      final exerciseProgress =
          widget.time != 0 && widget.time! > 0 ? widget.time! : widget.reps;

      // Show weight input dialog before updating progress
      if (mounted) {
        final exerciseName = _cachedExerciseKey!.replaceAll('Keyqft_', '');
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WeightInputDialog(
            exerciseName: exerciseName,
            onWeightSubmitted: (int? weight) async {
              // Update progress with weight information

              TraineeRecord updatedTrainee =
                  await DaysService.updateUserProgress(
                      exerciseKey: _cachedExerciseKey!,
                      exerciseProgress: exerciseProgress,
                      day: widget.day,
                      localizedTexts: localizedTexts,
                      weight: weight,
                      exerciseName:
                          exerciseName // Add weight to the progress update
                      );

              // Notify parent widget about the update
              if (widget.onProgressUpdated != null) {
                widget.onProgressUpdated!(updatedTrainee);
              }
            },
          ),
        );
      }
    } catch (e, stackTrace) {
      Logger.error('Error updating user progress', e, stackTrace);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('error_general'), context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      _notificationService.initializeNotification();
      _model = TimerModel();
      _cachedExerciseKey = (widget.key as ValueKey<String>).value;
      _setupTraineeStream();
      Logger.debug('TimerWidget initialized successfully');
    } catch (e) {
      Logger.error('Error initializing TimerWidget', e);
    }
  }

  void _setupTraineeStream() {
    _traineeStream = queryTraineeRecord(
      queryBuilder: (traineeRecord) => traineeRecord.where(
        'user',
        isEqualTo: currentUserReference,
      ),
      singleRecord: true,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache theme values
    _cachedPrimaryColor = FlutterFlowTheme.of(context).primary;
  }

  @override
  void dispose() {
    super.dispose();
    _model.maybeDispose();
    isTimerRunning = false;
  }

  String getWeekdayName(int weekday) {
    const List<String> weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    const List<String> weekdaysArabic = [
      "الإثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة",
      "السبت",
      "الاحد"
    ];

    return FFLocalizations.of(context).languageCode == 'en'
        ? weekdays[weekday - 1]
        : weekdaysArabic[weekday - 1]; // Adjust index (Dart lists are 0-based)
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TraineeRecord>>(
      stream: _traineeStream,
      builder: (context, snapshot) {
        // Use cached theme values where possible
        final primary = _cachedPrimaryColor;
        final info = FlutterFlowTheme.of(context).info;
        final success = FlutterFlowTheme.of(context).success;

        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }

        List<TraineeRecord> traineeRecordList = snapshot.data!;
        if (traineeRecordList.isEmpty) {
          return const LoadingIndicator();
        }

        final traineeRecord = traineeRecordList.first;

        if (traineeRecord == null) {
          return const LoadingIndicator();
        }

        // Calculate sets run only when data changes
        _cachedExerciseKey ??= (widget.key as ValueKey<String>).value;
        final progressList = traineeRecord.dayProgress
            .where((element) => element['key'] == _cachedExerciseKey);
        _cachedSetsRun =
            progressList.isEmpty ? 0 : progressList.first['progress'];

        final bool isCompleted = ((widget.time == 0 &&
                (_cachedSetsRun! >= widget.sets * widget.reps)) ||
            (widget.time! > 0 &&
                (_cachedSetsRun! >= widget.sets * widget.time!)));

        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (isCompleted)
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: success,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(
                  Icons.check,
                  color: info,
                ),
              )
            else
              buildTime(primary, context),
          ].divide(const SizedBox(width: 8.0)),
        );
      },
    );
  }

  Widget buildTime(Color primary, BuildContext context) {
    return Row(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            try {
              if (widget.day != DateTime.now().weekday) {
                Logger.warning('User attempted to start timer on wrong day');
                if (mounted) {
                  showErrorDialog(
                      FFLocalizations.of(context).getText('warning_message') +
                          getWeekdayName(DateTime.now().weekday),
                      context);
                }
                return;
              } else if (isTimerRunning) {
                Logger.debug('Timer already running, ignoring tap');
                return;
              } else {
                // Using a single setState for all state changes
                setState(() {
                  isTimerRunning = true;
                  _model.timerController.onResetTimer();
                  _model.timerController.onStartTimer();
                });
                Logger.info('Timer started successfully');
              }
            } catch (e) {
              Logger.error('Error starting timer', e);
              if (mounted) {
                showErrorDialog(
                    FFLocalizations.of(context).getText('error_starting_timer'),
                    context);
              }
            }
          },
          child: Icon(
            Icons.not_started,
            color: primary,
            size: 32.0,
          ),
        ),
        FlutterFlowTimer(
          initialTime: _model.timerInitialTimeMs,
          getDisplayTime: (value) => StopWatchTimer.getDisplayTime(
            value,
            hours: false,
            milliSecond: false,
          ),
          controller: _model.timerController,
          updateStateInterval: const Duration(milliseconds: 1000),
          onChanged: (value, displayTime, shouldUpdate) {
            _model.timerMilliseconds = value;
            _model.timerValue = displayTime;
            if (shouldUpdate) setState(() {});
          },
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
              ),
          onEnded: () async {
            try {
              // Cache localized text before async operations
              final String timerComplete =
                  FFLocalizations.of(context).getText('timer_complete');
              final String timerCompleteDescription =
                  FFLocalizations.of(context)
                      .getText('timer_complete_description');

              _notificationService.showSoundNotification(
                timerComplete,
                timerCompleteDescription,
              );
              await updateUserProgress();
              if (mounted) {
                setState(() {
                  isTimerRunning = false;
                });
              }
              Logger.info('Timer completed successfully');
            } catch (e) {
              Logger.error('Error handling timer completion', e);
              if (mounted) {
                setState(() {
                  isTimerRunning = false;
                });
                showErrorDialog(
                    FFLocalizations.of(context).getText('error_saving_timer'),
                    context);
              }
            }
          },
        ),
      ],
    );
  }
}
