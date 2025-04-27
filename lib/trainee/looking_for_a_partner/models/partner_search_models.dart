import 'package:flutter/material.dart';

/// Enum for training partner types
enum TrainingType {
  strength,
  fitness,
  cardio,
  yoga,
  // Add more training types as needed
}

/// Enum for request statuses
enum RequestStatus {
  pending,
  accepted,
  rejected,
  completed,
}

/// Extension to help with training type display and color
extension TrainingTypeExtension on TrainingType {
  String get displayName {
    switch (this) {
      case TrainingType.strength:
        return 'قوة';
      case TrainingType.fitness:
        return 'لياقة';
      case TrainingType.cardio:
        return 'كارديو';
      case TrainingType.yoga:
        return 'يوجا';
    }
  }

  Color get color {
    switch (this) {
      case TrainingType.strength:
        return const Color(0xFFEB8317); // Tertiary
      case TrainingType.fitness:
        return const Color(0xFF249689); // Success
      case TrainingType.cardio:
        return const Color(0xFFF9CF58); // Warning
      case TrainingType.yoga:
        return const Color(0x4D39D2C0);
    }
  }
}

/// Extension to help with request status display and color
extension RequestStatusExtension on RequestStatus {
  String get displayName {
    switch (this) {
      case RequestStatus.pending:
        return 'معلق';
      case RequestStatus.accepted:
        return 'مقبول';
      case RequestStatus.rejected:
        return 'مرفوض';
      case RequestStatus.completed:
        return 'مكتمل';
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.pending:
        return const Color(0xFFF9CF58); // Warning
      case RequestStatus.accepted:
        return const Color(0xFF249689); // Success
      case RequestStatus.rejected:
        return const Color(0xFFFF5963); // Error
      case RequestStatus.completed:
        return const Color(0xFF57636C);
    }
  }
}

/// Model for available trainee
class AvailableTrainee {
  final String id;
  final String name;
  final String imageUrl;
  final List<TrainingType> preferredTrainingTypes;
  final String experienceLevel;
  final List<TimeOfDay> availableTimes;
  final double rating;
  final String bio;
  final String gymName;
  final String location;

  AvailableTrainee({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.preferredTrainingTypes,
    required this.experienceLevel,
    required this.availableTimes,
    required this.rating,
    required this.bio,
    required this.gymName,
    required this.location,
  });
}

/// Model for training partner request
class TrainingRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String receiverImageUrl;
  final String senderName;
  final String senderImageUrl;
  final TrainingType trainingType;
  final DateTime requestDate;
  final TimeOfDay trainingTime;
  final String message;
  final RequestStatus status;
  final DateTime? responseDate;

  TrainingRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImageUrl,
    required this.senderName,
    required this.senderImageUrl,
    required this.trainingType,
    required this.requestDate,
    required this.trainingTime,
    required this.message,
    required this.status,
    this.responseDate,
  });
}

/// Model for trainee availability settings
class AvailabilitySettings {
  final bool isAvailable;
  final List<TrainingType> preferredTrainingTypes;
  final List<TimeOfDay> availableTimes;
  final String additionalNotes;

  AvailabilitySettings({
    required this.isAvailable,
    required this.preferredTrainingTypes,
    required this.availableTimes,
    required this.additionalNotes,
  });
}
