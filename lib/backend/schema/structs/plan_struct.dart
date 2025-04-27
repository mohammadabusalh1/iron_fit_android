// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlanStruct extends FFFirebaseStruct {
  PlanStruct({
    String? name,
    String? level,
    DocumentReference? coach,
    DateTime? createdAt,
    String? description,
    bool? draft,
    List<TrainingDayStruct>? days,
    String? type,
    int? totalSource,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _level = level,
        _coach = coach,
        _createdAt = createdAt,
        _description = description,
        _draft = draft,
        _days = days,
        _type = type,
        _totalSource = totalSource,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "level" field.
  String? _level;
  String get level => _level ?? '';
  set level(String? val) => _level = val;

  bool hasLevel() => _level != null;

  // "coach" field.
  DocumentReference? _coach;
  DocumentReference? get coach => _coach;
  set coach(DocumentReference? val) => _coach = val;

  bool hasCoach() => _coach != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "draft" field.
  bool? _draft;
  bool get draft => _draft ?? false;
  set draft(bool? val) => _draft = val;

  bool hasDraft() => _draft != null;

  // "days" field.
  List<TrainingDayStruct>? _days;
  List<TrainingDayStruct> get days => _days ?? const [];
  set days(List<TrainingDayStruct>? val) => _days = val;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  void updateDays(Function(List<TrainingDayStruct>) updateFn) {
    updateFn(_days ??= []);
  }

  bool hasDays() => _days != null;

  // "totalSource" field.
  int? _totalSource;
  int get totalSource => _totalSource ?? 0;
  set totalSource(int? val) => _totalSource = val;

  static PlanStruct fromMap(Map<String, dynamic> data) => PlanStruct(
        name: data['name'] as String?,
        level: data['level'] as String?,
        coach: data['coach'] as DocumentReference?,
        createdAt: data['createdAt'] as DateTime?,
        description: data['description'] as String?,
        draft: data['draft'] as bool?,
        days: getStructList(
          data['days'],
          TrainingDayStruct.fromMap,
        ),
        type: data['type'] as String?,
        totalSource: data['totalSource'] as int?,
      );

  static PlanStruct? maybeFromMap(dynamic data) =>
      data is Map ? PlanStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'level': _level,
        'coach': _coach,
        'createdAt': _createdAt,
        'description': _description,
        'draft': _draft,
        'days': _days?.map((e) => e.toMap()).toList(),
        'type': _type,
        'totalSource': _totalSource,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'level': serializeParam(
          _level,
          ParamType.String,
        ),
        'coach': serializeParam(
          _coach,
          ParamType.DocumentReference,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'draft': serializeParam(
          _draft,
          ParamType.bool,
        ),
        'days': serializeParam(
          _days,
          ParamType.DataStruct,
          isList: true,
        ),
        'type': _type,
        'totalSource': serializeParam(
          _totalSource,
          ParamType.int,
        ),
      }.withoutNulls;

  static PlanStruct fromSerializableMap(Map<String, dynamic> data) =>
      PlanStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        level: deserializeParam(
          data['level'],
          ParamType.String,
          false,
        ),
        coach: deserializeParam(
          data['coach'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['coach'],
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        draft: deserializeParam(
          data['draft'],
          ParamType.bool,
          false,
        ),
        days: deserializeStructParam<TrainingDayStruct>(
          data['days'],
          ParamType.DataStruct,
          true,
          structBuilder: TrainingDayStruct.fromSerializableMap,
        ),
        type: data['type'] as String?,
        totalSource: deserializeParam(
          data['totalSource'],
          ParamType.int,
          true,
        ),
      );

  @override
  String toString() => 'PlanStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PlanStruct &&
        name == other.name &&
        level == other.level &&
        coach == other.coach &&
        createdAt == other.createdAt &&
        description == other.description &&
        draft == other.draft &&
        listEquality.equals(days, other.days) &&
        type == other.type &&
        totalSource == other.totalSource;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([name, level, coach, createdAt, description, draft, days, totalSource]);
}

PlanStruct createPlanStruct({
  String? name,
  String? level,
  DocumentReference? coach,
  DateTime? createdAt,
  String? description,
  bool? draft,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
  String? type,
}) =>
    PlanStruct(
      name: name,
      level: level,
      coach: coach,
      createdAt: createdAt,
      description: description,
      draft: draft,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
      type: type,
    );

PlanStruct? updatePlanStruct(
  PlanStruct? plan, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    plan
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPlanStructData(
  Map<String, dynamic> firestoreData,
  PlanStruct? plan,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (plan == null) {
    return;
  }
  if (plan.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && plan.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final planData = getPlanFirestoreData(plan, forFieldValue);
  final nestedData = planData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = plan.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPlanFirestoreData(
  PlanStruct? plan, [
  bool forFieldValue = false,
]) {
  if (plan == null) {
    return {};
  }
  final firestoreData = mapToFirestore(plan.toMap());

  // Add any Firestore field values
  plan.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPlanListFirestoreData(
  List<PlanStruct>? plans,
) =>
    plans?.map((e) => getPlanFirestoreData(e, true)).toList() ?? [];
