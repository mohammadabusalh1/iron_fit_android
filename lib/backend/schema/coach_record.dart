import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CoachRecord extends FirestoreRecord {
  CoachRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "experience" field.
  int? _experience;
  int get experience => _experience ?? 0;
  bool hasExperience() => _experience != null;

  // "price" field.
  int? _price;
  int get price => _price ?? 0;
  bool hasPrice() => _price != null;

  // "Specialization" field.
  String? _specialization;
  String get specialization => _specialization ?? '';
  bool hasSpecialization() => _specialization != null;

  // "aboutMe" field.
  String? _aboutMe;
  String get aboutMe => _aboutMe ?? '';
  bool hasAboutMe() => _aboutMe != null;

  // "totalPaid" field.
  double? _totalPaid;
  double get totalPaid => _totalPaid ?? 0.0;
  bool hasTotalPaid() => _totalPaid != null;

  // "dateOfBirth" field.
  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _dateOfBirth;
  bool hasDateOfBirth() => _dateOfBirth != null;

  // "isSub" field.
  bool? _isSub;
  bool get isSub => _isSub ?? false;
  bool hasIsSub() => _isSub != null;

  // "subEndDate" field.
  DateTime? _subEndDate;
  DateTime? get subEndDate => _subEndDate;
  bool hasSubEndDate() => _subEndDate != null;

  // "gymName" field.
  String? _gymName;
  String get gymName => _gymName ?? '';
  bool hasGymName() => _gymName != null;

  // "phoneNumber" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "gym" field.
  DocumentReference? _gym;
  DocumentReference? get gym => _gym;
  bool hasGym() => _gym != null;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _experience = castToType<int>(snapshotData['experience']);
    _price = castToType<int>(snapshotData['price']);
    _specialization = snapshotData['Specialization'] as String?;
    _aboutMe = snapshotData['aboutMe'] as String?;
    _totalPaid = castToType<double>(snapshotData['totalPaid']);
    _dateOfBirth = snapshotData['dateOfBirth'] as DateTime?;
    _isSub = snapshotData['isSub'] as bool?;
    _subEndDate = snapshotData['subEndDate'] as DateTime?;
    _gymName = snapshotData['gymName'] as String?;
    _phoneNumber = snapshotData['phoneNumber'] as String?;
    _gym = snapshotData['gym'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('coach');

  static Stream<CoachRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CoachRecord.fromSnapshot(s));

  static Future<CoachRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CoachRecord.fromSnapshot(s));

  static CoachRecord fromSnapshot(DocumentSnapshot snapshot) => CoachRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CoachRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CoachRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CoachRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CoachRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCoachRecordData({
  DocumentReference? user,
  int? experience,
  int? price,
  String? specialization,
  String? aboutMe,
  double? totalPaid,
  DateTime? dateOfBirth,
  bool? isSub,
  DateTime? subEndDate,
  String? gymName,
  String? phoneNumber,
  DocumentReference? gym,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'experience': experience,
      'price': price,
      'Specialization': specialization,
      'aboutMe': aboutMe,
      'totalPaid': totalPaid,
      'dateOfBirth': dateOfBirth,
      'isSub': isSub,
      'subEndDate': subEndDate,
      'gymName': gymName,
      'phoneNumber': phoneNumber,
      'gym': gym,
    }.withoutNulls,
  );

  return firestoreData;
}

class CoachRecordDocumentEquality implements Equality<CoachRecord> {
  const CoachRecordDocumentEquality();

  @override
  bool equals(CoachRecord? e1, CoachRecord? e2) {
    return e1?.user == e2?.user &&
        e1?.experience == e2?.experience &&
        e1?.price == e2?.price &&
        e1?.specialization == e2?.specialization &&
        e1?.aboutMe == e2?.aboutMe &&
        e1?.totalPaid == e2?.totalPaid &&
        e1?.dateOfBirth == e2?.dateOfBirth &&
        e1?.isSub == e2?.isSub &&
        e1?.subEndDate == e2?.subEndDate &&
        e1?.gymName == e2?.gymName &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.gym == e2?.gym;
  }

  @override
  int hash(CoachRecord? e) => const ListEquality().hash([
        e?.user,
        e?.experience,
        e?.price,
        e?.specialization,
        e?.aboutMe,
        e?.totalPaid,
        e?.dateOfBirth,
        e?.isSub,
        e?.subEndDate,
        e?.gymName,
        e?.phoneNumber,
        e?.gym,
      ]);

  @override
  bool isValidKey(Object? o) => o is CoachRecord;
}
