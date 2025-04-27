import 'package:flutter/foundation.dart';

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
      }
    } else {
      debugPrint('❌ ERROR: $message');
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
}
