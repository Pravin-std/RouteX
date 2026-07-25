import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? gender;
  final String? profilePhotoUrl;
  final String? dob;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.profilePhotoUrl,
    this.dob,
    this.address,
    this.city,
    this.state,
    this.country,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      gender: json['gender'] as String?,
      profilePhotoUrl:
          json['avatar_url'] as String? ?? json['profile_photo_url'] as String?,
      dob: json['dob'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'avatar_url': profilePhotoUrl,
      'dob': dob,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phoneNumber,
    gender,
    profilePhotoUrl,
    dob,
    address,
    city,
    state,
    country,
    createdAt,
    updatedAt,
  ];
}
