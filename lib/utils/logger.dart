import 'package:flutter/foundation.dart';
import 'firebase_logger.dart';

/// A simple logger utility for Iron Fit app
class Logger {
  /// Log an info message
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️ INFO: $message');
    }
  }

  /// Log an error message with optional exception and stack trace
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null) {
      debugPrint('❌ ERROR: $message\nException: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
        FirebaseLogger.logErrorToFirebase(message, error, stackTrace);
      } else {
        FirebaseLogger.logErrorToFirebase(message);
      }
    } else {
      debugPrint('❌ ERROR: $message');
      FirebaseLogger.logErrorToFirebase(message);
    }
  }

  /// Log a warning message
  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('⚠️ WARNING: $message');
    }
  }

  /// Log a debug message
  static void debug(String message) {
    if (kDebugMode) {
      debugPrint('🔍 DEBUG: $message');
    }
  }

  /// Log an error to Firebase Storage
  ///
  /// This will save the error details to a file in Firebase Storage
  /// Returns the download URL of the created file, or null if unsuccessful
  static Future<String?> logErrorToFirebase(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) async {
    return FirebaseLogger.logErrorToFirebase(message, error, stackTrace);
  }
}
