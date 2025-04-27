import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlansRecord extends FirestoreRecord {
  PlansRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "plan" field.
  PlanStruct? _plan;
  PlanStruct get plan => _plan ?? PlanStruct();
  bool hasPlan() => _plan != null;

  void _initializeFields() {
    _plan = PlanStruct.maybeFromMap(snapshotData['plan']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('plans');

  static Stream<PlansRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PlansRecord.fromSnapshot(s));

  static Future<PlansRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PlansRecord.fromSnapshot(s));

  static PlansRecord fromSnapshot(DocumentSnapshot snapshot) => PlansRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PlansRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PlansRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PlansRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PlansRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPlansRecordData({
  PlanStruct? plan,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'plan': PlanStruct().toMap(),
    }.withoutNulls,
  );

  // Handle nested data for "plan" field.
  addPlanStructData(firestoreData, plan, 'plan');

  return firestoreData;
}

class PlansRecordDocumentEquality implements Equality<PlansRecord> {
  const PlansRecordDocumentEquality();

  @override
  bool equals(PlansRecord? e1, PlansRecord? e2) {
    return e1?.plan == e2?.plan;
  }

  @override
  int hash(PlansRecord? e) => const ListEquality().hash([e?.plan]);

  @override
  bool isValidKey(Object? o) => o is PlansRecord;
}
