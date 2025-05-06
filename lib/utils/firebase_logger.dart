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

  /// Log an error to Firebase Storage
  ///
  /// This will log the error both to the console and to Firebase Storage as a single text file
  static Future<String?> logErrorToFirebase(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) async {
    // First log to console
    Logger.error(message, error, stackTrace);
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

      // First try to download existing log file
      Uint8List? existingLog;
      try {
        existingLog = await downloadBytes(filePath);
      } catch (e) {
        // File may not exist yet, that's okay
        Logger.info('Creating new error log file');
      }

      // Combine existing log with new entry
      final String combinedLog = existingLog != null
          ? utf8.decode(existingLog) + logEntry.toString()
          : logEntry.toString();

      // Upload to Firebase Storage
      final result = await uploadData(
        filePath,
        Uint8List.fromList(utf8.encode(combinedLog)),
      );

      if (result != null) {
        Logger.info('Error log saved to Firebase Storage: $result');
        return result;
      } else {
        Logger.error('Failed to save error log to Firebase Storage');
        return null;
      }
    } catch (e, st) {
      // Log any errors that occur during storage (to console only)
      Logger.error('Error while saving log to Firebase Storage', e, st);
      return null;
    }
  }
}
