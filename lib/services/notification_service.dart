import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Data class for notification parameters to pass to isolate
class NotificationData {
  final String title;
  final String message;
  final String channelId;
  final bool playSound;
  final bool enableVibration;

  NotificationData({
    required this.title,
    required this.message,
    required this.channelId,
    required this.playSound,
    required this.enableVibration,
  });
}

// Isolate worker function for processing notification data
Future<NotificationData> _prepareNotificationIsolate(
    NotificationData data) async {
  // Perform any heavy processing of notification data here
  // For example, you could format messages, process content, etc.
  return data;
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool isInitialized = false;

  Future<void> initializeNotification() async {
    if (isInitialized) return;
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize the plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create notification channels
    await createNotificationChannels();
    isInitialized = true;
  }

  Future<void> createNotificationChannels() async {
    const AndroidNotificationChannel silentChannel = AndroidNotificationChannel(
      'silent_channel', // ID
      'Silent Notifications', // Name
      description: 'This channel is for silent notifications.',
      importance: Importance.low, // No sound or vibration
      playSound: false,
      enableVibration: false,
    );

    const AndroidNotificationChannel soundChannel = AndroidNotificationChannel(
      'sound_channel', // ID
      'Sound Notifications', // Name
      description:
          'This channel is for notifications with sound and vibration.',
      importance: Importance.high, // Sound and vibration
      playSound: true,
      enableVibration: true,
    );

    final FlutterLocalNotificationsPlugin notificationsPlugin =
        flutterLocalNotificationsPlugin;

    final android = notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Register the channels with the system
    await android?.createNotificationChannel(silentChannel);
    await android?.createNotificationChannel(soundChannel);
  }

  Future<void> showSilentNotification(String title, String message,
      int maxProgress, int currentProgress) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'silent_channel', // Use the silent channel ID
      title,
      channelDescription: message,
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
      icon: '@drawable/ic_launcher_foreground',
      maxProgress: maxProgress,
      progress: currentProgress,
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Title
      message, // Body
      notificationDetails,
    );
  }

  Future<void> showSoundNotification(String title, String message) async {
    try {
      // Process notification data in background isolate
      final notificationData = await compute(
        _prepareNotificationIsolate,
        NotificationData(
          title: title,
          message: message,
          channelId: 'sound_channel',
          playSound: true,
          enableVibration: true,
        ),
      );

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        notificationData.channelId,
        notificationData.title,
        channelDescription: notificationData.message,
        importance: Importance.high,
        playSound: notificationData.playSound,
        enableVibration: notificationData.enableVibration,
        icon: '@drawable/ic_launcher_foreground',
      );

      final NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        1, // Notification ID
        notificationData.title,
        notificationData.message,
        notificationDetails,
      );
    } catch (e) {
      debugPrint('Error showing notification in isolate: $e');

      // Fallback to direct notification if isolate fails
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'sound_channel',
        title,
        channelDescription: message,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        icon: '@drawable/ic_launcher_foreground',
      );

      final NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        1,
        title,
        message,
        notificationDetails,
      );
    }
  }
}
