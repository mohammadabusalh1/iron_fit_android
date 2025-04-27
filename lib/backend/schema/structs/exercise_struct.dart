// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ExerciseStruct extends FFFirebaseStruct {
  ExerciseStruct({
    int? reps,
    int? sets,
    int? time,
    String timeType = 'm',
    DocumentReference? ref,
    String? trainerFeedback,
    List<String>? trainerAdjustments,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _reps = reps,
        _sets = sets,
        _time = time,
        _timeType = timeType,
        _ref = ref,
        _trainerFeedback = trainerFeedback,
        _trainerAdjustments = trainerAdjustments,
        super(firestoreUtilData);

  // "time" field.
  int? _time;
  int get time => _time ?? 0;
  set time(int? val) => _time = val;

  // "reps" field.
  int? _reps;
  int get reps => _reps ?? 0;
  set reps(int? val) => _reps = val;

  String _timeType = 'm';
  String get timeType => _timeType;
  set timeType(String val) => _timeType = val;

  void incrementReps(int amount) => reps = reps + amount;

  bool hasReps() => _reps != null;

  // "sets" field.
  int? _sets;
  int get sets => _sets ?? 0;
  set sets(int? val) => _sets = val;

  void incrementSets(int amount) => sets = sets + amount;

  bool hasSets() => _sets != null;

  // "ref" field.
  DocumentReference? _ref;
  DocumentReference? get ref => _ref;
  set ref(DocumentReference? val) => _ref = val;

  bool hasRef() => _ref != null;

  // "trainerFeedback" field.
  String? _trainerFeedback;
  String get trainerFeedback => _trainerFeedback ?? '';
  set trainerFeedback(String? val) => _trainerFeedback = val;
  bool hasTrainerFeedback() => _trainerFeedback != null;

  // "trainerAdjustments" field.
  List<String>? _trainerAdjustments;
  List<String> get trainerAdjustments => _trainerAdjustments ?? const [];
  set trainerAdjustments(List<String>? val) => _trainerAdjustments = val;
  bool hasTrainerAdjustments() => _trainerAdjustments != null;

  static ExerciseStruct fromMap(Map<String, dynamic> data) => ExerciseStruct(
        reps: castToType<int>(data['reps']),
        sets: castToType<int>(data['sets']),
        time: castToType<int>(data['time']),
        timeType: data['timeType'] as String,
        ref: data['ref'] as DocumentReference?,
        trainerFeedback: data['trainerFeedback'] as String?,
        trainerAdjustments: (data['trainerAdjustments'] as List?)
            ?.map((e) => e as String)
            .toList(),
      );

  static ExerciseStruct? maybeFromMap(dynamic data) =>
      data is Map ? ExerciseStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'reps': _reps,
        'sets': _sets,
        'ref': _ref,
        'time': _time,
        'timeType': _timeType,
        'trainerFeedback': _trainerFeedback,
        'trainerAdjustments': _trainerAdjustments,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'reps': serializeParam(
          _reps,
          ParamType.int,
        ),
        'sets': serializeParam(
          _sets,
          ParamType.int,
        ),
        'ref': serializeParam(
          _ref,
          ParamType.DocumentReference,
        ),
        'time': serializeParam(
          _time,
          ParamType.int,
        ),
        'timeType': serializeParam(
          _timeType,
          ParamType.String,
        ),
        'trainerFeedback': serializeParam(
          _trainerFeedback,
          ParamType.String,
        ),
        'trainerAdjustments': serializeParam(
          _trainerAdjustments,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static ExerciseStruct fromSerializableMap(Map<String, dynamic> data) =>
      ExerciseStruct(
        reps: deserializeParam(
          data['reps'],
          ParamType.int,
          false,
        ),
        sets: deserializeParam(
          data['sets'],
          ParamType.int,
          false,
        ),
        ref: deserializeParam(
          data['ref'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['exercises'],
        ),
        time: deserializeParam(
          data['time'],
          ParamType.int,
          false,
        ),
        timeType: deserializeParam(
          data['timeType'],
          ParamType.String,
          false,
        ),
        trainerFeedback: deserializeParam(
          data['trainerFeedback'],
          ParamType.String,
          false,
        ),
        trainerAdjustments: deserializeParam<String>(
          data['trainerAdjustments'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'ExerciseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ExerciseStruct &&
        reps == other.reps &&
        sets == other.sets &&
        ref == other.ref &&
        time == other.time &&
        timeType == other.timeType &&
        trainerFeedback == other.trainerFeedback &&
        listEquality.equals(trainerAdjustments, other.trainerAdjustments);
  }

  @override
  int get hashCode =>
      reps.hashCode ^ sets.hashCode ^ ref.hashCode ^ time.hashCode;

  // Add copyWith method
  ExerciseStruct copyWith({
    int? reps,
    int? sets,
    int? time,
    String timeType = 'm',
    DocumentReference? ref,
    String? trainerFeedback,
    List<String>? trainerAdjustments,
  }) {
    return ExerciseStruct(
      reps: reps ?? this.reps,
      sets: sets ?? this.sets,
      time: time ?? this.time,
      timeType: timeType,
      ref: ref ?? this.ref,
      trainerFeedback: trainerFeedback ?? this.trainerFeedback,
      trainerAdjustments: trainerAdjustments ?? this.trainerAdjustments,
      firestoreUtilData: firestoreUtilData,
    );
  }

  Map<String, dynamic> toJson() => {
        'reps': _reps,
        'sets': _sets,
        'time': _time,
        'timeType': _timeType,
        'ref': _ref?.path,
      }.withoutNulls;
}

ExerciseStruct createExerciseStruct({
  int? reps,
  int? sets,
  DocumentReference? ref,
  int? time,
  String timeType = 'm',
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ExerciseStruct(
      reps: reps,
      sets: sets,
      ref: ref,
      time: time,
      timeType: timeType,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ExerciseStruct? updateExerciseStruct(
  ExerciseStruct? exercise, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    exercise
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addExerciseStructData(
  Map<String, dynamic> firestoreData,
  ExerciseStruct? exercise,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (exercise == null) {
    return;
  }
  if (exercise.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && exercise.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final exerciseData = getExerciseFirestoreData(exercise, forFieldValue);
  final nestedData = exerciseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = exercise.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getExerciseFirestoreData(
  ExerciseStruct? exercise, [
  bool forFieldValue = false,
]) {
  if (exercise == null) {
    return {};
  }
  final firestoreData = mapToFirestore(exercise.toMap());

  // Add any Firestore field values
  exercise.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getExerciseListFirestoreData(
  List<ExerciseStruct>? exercises,
) =>
    exercises?.map((e) => getExerciseFirestoreData(e, true)).toList() ?? [];
