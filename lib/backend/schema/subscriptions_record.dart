import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubscriptionsRecord extends FirestoreRecord {
  SubscriptionsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "amountPaid" field.
  double? _amountPaid;
  double get amountPaid => _amountPaid ?? 0.0;
  bool hasAmountPaid() => _amountPaid != null;

  // "debts" field.
  double? _debts;
  double get debts => _debts ?? 0.0;
  bool hasDebts() => _debts != null;

  // "isActive" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  // "trainee" field.
  DocumentReference? _trainee;
  DocumentReference? get trainee => _trainee;
  bool hasTrainee() => _trainee != null;

  // "coach" field.
  DocumentReference? _coach;
  DocumentReference? get coach => _coach;
  bool hasCoach() => _coach != null;

  // "plan" field.
  DocumentReference? _plan;
  DocumentReference? get plan => _plan;
  bool hasPlan() => _plan != null;

  // "endDate" field.
  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  bool hasEndDate() => _endDate != null;

  // "startDate" field.
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  bool hasStartDate() => _startDate != null;

  // "totalPaid" field.
  double? _totalPaid;
  double get totalPaid => _totalPaid ?? 0;
  bool hasTotalPaid() => _totalPaid != null;

  // "nutPlan" field.
  DocumentReference? _nutPlan;
  DocumentReference? get nutPlan => _nutPlan;
  bool hasNutPlan() => _nutPlan != null;

  // "goal" field.
  String? _goal;
  String get goal => _goal ?? '';
  bool hasGoal() => _goal != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "isAnonymous" field.
  bool? _isAnonymous;
  bool get isAnonymous => _isAnonymous ?? false;
  bool hasIsAnonymous() => _isAnonymous != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  // "isDeleted" field.
  bool? _isDeleted;
  bool get isDeleted => _isDeleted ?? false;
  bool hasIsDeleted() => _isDeleted != null;

  // "bills" field.
  List<Map<String, dynamic>>? _bills;
  List<Map<String, dynamic>> get bills => _bills ?? [];
  bool hasBills() => _bills != null;

  // "debtList" field.
  List<Map<String, dynamic>>? _debtList;
  List<Map<String, dynamic>> get debtList => _debtList ?? [];
  bool hasDebtList() => _debtList != null;

  // "level" field.
  String? _level;
  String get level => _level ?? '';
  bool hasLevel() => _level != null;

  void _initializeFields() {
    _amountPaid = castToType<double>(snapshotData['amountPaid']);
    _debts = castToType<double>(snapshotData['debts']);
    _isActive = snapshotData['isActive'] as bool?;
    _trainee = snapshotData['trainee'] as DocumentReference?;
    _coach = snapshotData['coach'] as DocumentReference?;
    _plan = snapshotData['plan'] as DocumentReference?;
    _endDate = snapshotData['endDate'] as DateTime?;
    _startDate = snapshotData['startDate'] as DateTime?;
    _totalPaid = castToType<double>(snapshotData['totalPaid']);
    _nutPlan = snapshotData['nutPlan'] as DocumentReference?;
    _goal = snapshotData['goal'] as String?;
    _email = snapshotData['email'] as String?;
    _isAnonymous = snapshotData['isAnonymous'] as bool?;
    _name = snapshotData['name'] as String?;
    _notes = snapshotData['notes'] as String?;
    _isDeleted = snapshotData['isDeleted'] as bool?;
    _bills = (snapshotData['bills'] as List?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList();
    _debtList = (snapshotData['debtList'] as List?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList();
    if (snapshotData['level'] is List) {
      _level = snapshotData['level'][0] as String?;
    } else {
      _level = snapshotData['level'] as String?;
    }
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('subscriptions');

  static Stream<SubscriptionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SubscriptionsRecord.fromSnapshot(s));

  static Future<SubscriptionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SubscriptionsRecord.fromSnapshot(s));

  static SubscriptionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SubscriptionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SubscriptionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SubscriptionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SubscriptionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SubscriptionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSubscriptionsRecordData({
  double? amountPaid,
  double? debts,
  bool? isActive,
  DocumentReference? trainee,
  DocumentReference? coach,
  DocumentReference? plan,
  DateTime? endDate,
  DateTime? startDate,
  double? totalPaid,
  DocumentReference? nutPlan,
  String? goal,
  String? email,
  bool? isAnonymous,
  String? name,
  String? notes,
  bool? isDeleted,
  List<Map<String, dynamic>>? bills,
  List<Map<String, dynamic>>? debtList,
  String? level,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'amountPaid': amountPaid,
      'debts': debts,
      'isActive': isActive,
      'trainee': trainee,
      'coach': coach,
      'plan': plan,
      'endDate': endDate,
      'startDate': startDate,
      'totalPaid': totalPaid,
      'nutPlan': nutPlan,
      'goal': goal,
      'email': email,
      'isAnonymous': isAnonymous,
      'name': name,
      'notes': notes,
      'isDeleted': isDeleted,
      'bills': bills,
      'debtList': debtList,
      'level': level,
    }.withoutNulls,
  );

  return firestoreData;
}

class SubscriptionsRecordDocumentEquality
    implements Equality<SubscriptionsRecord> {
  const SubscriptionsRecordDocumentEquality();

  @override
  bool equals(SubscriptionsRecord? e1, SubscriptionsRecord? e2) {
    return e1?.amountPaid == e2?.amountPaid &&
        e1?.debts == e2?.debts &&
        e1?.isActive == e2?.isActive &&
        e1?.trainee == e2?.trainee &&
        e1?.coach == e2?.coach &&
        e1?.plan == e2?.plan &&
        e1?.endDate == e2?.endDate &&
        e1?.startDate == e2?.startDate &&
        e1?.totalPaid == e2?.totalPaid &&
        e1?.nutPlan == e2?.nutPlan &&
        e1?.goal == e2?.goal &&
        e1?.email == e2?.email &&
        e1?.isAnonymous == e2?.isAnonymous &&
        e1?.name == e2?.name &&
        e1?.notes == e2?.notes &&
        e1?.isDeleted == e2?.isDeleted &&
        const DeepCollectionEquality().equals(e1?.bills, e2?.bills) &&
        const DeepCollectionEquality().equals(e1?.debtList, e2?.debtList) &&
        e1?.level == e2?.level;
  }

  @override
  int hash(SubscriptionsRecord? e) => const ListEquality().hash([
        e?.amountPaid,
        e?.debts,
        e?.isActive,
        e?.trainee,
        e?.coach,
        e?.plan,
        e?.endDate,
        e?.startDate,
        e?.totalPaid,
        e?.nutPlan,
        e?.goal,
        e?.email,
        e?.isAnonymous,
        e?.name,
        e?.notes,
        e?.isDeleted,
        ...?e?.bills,
        ...?e?.debtList,
        e?.level,
      ]);

  @override
  bool isValidKey(Object? o) => o is SubscriptionsRecord;
}
