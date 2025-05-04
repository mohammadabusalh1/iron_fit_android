import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iron_fit/utils/logger.dart';
import 'dart:io' show Platform;

/// Helper class to handle iOS-specific notification issues
class IOSNotificationHelper {
  static final IOSNotificationHelper _instance = IOSNotificationHelper._();
  static IOSNotificationHelper get instance => _instance;
  
  IOSNotificationHelper._();
  
  /// This method helps verify and debug iOS notification issues
  Future<bool> verifyIOSNotificationsSetup(FlutterLocalNotificationsPlugin plugin) async {
    if (!Platform.isIOS) {
      return true; // Not iOS, so nothing to verify
    }
    
    try {
      Logger.info('Verifying iOS notification setup...');
      
      // Get iOS-specific implementation
      final iOSPlugin = plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      
      if (iOSPlugin == null) {
        Logger.error('Failed to resolve iOS notification plugin implementation');
        return false;
      }
      
      // Check notification settings
      // This forces iOS to show the permission dialog if not already shown
      final settings = await iOSPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
        provisional: true,
      );
      
      if (settings == false) {
        Logger.warning('iOS notification permissions denied, notifications may not work');
        // Show guidance for settings
        debugPrint('''
==============================================
📱 iOS NOTIFICATION TROUBLESHOOTING:
1. Check that notification permissions are enabled in:
   Settings > Notifications > IronFit
2. In debug mode, physical devices work better than simulators
3. Make sure you're logged in to your Apple ID in simulator
==============================================
''');
        return false;
      }
      
      Logger.info('iOS notification permissions granted, setup verified');
      return true;
    } catch (e) {
      Logger.error('Error verifying iOS notification setup', e);
      return false;
    }
  }
  
  // Test notification specifically for iOS debugging
  Future<void> sendIOSDebugNotification(FlutterLocalNotificationsPlugin plugin) async {
    if (!Platform.isIOS) {
      return; // Not iOS, don't need to test
    }
    
    try {
      Logger.info('Sending iOS debug notification...');
      
      // Create iOS-specific notification details
      const iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        badgeNumber: 1,
        interruptionLevel: InterruptionLevel.active,
      );
      
      const details = NotificationDetails(
        iOS: iOSDetails,
        android: null,
      );
      
      // Show test notification
      await plugin.show(
        999, // Unique ID for debug notification
        'iOS Debug Notification',
        'If you see this, notifications are working on iOS!',
        details,
      );
      
      Logger.info('Debug notification sent');
    } catch (e) {
      Logger.error('Error sending iOS debug notification', e);
    }
  }
} 