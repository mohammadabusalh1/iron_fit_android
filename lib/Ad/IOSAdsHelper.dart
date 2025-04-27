import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:iron_fit/utils/logger.dart';

class IOSAdsHelper {
  static bool _initialized = false;

  static Future<void> requestTrackingAuthorization() async {
    if (!Platform.isIOS || _initialized) {
      return;
    }

    _initialized = true;

    try {
      // Check if the app can request tracking authorization
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      Logger.info('Current tracking status: $status');
      
      // If not determined, request permission
      if (status == TrackingStatus.notDetermined) {
        // Show a custom dialog before the system dialog
        await Future.delayed(const Duration(milliseconds: 600));
        final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();
        Logger.info('New tracking status: $newStatus');
      }
      
      // Get the IDFA
      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      Logger.info('IDFA: $uuid');
    } catch (e) {
      Logger.error('Failed to get tracking authorization: $e');
    }
  }
} 