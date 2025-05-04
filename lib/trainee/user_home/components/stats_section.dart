import 'package:flutter/material.dart';
import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'stat_card.dart';
import 'progress_card.dart';
import 'streak_stat_card.dart';

class StatsSection extends StatelessWidget {
  final TraineeRecord trainee;
  final Animation<double> animation;
  final ValueNotifier<double> sourceNotifier;

  const StatsSection({
    required this.trainee,
    required this.animation,
    required this.sourceNotifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Cache the static parts of the UI to avoid rebuilding during animation
    final statsContent = _buildStatsContent(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animation.value),
          child: Opacity(
            opacity: animation.value,
            child: statsContent,
          ),
        );
      },
    );
  }

  Future<int> getActiveUserCount() async {
    final now = DateTime.now();
    final thirtyMinutesAgo = now.subtract(const Duration(minutes: 30));
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // First check if the current trainee has an active subscription
    final subscriptionQuery = await querySubscriptionsRecord(
      queryBuilder: (subscriptionsRecord) => subscriptionsRecord
          .where('trainee', isEqualTo: currentTraineeDocument!.reference)
          .where('isActive', isEqualTo: true)
          .where('isDeleted', isEqualTo: false),
      singleRecord: true,
    ).first;

    // If no active subscription, return 0 early
    if (subscriptionQuery.isEmpty) {
      return 0;
    }

    final subscription = subscriptionQuery.first;
    final coachRef = subscription.coach;

    // Query only trainees who have active sessions for this coach today
    final activeTrainees = await queryEventsRecord(
        queryBuilder: (eventsRecord) => eventsRecord
            .where('type', isEqualTo: 'session_duration')
            .where('coach', isEqualTo: coachRef)).first;

    final events = activeTrainees.where(
      (event) =>
          event.timestamp.isAfter(thirtyMinutesAgo) &&
          event.timestamp.isBefore(today),
    );

    return events.length;
  }

  Widget _buildStatsContent(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.padding(context, horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              FutureBuilder(
                  future: getActiveUserCount(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                        child: StatCard(
                          title:
                              FFLocalizations.of(context).getText('ol573pu6'),
                          value: '0',
                          unit: FFLocalizations.of(context).getText('member'),
                          icon: Icons.local_fire_department_rounded,
                        ),
                      );
                    }
                    return Expanded(
                      child: StatCard(
                        title: FFLocalizations.of(context).getText('ol573pu6'),
                        value: snapshot.data.toString(),
                        unit: FFLocalizations.of(context).getText('member'),
                        icon: Icons.local_fire_department_rounded,
                      ),
                    );
                  }),
              SizedBox(width: ResponsiveUtils.width(context, 16)),
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: sourceNotifier,
                  builder: (context, sourceValue, _) {
                    final progress = _calculateProgress(trainee);
                    return ProgressCard(
                      progress: progress,
                      total: sourceValue,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.height(context, 16)),
          StreakStatCard(
            title: FFLocalizations.of(context).getText('workout_streak'),
            value: trainee.workoutStreak.toString(),
            unit: FFLocalizations.of(context).getText('dayStreak'),
            icon: Icons.directions_walk_rounded,
            trainee: trainee,
          ),
        ],
      ),
    );
  }

  double _calculateProgress(TraineeRecord trainee) {
    double totalProgress = 0;
    try {
      if (trainee.dayProgress.isNotEmpty) {
        totalProgress = trainee.dayProgress
            .map((e) => (e['progress'] as num).toDouble())
            .fold(0.0, (a, b) => a + b);
      }
    } catch (e) {
      debugPrint('Error calculating progress: $e');
    }
    return totalProgress;
  }
}
