// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NutPlanStruct extends FFFirebaseStruct {
  NutPlanStruct({
    String? name,
    int? numOfWeeks,
    int? protein,
    int? carbs,
    int? fats,
    List<MealStruct>? meals,
    String? nots,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
    int? calories,
  })  : _name = name,
        _numOfWeeks = numOfWeeks,
        _protein = protein,
        _carbs = carbs,
        _fats = fats,
        _meals = meals,
        _nots = nots,
        _calories = calories,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "numOfWeeks" field.
  int? _numOfWeeks;
  int get numOfWeeks => _numOfWeeks ?? 0;
  set numOfWeeks(int? val) => _numOfWeeks = val;

  void incrementNumOfWeeks(int amount) => numOfWeeks = numOfWeeks + amount;

  bool hasNumOfWeeks() => _numOfWeeks != null;

  // "protein" field.
  int? _protein;
  int get protein => _protein ?? 0;
  set protein(int? val) => _protein = val;

  void incrementProtein(int amount) => protein = protein + amount;

  bool hasProtein() => _protein != null;

  // "Carbs" field.
  int? _carbs;
  int get carbs => _carbs ?? 0;
  set carbs(int? val) => _carbs = val;

  void incrementCarbs(int amount) => carbs = carbs + amount;

  bool hasCarbs() => _carbs != null;

  // "fats" field.
  int? _fats;
  int get fats => _fats ?? 0;
  set fats(int? val) => _fats = val;

  void incrementFats(int amount) => fats = fats + amount;

  bool hasFats() => _fats != null;

  // "meals" field.
  List<MealStruct>? _meals;
  List<MealStruct> get meals => _meals ?? const [];
  set meals(List<MealStruct>? val) => _meals = val;

  void updateMeals(Function(List<MealStruct>) updateFn) {
    updateFn(_meals ??= []);
  }

  bool hasMeals() => _meals != null;

  // "nots" field.
  String? _nots;
  String get nots => _nots ?? '';
  set nots(String? val) => _nots = val;

  bool hasNots() => _nots != null;

  // "calories" field.
  int? _calories;
  int get calories => _calories ?? 0;
  set calories(int? val) => _calories = val;

  bool hasCalories() => _calories != null;

  static NutPlanStruct fromMap(Map<String, dynamic> data) => NutPlanStruct(
        name: data['name'] as String?,
        numOfWeeks: castToType<int>(data['numOfWeeks']),
        protein: castToType<int>(data['protein']),
        carbs: castToType<int>(data['Carbs']),
        fats: castToType<int>(data['fats']),
        meals: getStructList(
          data['meals'],
          MealStruct.fromMap,
        ),
        nots: data['nots'] as String?,
        calories: castToType<int>(data['calories']),
      );

  static NutPlanStruct? maybeFromMap(dynamic data) =>
      data is Map ? NutPlanStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'numOfWeeks': _numOfWeeks,
        'protein': _protein,
        'Carbs': _carbs,
        'fats': _fats,
        'meals': _meals?.map((e) => e.toMap()).toList(),
        'nots': _nots,
        'calories': _calories,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'numOfWeeks': serializeParam(
          _numOfWeeks,
          ParamType.int,
        ),
        'protein': serializeParam(
          _protein,
          ParamType.int,
        ),
        'Carbs': serializeParam(
          _carbs,
          ParamType.int,
        ),
        'fats': serializeParam(
          _fats,
          ParamType.int,
        ),
        'meals': serializeParam(
          _meals,
          ParamType.DataStruct,
          isList: true,
        ),
        'nots': serializeParam(
          _nots,
          ParamType.String,
        ),
        'calories': serializeParam(
          _calories,
          ParamType.int,
        ),
      }.withoutNulls;

  static NutPlanStruct fromSerializableMap(Map<String, dynamic> data) =>
      NutPlanStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        numOfWeeks: deserializeParam(
          data['numOfWeeks'],
          ParamType.int,
          false,
        ),
        protein: deserializeParam(
          data['protein'],
          ParamType.int,
          false,
        ),
        carbs: deserializeParam(
          data['Carbs'],
          ParamType.int,
          false,
        ),
        fats: deserializeParam(
          data['fats'],
          ParamType.int,
          false,
        ),
        meals: deserializeStructParam<MealStruct>(
          data['meals'],
          ParamType.DataStruct,
          true,
          structBuilder: MealStruct.fromSerializableMap,
        ),
        nots: deserializeParam(
          data['nots'],
          ParamType.String,
          false,
        ),
        calories: deserializeParam(
          data['calories'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'NutPlanStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is NutPlanStruct &&
        name == other.name &&
        numOfWeeks == other.numOfWeeks &&
        protein == other.protein &&
        carbs == other.carbs &&
        fats == other.fats &&
        listEquality.equals(meals, other.meals) &&
        nots == other.nots &&
        calories == other.calories;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([name, numOfWeeks, protein, carbs, fats, meals, nots, calories]);
}

NutPlanStruct createNutPlanStruct({
  String? name,
  int? numOfWeeks,
  int? protein,
  int? carbs,
  int? fats,
  String? nots,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
  int? calories,
}) =>
    NutPlanStruct(
      name: name,
      numOfWeeks: numOfWeeks,
      protein: protein,
      carbs: carbs,
      fats: fats,
      nots: nots,
      calories: calories,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

NutPlanStruct? updateNutPlanStruct(
  NutPlanStruct? nutPlan, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    nutPlan
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addNutPlanStructData(
  Map<String, dynamic> firestoreData,
  NutPlanStruct? nutPlan,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (nutPlan == null) {
    return;
  }
  if (nutPlan.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && nutPlan.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final nutPlanData = getNutPlanFirestoreData(nutPlan, forFieldValue);
  final nestedData = nutPlanData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = nutPlan.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getNutPlanFirestoreData(
  NutPlanStruct? nutPlan, [
  bool forFieldValue = false,
]) {
  if (nutPlan == null) {
    return {};
  }
  final firestoreData = mapToFirestore(nutPlan.toMap());

  // Add any Firestore field values
  nutPlan.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getNutPlanListFirestoreData(
  List<NutPlanStruct>? nutPlans,
) =>
    nutPlans?.map((e) => getNutPlanFirestoreData(e, true)).toList() ?? [];
