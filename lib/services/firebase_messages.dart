import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
    // Set Firebase Messaging background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize flutter local notifications
    await setupFlutterNotifications();

    // Request permission
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

    // Get FCM token
    final token = await _messaging.getToken();
    Logger.info('FCM Token: $token');
  }

  Future<void> _requestPermission() async {
    // Request permissions for iOS and Android
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    Logger.info('Firebase Messaging permission status: ${settings.authorizationStatus}');

    // Request additional permissions for iOS
    if (Platform.isIOS) {
      // Get APNs token for iOS
      final apnsToken = await _messaging.getAPNSToken();
      Logger.info('APNs Token: $apnsToken');
      
      // Set foreground notification presentation options for iOS
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // Android setup
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

    // iOS setup with enhanced options
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationResponse(details);
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  void _handleNotificationResponse(NotificationResponse details) {
    Logger.info('Notification clicked: ${details.payload}');
    // Handle notification clicks here
    // You can navigate to specific screens based on the payload
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? apple = message.notification?.apple;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: android != null
              ? AndroidNotificationDetails(
                  'high_importance_channel',
                  'High Importance Notifications',
                  channelDescription:
                      'This channel is used for important notifications.',
                  importance: Importance.high,
                  priority: Priority.high,
                  icon: '@mipmap/ic_launcher',
                )
              : null,
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'default',
            badgeNumber: 1,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground message
    FirebaseMessaging.onMessage.listen((message) {
      Logger.info('Received foreground message: ${message.messageId}');
      showNotification(message);
    });

    // Background/terminated message opened app
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // App was terminated and opened from notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Logger.info('App opened from terminated state via notification');
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    Logger.info('Handling background message: ${message.messageId}');
    
    // Parse notification data
    final data = message.data;
    
    // Handle different notification types
    if (data['type'] == 'chat') {
      // Navigate to chat screen with conversation ID
      // Example: navigatorKey.currentState?.pushNamed('/chat', arguments: data['conversationId']);
    } else if (data['type'] == 'workout') {
      // Navigate to workout details
      // Example: navigatorKey.currentState?.pushNamed('/workout', arguments: data['workoutId']);
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

      // Prepare payload with enhanced configurations for iOS
      final payload = {
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
              'channel_id': 'high_importance_channel',
              'priority': 'high',
              'visibility': 'public',
              'default_sound': true,
              'default_vibrate_timings': true,
            }
          },
          'apns': {
            'headers': {
              'apns-priority': '10',
            },
            'payload': {
              'aps': {
                'alert': {
                  'title': title,
                  'body': body,
                },
                'sound': 'default',
                'badge': 1,
                'content-available': 1,
                'mutable-content': 1,
                'category': 'WORKOUT_CATEGORY',
              },
            }
          }
        }
      };

      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/ironfit-edef8/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
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
      return token;
    } catch (e) {
      Logger.error('Error getting FCM token: $e');
      return null;
    }
  }
  
  /// Subscribe to a topic for receiving broadcast messages
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      Logger.info('Subscribed to topic: $topic');
    } catch (e) {
      Logger.error('Failed to subscribe to topic $topic: $e');
      rethrow;
    }
  }
  
  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      Logger.info('Unsubscribed from topic: $topic');
    } catch (e) {
      Logger.error('Failed to unsubscribe from topic $topic: $e');
      rethrow;
    }
  }
}
