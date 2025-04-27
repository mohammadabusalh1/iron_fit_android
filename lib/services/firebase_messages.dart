import 'dart:async';
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:flutter/services.dart' show rootBundle;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseNotificationService.instance.setupFlutterNotifications();
  await FirebaseNotificationService.instance.showNotification(message);
}

class FirebaseNotificationService {
  FirebaseNotificationService._();
  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;
  String? _cachedAccessToken;
  DateTime? _tokenExpiry;
  Map<String, dynamic>? _serviceAccountJson;

  // Load service account credentials from file
  Future<Map<String, dynamic>> _loadServiceAccountCredentials() async {
    if (_serviceAccountJson != null) {
      return _serviceAccountJson!;
    }

    try {
      final jsonString =
          await rootBundle.loadString('assets/service_account.json');
      _serviceAccountJson = json.decode(jsonString) as Map<String, dynamic>;
      return _serviceAccountJson!;
    } catch (e) {
      Logger.error('Error loading service account credentials: $e');
      throw Exception(
          'Failed to load service_account.json from assets. Please ensure the file exists in assets/service_account.json and is properly configured in pubspec.yaml');
    }
  }

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

    // Get FCM token
    // final token = await _messaging.getToken();
    // print('FCM Token: $token');
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    Logger.info('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // android setup
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios setup
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      // open chat screen
    }
  }

  /// Generate an access token using service account credentials
  Future<String> _getAccessToken() async {
    try {
      // Return cached token if it's still valid
      if (_cachedAccessToken != null &&
          _tokenExpiry != null &&
          DateTime.now().isBefore(_tokenExpiry!)) {
        return _cachedAccessToken!;
      }

      // Load credentials from file
      final serviceAccountCredentials = await _loadServiceAccountCredentials();

      // Create credentials from service account
      final credentials =
          ServiceAccountCredentials.fromJson(serviceAccountCredentials);

      // Get the access token with FCM scope
      final client = await clientViaServiceAccount(
        credentials,
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      _cachedAccessToken = client.credentials.accessToken.data;
      _tokenExpiry = client.credentials.accessToken.expiry;

      // Close the client to prevent memory leaks
      client.close();

      return _cachedAccessToken!;
    } catch (e) {
      Logger.error('Error generating access token: $e');
      rethrow;
    }
  }

  /// Send push notification to a specific device using FCM token
  Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final accessToken = await _getAccessToken();

      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/ironfit-edef8/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body,
            },
            'data': data ?? {},
            'android': {
              'notification': {
                'icon': '@mipmap/ic_launcher',
                'channel_id': 'high_importance_channel'
              }
            },
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'default',
                  'badge': 1,
                }
              }
            }
          }
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send push notification: ${response.body}');
      }

      Logger.info('Push notification sent successfully');
    } catch (e) {
      Logger.error('Error sending push notification: $e');
      rethrow;
    }
  }

  /// Get the current device FCM token
  Future<String?> getFcmToken() async {
    try {
      final token = await _messaging.getToken();
      Logger.info('FCM Token: $token');
      return token;
    } catch (e) {
      Logger.error('Error getting FCM token: $e');
      return null;
    }
  }
}
