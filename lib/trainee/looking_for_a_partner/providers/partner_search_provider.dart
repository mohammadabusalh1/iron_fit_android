import 'package:flutter/material.dart';
import '../models/partner_search_models.dart';

class PartnerSearchProvider extends ChangeNotifier {
  // Availability settings
  bool _isAvailable = false;
  List<TrainingType> _preferredTrainingTypes = [];
  List<TimeOfDay> _availableTimes = [];
  String _additionalNotes = '';

  // Search filters
  List<TrainingType> _selectedTrainingTypes = [];
  String _searchQuery = '';

  // Mock data for available trainees
  List<AvailableTrainee> _availableTrainees = [];

  // Mock data for training requests
  List<TrainingRequest> _trainingRequests = [];

  // Getters
  bool get isAvailable => _isAvailable;
  List<TrainingType> get preferredTrainingTypes => _preferredTrainingTypes;
  List<TimeOfDay> get availableTimes => _availableTimes;
  String get additionalNotes => _additionalNotes;
  List<TrainingType> get selectedTrainingTypes => _selectedTrainingTypes;
  String get searchQuery => _searchQuery;
  List<AvailableTrainee> get availableTrainees => _availableTrainees;
  List<TrainingRequest> get trainingRequests => _trainingRequests;

  // Filtered trainees based on search criteria
  List<AvailableTrainee> get filteredTrainees {
    return _availableTrainees.where((trainee) {
      // Filter by search query
      final nameMatches =
          trainee.name.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter by training types if any selected
      final typeMatches = _selectedTrainingTypes.isEmpty ||
          trainee.preferredTrainingTypes
              .any((type) => _selectedTrainingTypes.contains(type));

      return nameMatches && typeMatches;
    }).toList();
  }

  // Requests by status
  List<TrainingRequest> getRequestsByStatus(RequestStatus status) {
    return _trainingRequests
        .where((request) => request.status == status)
        .toList();
  }

  // Recent requests (most recent 5)
  List<TrainingRequest> get recentRequests {
    final sorted = List<TrainingRequest>.from(_trainingRequests)
      ..sort((a, b) => b.requestDate.compareTo(a.requestDate));
    return sorted.take(5).toList();
  }

  // Methods to update availability settings
  void updateAvailability(bool isAvailable) {
    _isAvailable = isAvailable;
    notifyListeners();
  }

  void updatePreferredTrainingTypes(List<TrainingType> types) {
    _preferredTrainingTypes = types;
    notifyListeners();
  }

  void updateAvailableTimes(List<TimeOfDay> times) {
    _availableTimes = times;
    notifyListeners();
  }

  void updateAdditionalNotes(String notes) {
    _additionalNotes = notes;
    notifyListeners();
  }

  // Methods to update search filters
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSelectedTrainingTypes(List<TrainingType> types) {
    _selectedTrainingTypes = types;
    notifyListeners();
  }

  void toggleTrainingTypeFilter(TrainingType type) {
    if (_selectedTrainingTypes.contains(type)) {
      _selectedTrainingTypes.remove(type);
    } else {
      _selectedTrainingTypes.add(type);
    }
    notifyListeners();
  }

  // Method to send training request
  Future<void> sendTrainingRequest({
    required String receiverId,
    required String receiverName,
    required String receiverImageUrl,
    required TrainingType trainingType,
    required TimeOfDay trainingTime,
    required String message,
  }) async {
    // In a real app, this would make an API call
    // Mock implementation for now
    final newRequest = TrainingRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current-user-id', // Would come from authentication
      receiverId: receiverId,
      receiverName: receiverName,
      receiverImageUrl: receiverImageUrl,
      senderName: 'أنت', // Current user name
      senderImageUrl:
          'https://example.com/user-image.jpg', // Current user image
      trainingType: trainingType,
      requestDate: DateTime.now(),
      trainingTime: trainingTime,
      message: message,
      status: RequestStatus.pending,
    );

    _trainingRequests.add(newRequest);
    notifyListeners();
  }

  // Method to respond to training request
  Future<void> respondToRequest(
      String requestId, RequestStatus newStatus) async {
    // In a real app, this would make an API call
    // Mock implementation for now
    final requestIndex =
        _trainingRequests.indexWhere((request) => request.id == requestId);

    if (requestIndex != -1) {
      final request = _trainingRequests[requestIndex];
      final updatedRequest = TrainingRequest(
        id: request.id,
        senderId: request.senderId,
        receiverId: request.receiverId,
        receiverName: request.receiverName,
        receiverImageUrl: request.receiverImageUrl,
        senderName: request.senderName,
        senderImageUrl: request.senderImageUrl,
        trainingType: request.trainingType,
        requestDate: request.requestDate,
        trainingTime: request.trainingTime,
        message: request.message,
        status: newStatus,
        responseDate: DateTime.now(),
      );

      _trainingRequests[requestIndex] = updatedRequest;
      notifyListeners();
    }
  }

  // Load mock data for testing
  void loadMockData() {
    // Mock available trainees
    _availableTrainees = [
      AvailableTrainee(
        id: '1',
        name: 'أحمد محمد',
        imageUrl:
            'https://images.unsplash.com/photo-1568822617270-2c1579f8dfe2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxmaXRuZXNzJTIwbWFufGVufDB8fHx8MTcwNjYyOTk5OXww&ixlib=rb-4.0.3&q=80&w=1080',
        preferredTrainingTypes: [TrainingType.strength, TrainingType.fitness],
        experienceLevel: 'متوسط',
        availableTimes: [
          const TimeOfDay(hour: 18, minute: 0),
          const TimeOfDay(hour: 19, minute: 0),
        ],
        rating: 4.5,
        bio: 'متدرب متحمس يبحث عن شريك لتمارين القوة والعضلات.',
        gymName: 'صالة اللياقة الذهبية',
        location: 'الرياض',
      ),
      AvailableTrainee(
        id: '2',
        name: 'سارة علي',
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxmaXRuZXNzJTIwd29tYW58ZW58MHx8fHwxNzA2NjMwMDMwfDA&ixlib=rb-4.0.3&q=80&w=1080',
        preferredTrainingTypes: [TrainingType.cardio, TrainingType.yoga],
        experienceLevel: 'متقدم',
        availableTimes: [
          const TimeOfDay(hour: 7, minute: 0),
          const TimeOfDay(hour: 8, minute: 0),
        ],
        rating: 4.8,
        bio: 'مدربة لياقة محترفة تبحث عن شركاء للتمارين الصباحية.',
        gymName: 'مركز الصحة واللياقة',
        location: 'جدة',
      ),
      AvailableTrainee(
        id: '3',
        name: 'خالد عبدالله',
        imageUrl:
            'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw4fHxmaXRuZXNzJTIwbWFufGVufDB8fHx8MTcwNjYyOTk5OXww&ixlib=rb-4.0.3&q=80&w=1080',
        preferredTrainingTypes: [TrainingType.strength, TrainingType.cardio],
        experienceLevel: 'مبتدئ',
        availableTimes: [
          const TimeOfDay(hour: 20, minute: 0),
          const TimeOfDay(hour: 21, minute: 0),
        ],
        rating: 4.2,
        bio: 'متحمس للياقة البدنية وأبحث عن شخص يشجعني على الالتزام.',
        gymName: 'نادي الرياضة الحديث',
        location: 'الدمام',
      ),
    ];

    // Mock training requests
    _trainingRequests = [
      TrainingRequest(
        id: '1',
        senderId: 'current-user-id',
        receiverId: '1',
        receiverName: 'أحمد محمد',
        receiverImageUrl:
            'https://images.unsplash.com/photo-1568822617270-2c1579f8dfe2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxmaXRuZXNzJTIwbWFufGVufDB8fHx8MTcwNjYyOTk5OXww&ixlib=rb-4.0.3&q=80&w=1080',
        senderName: 'أنت',
        senderImageUrl: 'https://example.com/user-image.jpg',
        trainingType: TrainingType.strength,
        requestDate: DateTime.now().subtract(const Duration(days: 1)),
        trainingTime: const TimeOfDay(hour: 18, minute: 0),
        message: 'مرحبا، هل يمكننا التدرب معاً على تمارين القوة؟',
        status: RequestStatus.pending,
      ),
      TrainingRequest(
        id: '2',
        senderId: '2',
        receiverId: 'current-user-id',
        receiverName: 'أنت',
        receiverImageUrl: 'https://example.com/user-image.jpg',
        senderName: 'سارة علي',
        senderImageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxmaXRuZXNzJTIwd29tYW58ZW58MHx8fHwxNzA2NjMwMDMwfDA&ixlib=rb-4.0.3&q=80&w=1080',
        trainingType: TrainingType.cardio,
        requestDate: DateTime.now().subtract(const Duration(days: 2)),
        trainingTime: const TimeOfDay(hour: 7, minute: 0),
        message: 'أبحث عن شريك للتمارين الصباحية، هل أنت متاح؟',
        status: RequestStatus.accepted,
        responseDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TrainingRequest(
        id: '3',
        senderId: 'current-user-id',
        receiverId: '3',
        receiverName: 'خالد عبدالله',
        receiverImageUrl:
            'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw4fHxmaXRuZXNzJTIwbWFufGVufDB8fHx8MTcwNjYyOTk5OXww&ixlib=rb-4.0.3&q=80&w=1080',
        senderName: 'أنت',
        senderImageUrl: 'https://example.com/user-image.jpg',
        trainingType: TrainingType.strength,
        requestDate: DateTime.now().subtract(const Duration(days: 5)),
        trainingTime: const TimeOfDay(hour: 20, minute: 0),
        message: 'هل تريد أن نتدرب معاً هذا المساء؟',
        status: RequestStatus.rejected,
        responseDate: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];

    notifyListeners();
  }
}
