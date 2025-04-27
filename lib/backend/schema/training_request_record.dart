import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TrainingRequestRecord extends FirestoreRecord {
  TrainingRequestRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "senderId" field.
  DocumentReference? _senderId;
  DocumentReference? get senderId => _senderId;
  bool hasSenderId() => _senderId != null;

  // "receiverId" field.
  DocumentReference? _receiverId;
  DocumentReference? get receiverId => _receiverId;
  bool hasReceiverId() => _receiverId != null;

  // "userAvailability" field.
  DocumentReference? _userAvailability;
  DocumentReference? get userAvailability => _userAvailability;
  bool hasUserAvailability() => _userAvailability != null;

  // "status" field.
  int? _status;
  int get status => _status ?? 0;
  bool hasStatus() => _status != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _senderId = snapshotData['senderId'] as DocumentReference?;
    _receiverId = snapshotData['receiverId'] as DocumentReference?;
    _userAvailability = snapshotData['userAvailability'] as DocumentReference?;
    _status = castToType<int>(snapshotData['status']);
    _createdAt = snapshotData['createdAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('trainingRequests');

  static Stream<TrainingRequestRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TrainingRequestRecord.fromSnapshot(s));

  static Future<TrainingRequestRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TrainingRequestRecord.fromSnapshot(s));

  static TrainingRequestRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TrainingRequestRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TrainingRequestRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TrainingRequestRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TrainingRequestRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TrainingRequestRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTrainingRequestRecordData({
  DocumentReference? senderId,
  DocumentReference? receiverId,
  DocumentReference? userAvailability,
  int? status,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'userAvailability': userAvailability,
      'status': status,
      'createdAt': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class TrainingRequestRecordDocumentEquality
    implements Equality<TrainingRequestRecord> {
  const TrainingRequestRecordDocumentEquality();

  @override
  bool equals(TrainingRequestRecord? e1, TrainingRequestRecord? e2) {
    return e1?.senderId == e2?.senderId &&
        e1?.receiverId == e2?.receiverId &&
        e1?.userAvailability == e2?.userAvailability &&
        e1?.status == e2?.status &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(TrainingRequestRecord? e) => const ListEquality().hash([
        e?.senderId,
        e?.receiverId,
        e?.userAvailability,
        e?.status,
        e?.createdAt,
      ]);

  @override
  bool isValidKey(Object? o) => o is TrainingRequestRecord;
}