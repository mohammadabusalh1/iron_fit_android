import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/utils/logger.dart';

class DaysService {
  // Prefetches subscription and plan data for a trainee
  static Future<Map<String, dynamic>> prefetchData(
      TraineeRecord traineeRecord) async {
    Map<String, dynamic> result = {
      'subscription': null,
      'plan': null,
      'error': null,
      'isLoading': false,
    };

    try {
      result['isLoading'] = true;

      // Prefetch subscription data
      final subscriptions = await querySubscriptionsRecordOnce(
        queryBuilder: (subscriptionsRecord) => subscriptionsRecord
            .where('trainee', isEqualTo: traineeRecord.reference)
            .where('isActive', isEqualTo: true),
        singleRecord: true,
      );

      if (subscriptions.isEmpty) {
        result['isLoading'] = false;
        return result;
      }

      result['subscription'] = subscriptions.first;

      // Prefetch plan data if subscription has a plan
      if (result['subscription']?.plan != null) {
        result['plan'] =
            await PlansRecord.getDocumentOnce(result['subscription']!.plan!);
      }

      result['isLoading'] = false;
      return result;
    } catch (e) {
      result['error'] = e.toString();
      result['isLoading'] = false;
      return result;
    }
  }

  // Updates user progress for exercises
  static Future<TraineeRecord> updateUserProgress({
    required String exerciseKey,
    required int exerciseProgress,
    required int day,
    required Map<String, dynamic> localizedTexts,
    int? weight,
    String? exerciseName,
  }) async {
    try {
      Logger.debug('Starting user progress update');
      final traineeQuery = await FirebaseFirestore.instance
          .collection('trainee')
          .where(
            'user',
            isEqualTo: currentUserReference,
          )
          .get();

      if (traineeQuery.docs.isNotEmpty) {
        final traineeDoc = traineeQuery.docs.first;
        final today = day.toString();
        final currentData = traineeDoc.data();
        final now = DateTime.now();

        // Get the current dayProgress array
        List<dynamic> dayProgress = List.from(currentData['dayProgress'] ?? []);
        List<dynamic> achievements =
            List.from(currentData['achievements'] ?? []);
        List<dynamic> history = List.from(currentData['history'] ?? []);

        // Update workout streak
        final lastWorkoutDate =
            currentData['lastWorkoutDate']?.toDate() as DateTime?;
        int currentStreak = currentData['workoutStreak'] ?? 0;
        if (lastWorkoutDate != null) {
          final difference = now.difference(lastWorkoutDate).inDays;
          if (difference < 3 && difference > 0) {
            // Consecutive day workout
            currentStreak++;

            // Check for streak achievements
            if (currentStreak == 7) {
              achievements.add({
                'type': 'streak',
                'title': localizedTexts['weekWarrior'],
                'description': localizedTexts['weekWarriorDescription'],
                'date': now,
              });
              Logger.info('Achieved weekWarrior achievement: 7 day streak');
            } else if (currentStreak == 30) {
              achievements.add({
                'type': 'streak',
                'title': localizedTexts['monthlyMaster'],
                'description': localizedTexts['monthlyMasterDescription'],
                'date': now,
              });
              Logger.info('Achieved monthlyMaster achievement: 30 day streak');
            } else if (currentStreak == 100) {
              achievements.add({
                'type': 'streak',
                'title': localizedTexts['centurion'],
                'description': localizedTexts['centurionDescription'],
                'date': now,
              });
              Logger.info('Achieved centurion achievement: 100 day streak');
            }
          } else if (difference > 1) {
            // Streak broken
            currentStreak = 1;
            Logger.info(
                'Workout streak reset: $difference days since last workout');
          }
        } else {
          // First workout
          currentStreak = 1;
          // First workout achievement
          achievements.add({
            'type': 'milestone',
            'title': localizedTexts['firstStep'],
            'description': localizedTexts['firstStepDescription'],
            'date': now,
          });
          Logger.info('First workout achievement unlocked');
        }

        // Find if there's an entry for today's exercise
        int todayIndex = dayProgress.indexWhere((entry) {
          return entry['key'] == exerciseKey;
        });

        if (todayIndex != -1) {
          if (isSameDate(dayProgress[todayIndex]['time'].toDate(), now)) {
            dayProgress[todayIndex]['progress'] =
                (dayProgress[todayIndex]['progress'] ?? 0) + exerciseProgress;
          } else {
            dayProgress.removeAt(todayIndex);
            dayProgress.add({
              'key': exerciseKey,
              'day': today,
              'progress': exerciseProgress,
              'time': now,
            });
          }
        } else {
          dayProgress.add({
            'key': exerciseKey,
            'day': today,
            'progress': exerciseProgress,
            'time': now,
          });
        }

        var historyExercise = history.where(
          (element) {
            return element['key'] == exerciseKey && element['day'] == today;
          },
        );

        if (weight != null) {
          if (historyExercise.isNotEmpty) {
            if (weight > historyExercise.first['weight']) {
              historyExercise.first['weight'] = weight;
            }
          } else {
            history.add({
              'exerciseName': exerciseName,
              'key': exerciseKey,
              'day': today,
              'time': now,
              'weight': weight,
            });
          }
        }

        // Update the document with all the new data
        try {
          await traineeDoc.reference.update({
            'dayProgress': dayProgress,
            'workoutStreak': currentStreak,
            'lastWorkoutDate': now,
            'achievements': achievements,
            if (weight != null) 'history': history,
          });
          Logger.info('User progress updated successfully');

          // Return the updated trainee record
          return TraineeRecord.getDocumentFromData(
            {
              ...currentData,
              'dayProgress': dayProgress,
              'workoutStreak': currentStreak,
              'lastWorkoutDate': now,
              'achievements': achievements,
              if (weight != null) 'history': history,
            },
            traineeDoc.reference,
          );
        } catch (updateError) {
          Logger.error('Failed to update user document', updateError);
          throw Exception('Failed to update user progress');
        }
      } else {
        const error = 'No trainee document found for the current user';
        Logger.error(error);
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      Logger.error('Error updating user progress', e, stackTrace);
      throw Exception('Failed to update user progress');
    }
  }

  // Helper methods
  static bool hasAchievement(
      List<dynamic> achievements, String type, String exerciseKey) {
    return achievements.any((achievement) =>
        achievement['type'] == type && achievement['exercise'] == exerciseKey);
  }

  static bool isConsecutiveDays(List<DateTime> dates) {
    dates.sort((a, b) => a.compareTo(b));
    for (int i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays != 1) {
        return false;
      }
    }
    return true;
  }

  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
