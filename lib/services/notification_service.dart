import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iron_fit/utils/logger.dart';
import 'dart:io' show Platform;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // Android notification channel setup
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // same ID as in AndroidManifest
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  Future<void> initializeNotification() async {
    if (_isInitialized) {
      Logger.info('Notification service already initialized');
      return;
    }

    try {
      // Platform specific initialization
      if (Platform.isIOS) {
        await _initializeIOS();
      } else if (Platform.isAndroid) {
        await _initializeAndroid();
      }

      // Common initialization for all platforms
      final initializationSettings = InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          notificationCategories: [
            DarwinNotificationCategory(
              'basic_category',
              actions: [
                DarwinNotificationAction.plain(
                  'action_id',
                  'Action',
                ),
              ],
              options: {
                DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
              },
            )
          ],
        ),
      );

      // Initialize with robust error handling
      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          Logger.info(
              'Notification tapped: ${response.id} - ${response.payload}');
          // Handle notification tap
        },
      );

      _isInitialized = true;
      Logger.info('Notification service initialized successfully');
    } catch (e, stackTrace) {
      Logger.error('Error initializing notification service',
          error: e, stackTrace: stackTrace);
      // Don't mark as initialized so we can try again
      _isInitialized = false;
    }
  }

  Future<void> _initializeIOS() async {
    // Request permissions explicitly for iOS
    final bool? result = await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Add additional iOS setup that's needed in debug mode
    if (result == false) {
      Logger.warning('iOS notification permissions denied by user');
    } else {
      Logger.info('iOS notification permission granted: $result');

      // On debug builds, explicitly configure iOS settings
      final IOSFlutterLocalNotificationsPlugin? iOSPlugin =
          notificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iOSPlugin != null) {
        // Enable provisional notification permission - allows silent delivery even if user hasn't explicitly approved
        await iOSPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          provisional: true, // This is key for debug mode
        );
      }
    }
  }

  Future<void> _initializeAndroid() async {
    // Create notification channel for Android
    final androidImplementation =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.createNotificationChannel(_channel);
    Logger.info('Android notification channel created: ${_channel.id}');
  }

  Future<NotificationDetails> _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        badgeNumber: 1,
      ),
    );
  }

  Future<void> showSoundNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    if (!_isInitialized) {
      Logger.warning(
          'Notification service not initialized, initializing now...');
      await initializeNotification();
    }

    try {
      Logger.info('Showing notification: $title - $body');
      // For iOS debugging
      if (Platform.isIOS) {
        Logger.info(
            'Displaying iOS notification with details: id=$id, title=$title');
      }

      await notificationsPlugin.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payLoad,
      );
      Logger.info('Notification displayed successfully');
    } catch (e, stackTrace) {
      Logger.error('Failed to show notification',
          error: e, stackTrace: stackTrace);
    }
  }

  // Test method to verify notifications are working
  Future<void> testNotification() async {
    await showSoundNotification(
      title: 'Test Notification',
      body:
          'This is a test notification to verify the service is working properly.',
    );
  }

  // Special method to check iOS permission status in debug mode
  Future<bool> checkIOSPermissionStatus() async {
    if (!Platform.isIOS) {
      return true; // Not iOS
    }

    try {
      final iOSPlugin =
          notificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iOSPlugin == null) {
        Logger.error('Could not resolve iOS plugin implementation');
        return false;
      }

      // DarwinNotificationSettings has permission status info
      bool? permissionsGranted = await iOSPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
      );

      // Log the result
      if (permissionsGranted == true) {
        Logger.info('iOS notification permissions are granted');
      } else {
        Logger.warning('iOS notification permissions are NOT granted');

        // Recommend enabling provisional notifications to work around permission issues
        await iOSPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          provisional: true,
        );

        Logger.info('Requested provisional notifications as fallback');
      }

      return permissionsGranted ?? false;
    } catch (e, stackTrace) {
      Logger.error('Error checking iOS permission status',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }
}
