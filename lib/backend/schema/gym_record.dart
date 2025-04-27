import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';

class GymRecord extends FirestoreRecord {
  GymRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  bool hasCountry() => _country != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  bool hasCity() => _city != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "photos" field.
  List<String>? _photos;
  List<String> get photos => _photos ?? const [];
  bool hasPhotos() => _photos != null;

  // "facilities" field.
  List<String>? _facilities;
  List<String> get facilities => _facilities ?? const [];
  bool hasFacilities() => _facilities != null;

  // "workingHours" field.
  Map<String, String>? _workingHours;
  Map<String, String> get workingHours => _workingHours ?? {};
  bool hasWorkingHours() => _workingHours != null;

  // "phoneNumber" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "website" field.
  String? _website;
  String get website => _website ?? '';
  bool hasWebsite() => _website != null;

  // "socialMedia" field.
  Map<String, String>? _socialMedia;
  Map<String, String> get socialMedia => _socialMedia ?? {};
  bool hasSocialMedia() => _socialMedia != null;

  // "coaches" field.
  List<DocumentReference>? _coaches;
  List<DocumentReference> get coaches => _coaches ?? const [];
  bool hasCoaches() => _coaches != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _country = snapshotData['country'] as String?;
    _city = snapshotData['city'] as String?;
    _address = snapshotData['address'] as String?;
    _location = snapshotData['location'] as LatLng?;
    _photos = getDataList(snapshotData['photos']);
    _facilities = getDataList(snapshotData['facilities']);
    _workingHours = snapshotData['workingHours'] as Map<String, String>?;
    _phoneNumber = snapshotData['phoneNumber'] as String?;
    _email = snapshotData['email'] as String?;
    _website = snapshotData['website'] as String?;
    _socialMedia = snapshotData['socialMedia'] as Map<String, String>?;
    _coaches = getDataList(snapshotData['coaches'])
        ?.map((e) => e as DocumentReference)
        .toList();
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('gym');

  static Stream<GymRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GymRecord.fromSnapshot(s));

  static Future<GymRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GymRecord.fromSnapshot(s));

  static GymRecord fromSnapshot(DocumentSnapshot snapshot) => GymRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GymRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GymRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GymRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GymRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGymRecordData({
  String? name,
  String? country,
  String? city,
  String? address,
  LatLng? location,
  List<String>? photos,
  List<String>? facilities,
  Map<String, String>? workingHours,
  String? phoneNumber,
  String? email,
  String? website,
  Map<String, String>? socialMedia,
  List<DocumentReference>? coaches,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'country': country,
      'city': city,
      'address': address,
      'location': location,
      'photos': photos,
      'facilities': facilities,
      'workingHours': workingHours,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'socialMedia': socialMedia,
      'coaches': coaches,
    }.withoutNulls,
  );

  return firestoreData;
}

class GymRecordDocumentEquality implements Equality<GymRecord> {
  const GymRecordDocumentEquality();

  @override
  bool equals(GymRecord? e1, GymRecord? e2) {
    const listEquality = ListEquality();
    const mapEquality = MapEquality();

    return e1?.name == e2?.name &&
        e1?.country == e2?.country &&
        e1?.city == e2?.city &&
        e1?.address == e2?.address &&
        e1?.location == e2?.location &&
        listEquality.equals(e1?.photos, e2?.photos) &&
        listEquality.equals(e1?.facilities, e2?.facilities) &&
        mapEquality.equals(e1?.workingHours, e2?.workingHours) &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.email == e2?.email &&
        e1?.website == e2?.website &&
        mapEquality.equals(e1?.socialMedia, e2?.socialMedia) &&
        listEquality.equals(e1?.coaches, e2?.coaches);
  }

  @override
  int hash(GymRecord? e) => const ListEquality().hash([
        e?.name,
        e?.country,
        e?.city,
        e?.address,
        e?.location,
        e?.photos,
        e?.facilities,
        e?.workingHours,
        e?.phoneNumber,
        e?.email,
        e?.website,
        e?.socialMedia,
        e?.coaches,
      ]);

  @override
  bool isValidKey(Object? o) => o is GymRecord;
}
