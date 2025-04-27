import 'package:shared_preferences/shared_preferences.dart';
import '/backend/backend.dart';
import 'package:logging/logging.dart';

class CoachHomeUtils {
  static final _logger = Logger('CoachHomeUtils');
  static const Duration cacheExpiration = Duration(minutes: 5);

  static Future<void> checkNotifications(DocumentReference coachRef) async {
    try {
      final readNotificationsRef = await FirebaseFirestore.instance
          .collection('alert')
          .where('coach', isEqualTo: coachRef)
          .get();

      final DateTime sevenDaysAgo =
          DateTime.now().subtract(const Duration(days: 7));

      for (var doc in readNotificationsRef.docs) {
        try {
          if ((doc.data()['date'] as Timestamp)
              .toDate()
              .isBefore(sevenDaysAgo)) {
            await doc.reference.delete();
          }
        } catch (docError) {
          _logger.warning(
              'Error processing notification document ${doc.id}: $docError');
          continue;
        }
      }
    } catch (e) {
      _logger.severe('Error fetching notifications: $e');
    }
  }

  static Future<DateTime?> loadLastReminderTime(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final lastReminder = prefs.getInt('last_sub_reminder_$userEmail');
    if (lastReminder != null) {
      return DateTime.fromMillisecondsSinceEpoch(lastReminder);
    }
    return null;
  }

  static Future<void> saveLastReminderTime(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'last_sub_reminder_$userEmail', DateTime.now().millisecondsSinceEpoch);
  }

  static bool shouldShowReminder(DateTime? lastReminderShown) {
    if (lastReminderShown == null) return true;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return lastReminderShown.isBefore(weekAgo);
  }

  static Future<List<SubscriptionsRecord>> getSubscriptions(
    DocumentReference coachRef,
  ) async {
    try {
      // Fetch fresh data
      final subscriptions = await querySubscriptionsRecord(
          queryBuilder: (q) => q
              .where('coach', isEqualTo: coachRef)
              .where('isDeleted', isEqualTo: false)
              .orderBy('startDate', descending: true)).first;

      final subscriptionsWithoutUnactive = subscriptions
          .where((subscription) =>
              subscription.isActive == true ||
              (subscription.isActive == false &&
                  subscription.isAnonymous == true))
          .take(2)
          .toList();

      return subscriptionsWithoutUnactive;
    } catch (e) {
      _logger.warning('Error fetching subscriptions: $e');
      return [];
    }
  }
}
