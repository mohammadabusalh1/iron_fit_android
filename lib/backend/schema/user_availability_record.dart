import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserAvailabilityRecord extends FirestoreRecord {
  UserAvailabilityRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "isAvailable" field.
  bool? _isAvailable;
  bool get isAvailable => _isAvailable ?? false;
  bool hasIsAvailable() => _isAvailable != null;

  // "startTime" field.
  DateTime? _startTime;
  DateTime? get startTime => _startTime;
  bool hasStartTime() => _startTime != null;

  // "endTime" field.
  DateTime? _endTime;
  DateTime? get endTime => _endTime;
  bool hasEndTime() => _endTime != null;

  // "trainingType" field.
  String? _trainingType;
  String get trainingType => _trainingType ?? '';
  bool hasTrainingType() => _trainingType != null;

  // "experienceLevel" field.
  int? _experienceLevel;
  int get experienceLevel => _experienceLevel ?? 0;
  bool hasExperienceLevel() => _experienceLevel != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _date = snapshotData['date'] as DateTime?;
    _isAvailable = snapshotData['isAvailable'] as bool?;
    _startTime = snapshotData['startTime'] as DateTime?;
    _endTime = snapshotData['endTime'] as DateTime?;
    _trainingType = snapshotData['trainingType'] as String?;
    _experienceLevel = castToType<int>(snapshotData['experienceLevel']);
    _notes = snapshotData['notes'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('userAvailability');

  static Stream<UserAvailabilityRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserAvailabilityRecord.fromSnapshot(s));

  static Future<UserAvailabilityRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserAvailabilityRecord.fromSnapshot(s));

  static UserAvailabilityRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserAvailabilityRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserAvailabilityRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserAvailabilityRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserAvailabilityRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserAvailabilityRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserAvailabilityRecordData({
  DocumentReference? user,
  DateTime? date,
  bool? isAvailable,
  DateTime? startTime,
  DateTime? endTime,
  String? trainingType,
  int? experienceLevel,
  String? notes,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'date': date,
      'isAvailable': isAvailable,
      'startTime': startTime,
      'endTime': endTime,
      'trainingType': trainingType,
      'experienceLevel': experienceLevel,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserAvailabilityRecordDocumentEquality
    implements Equality<UserAvailabilityRecord> {
  const UserAvailabilityRecordDocumentEquality();

  @override
  bool equals(UserAvailabilityRecord? e1, UserAvailabilityRecord? e2) {
    return e1?.user == e2?.user &&
        e1?.date == e2?.date &&
        e1?.isAvailable == e2?.isAvailable &&
        e1?.startTime == e2?.startTime &&
        e1?.endTime == e2?.endTime &&
        e1?.trainingType == e2?.trainingType &&
        e1?.experienceLevel == e2?.experienceLevel &&
        e1?.notes == e2?.notes &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt;
  }

  @override
  int hash(UserAvailabilityRecord? e) => const ListEquality().hash([
        e?.user,
        e?.date,
        e?.isAvailable,
        e?.startTime,
        e?.endTime,
        e?.trainingType,
        e?.experienceLevel,
        e?.notes,
        e?.createdAt,
        e?.updatedAt,
      ]);

  @override
  bool isValidKey(Object? o) => o is UserAvailabilityRecord;
}