// ignore_for_file: avoid_types_as_parameter_names

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/logger.dart';

class ExerciseProgressCard extends StatelessWidget {
  final TraineeRecord traineeRecord;
  final int day;
  final int maxProgress;

  const ExerciseProgressCard({
    super.key,
    required this.traineeRecord,
    required this.day,
    required this.maxProgress,
  });

  @override
  Widget build(BuildContext context) {
    // Early return if day is invalid
    if (day == 0) {
      return Container();
    }

    // Cache theme values to avoid multiple context lookups
    final theme = FlutterFlowTheme.of(context);
    final primaryText = theme.primaryText;
    final primary = theme.primary;
    final primaryBackground = theme.primaryBackground;
    final secondaryBackground = theme.secondaryBackground;
    final secondaryText = theme.secondaryText;
    final info = theme.info;

    // Safely query progress list
    final progressList = traineeRecord.dayProgress
        .where((element) => element['day'] == day.toString())
        .toList();

    // Calculate progress safely
    int progress = 0;
    try {
      progress = progressList.isEmpty
          ? 0
          : progressList.fold(
              0, (sum, element) => sum + ((element['progress'] as int?) ?? 0));
    } catch (e) {
      Logger.error('Error calculating progress: $e');
      progress = 0;
    }

    // Get total workout time for the day
    int totalWorkoutTimeSeconds = 0;
    try {
      final daySessions = traineeRecord.workoutSessions
          .where((session) => session['day'] == day)
          .toList();

      if (daySessions.isNotEmpty) {
        totalWorkoutTimeSeconds = daySessions.fold(
            0,
            (sum, session) =>
                sum + ((session['durationSeconds'] as int?) ?? 0));
      }
    } catch (e) {
      Logger.error('Error calculating total workout time: $e');
    }

    // Format total workout time
    final hours = totalWorkoutTimeSeconds ~/ 3600;
    final minutes = (totalWorkoutTimeSeconds % 3600) ~/ 60;
    final seconds = totalWorkoutTimeSeconds % 60;
    final formattedTime = hours > 0
        ? '${hours}h ${minutes}m ${seconds}s'
        : '${minutes}m ${seconds}s';

    // Ensure maxProgress is valid to avoid division by zero
    final safeMaxProgress = maxProgress > 0 ? maxProgress : 1;

    // Calculate percentage safely
    final progressPercentage =
        ((progress / safeMaxProgress) * 100).clamp(0, 100).toInt();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary.withAlpha(30),
            secondaryBackground,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: secondaryText.withAlpha(30),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText('rconapdq'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${traineeRecord.workoutStreak} ${FFLocalizations.of(context).getText('dayStreak')}',
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 14,
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (totalWorkoutTimeSeconds > 0) const SizedBox(height: 4),
                    if (totalWorkoutTimeSeconds > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: primary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedTime,
                            style: AppStyles.textCairo(
                              context,
                              fontSize: 14,
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary,
                        primary.withAlpha(240),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withAlpha(90),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$progressPercentage%',
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: info,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: primaryBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 8,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  activeColor: primary,
                  inactiveColor: const Color(0xFFE0E0E0),
                  min: 0.0,
                  max: safeMaxProgress.toDouble(),
                  value:
                      math.min(progress.toDouble(), safeMaxProgress.toDouble()),
                  onChanged: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
