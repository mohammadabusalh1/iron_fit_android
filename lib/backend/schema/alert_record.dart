import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AlertRecord extends FirestoreRecord {
  AlertRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "desc" field.
  String? _desc;
  String get desc => _desc ?? '';
  bool hasDesc() => _desc != null;

  // "coach" field.
  DocumentReference? _coach;
  DocumentReference? get coach => _coach;
  bool hasCoach() => _coach != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "trainees" field.
  List<Map<String, dynamic>>? _trainees;
  List<Map<String, dynamic>> get trainees => _trainees ?? const [];
  bool hasTrainees() => _trainees != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _desc = snapshotData['desc'] as String?;
    _coach = snapshotData['coach'] as DocumentReference?;
    _date = snapshotData['date'] as DateTime?;
    _trainees = (snapshotData['trainees'] as List?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList();
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('alert');

  static Stream<AlertRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AlertRecord.fromSnapshot(s));

  static Future<AlertRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AlertRecord.fromSnapshot(s));

  static AlertRecord fromSnapshot(DocumentSnapshot snapshot) {
    return AlertRecord._(
      snapshot.reference,
      mapFromFirestore(snapshot.data() as Map<String, dynamic>),
    );
  }

  static AlertRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AlertRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AlertRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AlertRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAlertRecordData({
  String? name,
  String? desc,
  DocumentReference? coach,
  DateTime? date,
  List<Map<String, Object>>? trainees,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'desc': desc,
      'coach': coach,
      'date': date,
      'trainees': trainees,
    }.withoutNulls,
  );

  return firestoreData;
}

class AlertRecordDocumentEquality implements Equality<AlertRecord> {
  const AlertRecordDocumentEquality();

  @override
  bool equals(AlertRecord? e1, AlertRecord? e2) {
    const listEquality = ListEquality();
    return e1?.name == e2?.name &&
        e1?.desc == e2?.desc &&
        e1?.coach == e2?.coach &&
        e1?.date == e2?.date &&
        listEquality.equals(e1?.trainees, e2?.trainees);
  }

  @override
  int hash(AlertRecord? e) => const ListEquality()
      .hash([e?.name, e?.desc, e?.coach, e?.date, e?.trainees]);

  @override
  bool isValidKey(Object? o) => o is AlertRecord;
}
