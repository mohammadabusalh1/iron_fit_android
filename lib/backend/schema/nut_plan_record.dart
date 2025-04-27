import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NutPlanRecord extends FirestoreRecord {
  NutPlanRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "nutPlan" field.
  NutPlanStruct? _nutPlan;
  NutPlanStruct get nutPlan => _nutPlan ?? NutPlanStruct();
  bool hasNutPlan() => _nutPlan != null;

  // "coachRef" field.
  DocumentReference? _coachRef;
  DocumentReference? get coachRef => _coachRef;
  bool hasCoachRef() => _coachRef != null;

  void _initializeFields() {
    _nutPlan = NutPlanStruct.maybeFromMap(snapshotData['nutPlan']);
    _coachRef = snapshotData['coachRef'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('nutPlan');

  static Stream<NutPlanRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NutPlanRecord.fromSnapshot(s));

  static Future<NutPlanRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NutPlanRecord.fromSnapshot(s));

  static NutPlanRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NutPlanRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NutPlanRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NutPlanRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NutPlanRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NutPlanRecord &&
      reference.path.hashCode == other.reference.path.hashCode;

  // Define the 'empty' method
  static NutPlanRecord empty() {
    return NutPlanRecord._(
      FirebaseFirestore.instance.collection('nutPlan').doc(),
      {},
    );
  }
}

Map<String, dynamic> createNutPlanRecordData({
  NutPlanStruct? nutPlan,
  DocumentReference? coachRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nutPlan': NutPlanStruct().toMap(),
      'coachRef': coachRef,
    }.withoutNulls,
  );

  // Handle nested data for "nutPlan" field.
  addNutPlanStructData(firestoreData, nutPlan, 'nutPlan');

  return firestoreData;
}

class NutPlanRecordDocumentEquality implements Equality<NutPlanRecord> {
  const NutPlanRecordDocumentEquality();

  @override
  bool equals(NutPlanRecord? e1, NutPlanRecord? e2) {
    return e1?.nutPlan == e2?.nutPlan && e1?.coachRef == e2?.coachRef;
  }

  @override
  int hash(NutPlanRecord? e) =>
      const ListEquality().hash([e?.nutPlan, e?.coachRef]);

  @override
  bool isValidKey(Object? o) => o is NutPlanRecord;
}
