import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ExercisesRecord extends FirestoreRecord {
  ExercisesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "gifUrl" field.
  String? _gifUrl;
  String get gifUrl => _gifUrl ?? '';
  bool hasgifUrl() => _gifUrl != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "bodyPart" field.
  String? _bodyPart;
  String get bodyPart => _bodyPart ?? '';
  bool hasbodyPart() => _bodyPart != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "isMain" field.
  bool? _isMain;
  bool get isMain => _isMain ?? false;
  bool hasIsMain() => _isMain != null;

  // "equipment" field.
  String? _equipment;
  String get equipment => _equipment ?? '';
  bool hasEquipment() => _equipment != null;

  void _initializeFields() {
    _gifUrl = snapshotData['gifUrl'] as String?;
    _name = snapshotData['name'] as String?;
    _bodyPart = snapshotData['bodyPart'] as String?;
    _id = snapshotData['id'].toString() as String?;
    _isMain = snapshotData['isMain'] as bool?;
    _equipment = snapshotData['equipment'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('exercises');

  static Stream<ExercisesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ExercisesRecord.fromSnapshot(s));

  static Future<ExercisesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ExercisesRecord.fromSnapshot(s));

  static ExercisesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ExercisesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ExercisesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ExercisesRecord._(reference, mapFromFirestore(data));

  static ExercisesRecord fromJson(Map<String, dynamic> json) {
    return ExercisesRecord._(
      
      FirebaseFirestore.instance.collection('exercises').doc(),
      mapFromFirestore({
        'gifUrl': json['gifUrl'],
        'name': json['name'],
        'bodyPart': json['bodyPart'],
        'id': json['id'].toString(),
        'isMain': json['isMain'],
        'equipment': json['equipment'],
      }),
    );
  }

  @override
  String toString() =>
      'ExercisesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ExercisesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createExercisesRecordData({
  String? gifUrl,
  String? name,
  String? bodyPart,
  String? id,
  bool? isMain,
  String? equipment,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'gifUrl': gifUrl,
      'name': name,
      'bodyPart': bodyPart,
      'id': id,
      'isMain': isMain,
      'equipment': equipment,
    }.withoutNulls,
  );

  return firestoreData;
}

class ExercisesRecordDocumentEquality implements Equality<ExercisesRecord> {
  const ExercisesRecordDocumentEquality();

  @override
  bool equals(ExercisesRecord? e1, ExercisesRecord? e2) {
    return e1?.gifUrl == e2?.gifUrl &&
        e1?.name == e2?.name &&
        e1?.bodyPart == e2?.bodyPart &&
        e1?.id == e2?.id;
  }

  @override
  int hash(ExercisesRecord? e) =>
      const ListEquality().hash([e?.gifUrl, e?.name, e?.bodyPart, e?.id]);

  @override
  bool isValidKey(Object? o) => o is ExercisesRecord;
}
