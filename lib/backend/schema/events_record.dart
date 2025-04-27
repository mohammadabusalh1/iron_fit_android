import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EventsRecord extends FirestoreRecord {
  EventsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime get timestamp => _timestamp ?? DateTime.now();
  bool hasTimestamp() => _timestamp != null;

  // "trainee" field.
  DocumentReference? _trainee;
  DocumentReference? get trainee => _trainee;
  bool hasTrainee() => _trainee != null;

  // "coach" field.
  DocumentReference? _coach;
  DocumentReference? get coach => _coach;
  bool hasCoach() => _coach != null;

  // "data" field.
  Map<String, dynamic>? _data;
  Map<String, dynamic> get data => _data ?? {};
  bool hasData() => _data != null;

  void _initializeFields() {
    _type = snapshotData['type'] as String?;
    _timestamp = castToType<DateTime>(snapshotData['timestamp']);
    _trainee = snapshotData['trainee'] as DocumentReference?;
    _coach = snapshotData['coach'] as DocumentReference?;
    _data = castToType<Map<String, dynamic>>(snapshotData['data']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('events');

  static Stream<EventsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EventsRecord.fromSnapshot(s));

  static Future<EventsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EventsRecord.fromSnapshot(s));

  static EventsRecord fromSnapshot(DocumentSnapshot snapshot) => EventsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EventsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EventsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EventsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EventsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEventsRecordData({
  String? type,
  DateTime? timestamp,
  DocumentReference? trainee,
  DocumentReference? coach,
  Map<String, dynamic>? data,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'type': type,
      'timestamp': timestamp,
      'trainee': trainee,
      'coach': coach,
      'data': data,
    }.withoutNulls,
  );

  return firestoreData;
}

class EventsRecordDocumentEquality implements Equality<EventsRecord> {
  const EventsRecordDocumentEquality();

  @override
  bool equals(EventsRecord? e1, EventsRecord? e2) {
    return e1?.type == e2?.type &&
        e1?.timestamp == e2?.timestamp &&
        e1?.trainee == e2?.trainee &&
        e1?.coach == e2?.coach &&
        const DeepCollectionEquality().equals(e1?.data, e2?.data);
  }

  @override
  int hash(EventsRecord? e) => const ListEquality()
      .hash([e?.type, e?.timestamp, e?.trainee, e?.coach, e?.data]);

  @override
  bool isValidKey(Object? o) => o is EventsRecord;
}
