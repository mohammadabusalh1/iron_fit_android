// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class MealStruct extends FFFirebaseStruct {
  MealStruct({
    String? name,
    String? desc,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _desc = desc,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "desc" field.
  String? _desc;
  String get desc => _desc ?? '';
  set desc(String? val) => _desc = val;

  bool hasDesc() => _desc != null;

  static MealStruct fromMap(Map<String, dynamic> data) => MealStruct(
        name: data['name'] as String?,
        desc: data['desc'] as String?,
      );

  static MealStruct? maybeFromMap(dynamic data) =>
      data is Map ? MealStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'desc': _desc,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'desc': serializeParam(
          _desc,
          ParamType.String,
        ),
      }.withoutNulls;

  static MealStruct fromSerializableMap(Map<String, dynamic> data) =>
      MealStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        desc: deserializeParam(
          data['desc'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MealStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MealStruct && name == other.name && desc == other.desc;
  }

  @override
  int get hashCode => const ListEquality().hash([name, desc]);
}

MealStruct createMealStruct({
  String? name,
  String? desc,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MealStruct(
      name: name,
      desc: desc,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MealStruct? updateMealStruct(
  MealStruct? meal, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    meal
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMealStructData(
  Map<String, dynamic> firestoreData,
  MealStruct? meal,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (meal == null) {
    return;
  }
  if (meal.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && meal.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final mealData = getMealFirestoreData(meal, forFieldValue);
  final nestedData = mealData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = meal.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMealFirestoreData(
  MealStruct? meal, [
  bool forFieldValue = false,
]) {
  if (meal == null) {
    return {};
  }
  final firestoreData = mapToFirestore(meal.toMap());

  // Add any Firestore field values
  meal.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMealListFirestoreData(
  List<MealStruct>? meals,
) =>
    meals?.map((e) => getMealFirestoreData(e, true)).toList() ?? [];
