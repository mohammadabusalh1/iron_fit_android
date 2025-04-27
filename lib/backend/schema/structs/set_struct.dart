// ignore_for_file: unnecessary_getters_setters

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SetStruct extends FFFirebaseStruct {
  SetStruct({
    int? sets,
    int? reps,
    int? time,
    String? timeType,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _sets = sets,
        _reps = reps,
        _time = time,
        _timeType = timeType,
        super(firestoreUtilData);

  int? _time;
  int get time => _time ?? 0;
  set time(int? val) => _time = val;

  // "Sets" field.
  int? _sets;
  int get sets => _sets ?? 0;
  set sets(int? val) => _sets = val;

  String? _timeType;
  String get timeType => _timeType ?? 'm';
  set timeType(String? val) => _timeType = val;

  void incrementSets(int amount) => sets = sets + amount;

  bool hasSets() => _sets != null;

  // "reps" field.
  int? _reps;
  int get reps => _reps ?? 0;
  set reps(int? val) => _reps = val;

  void incrementReps(int amount) => reps = reps + amount;

  bool hasReps() => _reps != null;

  static SetStruct fromMap(Map<String, dynamic> data) => SetStruct(
        sets: castToType<int>(data['Sets']),
        reps: castToType<int>(data['reps']),
      );

  static SetStruct? maybeFromMap(dynamic data) =>
      data is Map ? SetStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'Sets': _sets,
        'reps': _reps,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Sets': serializeParam(
          _sets,
          ParamType.int,
        ),
        'reps': serializeParam(
          _reps,
          ParamType.int,
        ),
      }.withoutNulls;

  static SetStruct fromSerializableMap(Map<String, dynamic> data) => SetStruct(
        sets: deserializeParam(
          data['Sets'],
          ParamType.int,
          false,
        ),
        reps: deserializeParam(
          data['reps'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'SetStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SetStruct && sets == other.sets && reps == other.reps;
  }

  @override
  int get hashCode => const ListEquality().hash([sets, reps]);
}

SetStruct createSetStruct({
  int? sets,
  int? reps,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SetStruct(
      sets: sets,
      reps: reps,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SetStruct? updateSetStruct(
  SetStruct? set, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    set
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSetStructData(
  Map<String, dynamic> firestoreData,
  SetStruct? set,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (set == null) {
    return;
  }
  if (set.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && set.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final setData = getSetFirestoreData(set, forFieldValue);
  final nestedData = setData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = set.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSetFirestoreData(
  SetStruct? set, [
  bool forFieldValue = false,
]) {
  if (set == null) {
    return {};
  }
  final firestoreData = mapToFirestore(set.toMap());

  // Add any Firestore field values
  set.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSetListFirestoreData(
  List<SetStruct>? sets,
) =>
    sets?.map((e) => getSetFirestoreData(e, true)).toList() ?? [];
