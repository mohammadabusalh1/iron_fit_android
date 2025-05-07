import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../backend/firebase_storage/storage.dart';
import 'logger.dart';

/// FirebaseLogger extends the basic Logger to save error logs to Firebase Storage
class FirebaseLogger {
  static const String _storagePath = 'error_logs';
  static const String _logFileName = 'app_errors.txt';
  static const int _maxRetries = 3;
  static const Duration _timeout = Duration(seconds: 10);

  /// Log an error to Firebase Storage
  ///
  /// This will log the error both to the console and to Firebase Storage as a single text file
  static Future<String?> logErrorToFirebase(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) async {
    // First log to console
    print('Error: $message');
    print('Error: $error');
    print('Error: $stackTrace');

    // Skip Firebase logging in debug mode to avoid unnecessary storage operations
    if (kDebugMode) {
      return null;
    }

    try {
      // Format the error log entry
      final String timestamp =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

      final StringBuffer logEntry = StringBuffer();
      logEntry.writeln('----------------------------------------');
      logEntry.writeln('Timestamp: $timestamp');
      logEntry.writeln('User ID: $userId');
      logEntry.writeln('Message: $message');
      if (error != null) {
        logEntry.writeln('Error: ${error.toString()}');
      }
      if (stackTrace != null) {
        logEntry.writeln('Stack trace: ${stackTrace.toString()}');
      }
      logEntry.writeln('----------------------------------------\n');

      final String filePath = '$_storagePath/$_logFileName';
      final Uint8List newLogData =
          Uint8List.fromList(utf8.encode(logEntry.toString()));

      // Try to upload with retries
      for (int attempt = 1; attempt <= _maxRetries; attempt++) {
        try {
          // Upload directly without downloading existing logs
          final result = await uploadData(
            filePath,
            newLogData,
          ).timeout(_timeout);

          if (result != null) {
            Logger.info('Error log saved to Firebase Storage: $result');
            return result;
          }
        } catch (e) {
          if (attempt == _maxRetries) {
            rethrow;
          }
          // Wait before retrying
          await Future.delayed(Duration(seconds: attempt));
        }
      }

      print(
          'Failed to save error log to Firebase Storage after $_maxRetries attempts');
      return null;
    } catch (e, st) {
      // Log any errors that occur during storage (to console only)
      print('Error while saving log to Firebase Storage: $e');
      print('Error while saving log to Firebase Storage: $st');
      return null;
    }
  }
}
