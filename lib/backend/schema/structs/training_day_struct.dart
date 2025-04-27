// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TrainingDayStruct extends FFFirebaseStruct {
  TrainingDayStruct({
    String? day,
    String? title,
    List<ExerciseStruct>? exercises,
    int? source,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _day = day,
        _title = title,
        _exercises = exercises,
        _source = source,
        super(firestoreUtilData);

  // "day" field.
  String? _day;
  String get day => _day ?? '';
  set day(String? val) => _day = val;

  bool hasDay() => _day != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "exercises" field.
  List<ExerciseStruct>? _exercises;
  List<ExerciseStruct> get exercises => _exercises ?? const [];
  set exercises(List<ExerciseStruct>? val) => _exercises = val;

  void updateExercises(Function(List<ExerciseStruct>) updateFn) {
    updateFn(_exercises ??= []);
  }

  bool hasExercises() => _exercises != null;

  // "source" field.
  int? _source;
  int get source => _source ?? 0;
  set source(int? val) => _source = val;

  static TrainingDayStruct fromMap(Map<String, dynamic> data) =>
      TrainingDayStruct(
        day: data['day'] as String?,
        title: data['title'] as String?,
        exercises: getStructList(
          data['exercises'],
          ExerciseStruct.fromMap,
        ),
        source: data['source'] as int?,
      );

  static TrainingDayStruct? maybeFromMap(dynamic data) => data is Map
      ? TrainingDayStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'day': _day,
        'title': _title,
        'exercises': _exercises?.map((e) => e.toMap()).toList(),
        'source': _source,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'day': serializeParam(
          _day,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'exercises': serializeParam(
          _exercises,
          ParamType.DataStruct,
          isList: true,
        ),
        'source': serializeParam(
          _source,
          ParamType.int,
        ),
      }.withoutNulls;

  static TrainingDayStruct fromSerializableMap(Map<String, dynamic> data) =>
      TrainingDayStruct(
        day: deserializeParam(
          data['day'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        exercises: deserializeStructParam<ExerciseStruct>(
          data['exercises'],
          ParamType.DataStruct,
          true,
          structBuilder: ExerciseStruct.fromSerializableMap,
        ),
        source: deserializeParam(
          data['source'],
          ParamType.int,
          true,
        ),
      );

  @override
  String toString() => 'TrainingDayStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is TrainingDayStruct &&
        day == other.day &&
        title == other.title &&
        listEquality.equals(exercises, other.exercises);
  }

  @override
  int get hashCode => const ListEquality().hash([day, title, exercises]);
}

TrainingDayStruct createTrainingDayStruct({
  String? day,
  String? title,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TrainingDayStruct(
      day: day,
      title: title,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TrainingDayStruct? updateTrainingDayStruct(
  TrainingDayStruct? trainingDay, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    trainingDay
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTrainingDayStructData(
  Map<String, dynamic> firestoreData,
  TrainingDayStruct? trainingDay,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (trainingDay == null) {
    return;
  }
  if (trainingDay.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && trainingDay.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final trainingDayData =
      getTrainingDayFirestoreData(trainingDay, forFieldValue);
  final nestedData =
      trainingDayData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = trainingDay.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTrainingDayFirestoreData(
  TrainingDayStruct? trainingDay, [
  bool forFieldValue = false,
]) {
  if (trainingDay == null) {
    return {};
  }
  final firestoreData = mapToFirestore(trainingDay.toMap());

  // Add any Firestore field values
  trainingDay.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTrainingDayListFirestoreData(
  List<TrainingDayStruct>? trainingDays,
) =>
    trainingDays?.map((e) => getTrainingDayFirestoreData(e, true)).toList() ??
    [];
