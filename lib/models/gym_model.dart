import 'package:cloud_firestore/cloud_firestore.dart';

class GymModel {
  final String? id;
  final String name;
  final String? website;
  final List<String>? photos;
  final String country;
  final String city;
  final String address;
  final String phoneNumber;
  final String email;
  final String? instagram;
  final String? facebook;
  final List<String>? facilities;
  final Map<String, String>? workingHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  GymModel({
    this.id,
    required this.name,
    this.website,
    this.photos,
    required this.country,
    required this.city,
    required this.address,
    required this.phoneNumber,
    required this.email,
    this.instagram,
    this.facebook,
    this.facilities,
    this.workingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'website': website,
      'photos': photos,
      'country': country,
      'city': city,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'instagram': instagram,
      'facebook': facebook,
      'facilities': facilities,
      'workingHours': workingHours,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory GymModel.fromMap(Map<String, dynamic> map, String id) {
    return GymModel(
      id: id,
      name: map['name'] ?? '',
      website: map['website'],
      photos: List<String>.from(map['photos'] ?? []),
      country: map['country'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      instagram: map['instagram'],
      facebook: map['facebook'],
      facilities: List<String>.from(map['facilities'] ?? []),
      workingHours: Map<String, String>.from(map['workingHours'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  GymModel copyWith({
    String? id,
    String? name,
    String? website,
    List<String>? photos,
    String? country,
    String? city,
    String? address,
    String? phoneNumber,
    String? email,
    String? instagram,
    String? facebook,
    List<String>? facilities,
    Map<String, String>? workingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GymModel(
      id: id ?? this.id,
      name: name ?? this.name,
      website: website ?? this.website,
      photos: photos ?? this.photos,
      country: country ?? this.country,
      city: city ?? this.city,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      facilities: facilities ?? this.facilities,
      workingHours: workingHours ?? this.workingHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
