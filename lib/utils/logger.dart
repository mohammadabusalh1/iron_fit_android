import 'package:flutter/foundation.dart';
import 'firebase_logger.dart';

/// A simple logger utility for Iron Fit app
class Logger {
  /// Log an info message
  static void info(String message,
      {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras}) {
    _log('INFO', message, error: error, stackTrace: stackTrace, extras: extras);
  }

  /// Log an error message with optional exception and stack trace
  static void error(String message,
      {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras}) {
    _log('ERROR', message,
        error: error, stackTrace: stackTrace, extras: extras);
  }

  /// Log a warning message
  static void warning(String message,
      {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras}) {
    _log('WARNING', message,
        error: error, stackTrace: stackTrace, extras: extras);
  }

  /// Log a debug message
  static void debug(String message,
      {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras}) {
    _log('DEBUG', message,
        error: error, stackTrace: stackTrace, extras: extras);
  }

  static void _log(String level, String message,
      {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras}) {
    final timestamp = DateTime.now().toIso8601String();
    final logData = {
      'level': level,
      'timestamp': timestamp,
      'message': message,
      if (error != null) 'error': error.toString(),
      if (extras != null) 'extras': extras,
    };

    print('[$timestamp] $level: $message');
    if (error != null) {
      print('[$timestamp] ERROR DETAILS: $error');
      if (stackTrace != null) {
        print('[$timestamp] STACKTRACE: $stackTrace');
      }
    }
    if (extras != null) {
      print('[$timestamp] EXTRAS: $extras');
    }

    // Here you could add integrations with external logging services
    // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
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
