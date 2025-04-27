import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TraineeRecord extends FirestoreRecord {
  TraineeRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  bool hasGender() => _gender != null;

  // "height" field.
  int? _height;
  int get height => _height ?? 0;
  bool hasHeight() => _height != null;

  // "weight" field.
  int? _weight;
  int get weight => _weight ?? 0;
  bool hasWeight() => _weight != null;

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "goal" field.
  String? _goal;
  String get goal => _goal ?? '';
  bool hasGoal() => _goal != null;

  // "progress" field.
  int? _progress;
  int get progress => _progress ?? 0;
  bool hasProgress() => _progress != null;

  // "coachRef" field.
  DocumentReference? _coachRef;
  DocumentReference? get coachRef => _coachRef;
  bool hasCoachRef() => _coachRef != null;

  // "dateOfBirth" field.
  DateTime? _dateOfBirth;
  DateTime get dateOfBirth => _dateOfBirth ?? DateTime(1970, 1, 1);
  bool hasDateOfBirth() => _dateOfBirth != null;

  // "dayProgress" field.
  List<dynamic>? _dayProgress;
  List<dynamic> get dayProgress => _dayProgress ?? [];
  bool hasDayProgress() => _dayProgress != null;

  // New fields for enhanced progress tracking
  // "workoutStreak" field.
  int? _workoutStreak;
  int get workoutStreak => _workoutStreak ?? 0;
  bool hasWorkoutStreak() => _workoutStreak != null;

  // "lastWorkoutDate" field.
  DateTime? _lastWorkoutDate;
  DateTime? get lastWorkoutDate => _lastWorkoutDate;
  bool hasLastWorkoutDate() => _lastWorkoutDate != null;

  // "achievements" field.
  List<dynamic>? _achievements;
  List<dynamic> get achievements => _achievements ?? [];
  bool hasAchievements() => _achievements != null;

  // "exerciseStats" field.
  Map<String, dynamic>? _exerciseStats;
  Map<String, dynamic> get exerciseStats => _exerciseStats ?? {};
  bool hasExerciseStats() => _exerciseStats != null;

  // "workoutSessions" field.
  List<dynamic>? _workoutSessions;
  List<dynamic> get workoutSessions => _workoutSessions ?? [];
  bool hasWorkoutSessions() => _workoutSessions != null;

  // "trainingTimes" field.
  String? _trainingTimes;
  String get trainingTimes => _trainingTimes ?? '';
  bool hasTrainingTimes() => _trainingTimes != null;

  // "preferredRestTime" field.
  int? _preferredRestTime;
  int get preferredRestTime => _preferredRestTime ?? 90; // Default to 1:30m
  bool hasPreferredRestTime() => _preferredRestTime != null;

  // New field for history tracking
  List<dynamic>? _history;
  List<dynamic> get history => _history ?? [];
  bool hasHistory() => _history != null;

  // New field for weight history
  List<dynamic>? _weightHistory;
  List<dynamic> get weightHistory => _weightHistory ?? [];
  bool hasWeightHistory() => _weightHistory != null;

  void _initializeFields() {
    // print('Debug: TraineeRecord: ${snapshotData['gender']}');
    _gender = snapshotData['gender'] as String?;
    _height = castToType<int>(snapshotData['height']);
    _weight = castToType<int>(snapshotData['weight']);
    _user = snapshotData['user'] as DocumentReference?;
    _goal = snapshotData['goal'] as String?;
    _progress = castToType<int>(snapshotData['progress']);
    _coachRef = snapshotData['coachRef'] as DocumentReference?;
    _dateOfBirth = castToType<DateTime>(snapshotData['dateOfBirth']);
    _dayProgress = getDataList(snapshotData['dayProgress']);
    _workoutStreak = castToType<int>(snapshotData['workoutStreak']);
    _lastWorkoutDate = castToType<DateTime>(snapshotData['lastWorkoutDate']);
    _achievements = getDataList(snapshotData['achievements']);
    _exerciseStats = snapshotData['exerciseStats'] as Map<String, dynamic>?;
    _workoutSessions = getDataList(snapshotData['workoutSessions']);
    _trainingTimes = snapshotData['trainingTimes'].toString();
    _preferredRestTime = castToType<int>(snapshotData['preferredRestTime']);
    _history = getDataList(snapshotData['history']);
    _weightHistory = getDataList(snapshotData['weightHistory']);
  }

  // Method to add a new entry to the history
  void addHistoryEntry(Map<String, dynamic> entry) {
    _history ??= [];
    _history!.add(entry);
  }

  // Method to add a new entry to the weight history
  void addWeightHistoryEntry(Map<String, dynamic> entry) {
    _weightHistory ??= [];
    _weightHistory!.add(entry);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('trainee');

  static Stream<TraineeRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TraineeRecord.fromSnapshot(s));

  static Future<TraineeRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TraineeRecord.fromSnapshot(s));

  static TraineeRecord fromSnapshot(DocumentSnapshot snapshot) {
    return TraineeRecord._(
      snapshot.reference,
      mapFromFirestore(snapshot.data() as Map<String, dynamic>),
    );
  }

  static TraineeRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TraineeRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TraineeRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TraineeRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTraineeRecordData({
  String? gender,
  int? height,
  int? weight,
  DocumentReference? user,
  String? goal,
  int? progress,
  DocumentReference? coachRef,
  DateTime? dateOfBirth,
  List<dynamic>? dayProgress,
  int? workoutStreak,
  DateTime? lastWorkoutDate,
  List<dynamic>? achievements,
  Map<String, dynamic>? exerciseStats,
  List<dynamic>? workoutSessions,
  String? trainingTimes,
  int? preferredRestTime,
  List<dynamic>? history,
  List<dynamic>? weightHistory,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'gender': gender,
      'height': height,
      'weight': weight,
      'user': user,
      'goal': goal,
      'progress': progress,
      'coachRef': coachRef,
      'dateOfBirth': dateOfBirth,
      'dayProgress': dayProgress,
      'workoutStreak': workoutStreak,
      'lastWorkoutDate': lastWorkoutDate,
      'achievements': achievements,
      'exerciseStats': exerciseStats,
      'workoutSessions': workoutSessions,
      'trainingTimes': trainingTimes,
      'preferredRestTime': preferredRestTime,
      'history': history,
      'weightHistory': weightHistory,
    }.withoutNulls,
  );

  return firestoreData;
}

class TraineeRecordDocumentEquality implements Equality<TraineeRecord> {
  const TraineeRecordDocumentEquality();

  @override
  bool equals(TraineeRecord? e1, TraineeRecord? e2) {
    return e1?.gender == e2?.gender &&
        e1?.height == e2?.height &&
        e1?.weight == e2?.weight &&
        e1?.user == e2?.user &&
        e1?.goal == e2?.goal &&
        e1?.progress == e2?.progress &&
        e1?.coachRef == e2?.coachRef &&
        e1?.dateOfBirth == e2?.dateOfBirth &&
        const DeepCollectionEquality()
            .equals(e1?.dayProgress, e2?.dayProgress) &&
        e1?.workoutStreak == e2?.workoutStreak &&
        e1?.lastWorkoutDate == e2?.lastWorkoutDate &&
        const DeepCollectionEquality()
            .equals(e1?.achievements, e2?.achievements) &&
        const DeepCollectionEquality()
            .equals(e1?.exerciseStats, e2?.exerciseStats) &&
        const DeepCollectionEquality()
            .equals(e1?.workoutSessions, e2?.workoutSessions) &&
        const DeepCollectionEquality()
            .equals(e1?.trainingTimes, e2?.trainingTimes) &&
        e1?.preferredRestTime == e2?.preferredRestTime &&
        const DeepCollectionEquality().equals(e1?.history, e2?.history) &&
        const DeepCollectionEquality()
            .equals(e1?.weightHistory, e2?.weightHistory);
  }

  @override
  int hash(TraineeRecord? e) => const ListEquality().hash([
        e?.gender,
        e?.height,
        e?.weight,
        e?.user,
        e?.goal,
        e?.progress,
        e?.coachRef,
        e?.dateOfBirth,
        e?.dayProgress,
        e?.workoutStreak,
        e?.lastWorkoutDate,
        e?.achievements,
        e?.exerciseStats,
        e?.workoutSessions,
        e?.trainingTimes,
        e?.preferredRestTime,
        e?.history,
        e?.weightHistory,
      ]);

  @override
  bool isValidKey(Object? o) => o is TraineeRecord;
}
