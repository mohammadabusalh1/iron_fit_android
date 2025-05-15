import 'package:flutter/material.dart';
import 'package:iron_fit/services/notification_service.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/ios_notification_helper.dart';
import 'dart:io' show Platform;

class NotificationTestWidget extends StatelessWidget {
  final NotificationService notificationService = NotificationService();

  NotificationTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notification Troubleshooter',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${Platform.isIOS ? "iOS" : "Android"} Device Detected',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await notificationService.initializeNotification();

                  if (Platform.isIOS) {
                    // Additional iOS-specific verification
                    final verified = await IOSNotificationHelper.instance
                        .verifyIOSNotificationsSetup(
                            notificationService.notificationsPlugin);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(verified
                            ? 'iOS notification service initialized successfully'
                            : 'iOS notification permissions issue - check settings'),
                        backgroundColor:
                            verified ? Colors.green : Colors.orange,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Notification service initialized')),
                    );
                  }
                } catch (e, stackTrace) {
                  Logger.error('Error initializing notifications',
                      error: e, stackTrace: stackTrace);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Initialize Notifications'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Special iOS debug mode test
                  if (Platform.isIOS) {
                    await IOSNotificationHelper.instance
                        .sendIOSDebugNotification(
                            notificationService.notificationsPlugin);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'iOS Debug notification sent - check notification center'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  } else {
                    await notificationService.testNotification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Test notification sent')),
                    );
                  }
                } catch (e, stackTrace) {
                  Logger.error('Error sending test notification',
                      error: e, stackTrace: stackTrace);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Send Test Notification'),
            ),
            if (Platform.isIOS) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('iOS Notification Troubleshooting'),
                      content: const SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '1. Ensure notification permissions are enabled:'),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child:
                                  Text('• Settings > Notifications > IronFit'),
                            ),
                            SizedBox(height: 8),
                            Text('2. In debug mode:'),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                  '• Physical devices work better than simulators\n• Simulator needs Apple ID signed in\n• Restart app after granting permissions'),
                            ),
                            SizedBox(height: 8),
                            Text(
                                '3. Check that your app is in the foreground when testing'),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('iOS Troubleshooting Guide'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Note: On iOS, make sure notifications are enabled in device settings for this app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
