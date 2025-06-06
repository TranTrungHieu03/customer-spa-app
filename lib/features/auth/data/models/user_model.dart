import 'package:spa_mobile/core/common/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.userId,
      required super.userName,
      super.fullName,
      required super.email,
      super.avatar,
      super.gender,
      super.city,
      super.address,
      super.birthDate,
      super.phoneNumber,
      super.status,
      super.bonusPoint,
      super.typeLogin,
      super.district,
      super.wardCode});

  UserModel copyWith({
    int? userId,
    int? district,
    int? wardCode,
    String? userName,
    String? fullName,
    String? email,
    String? avatar,
    String? gender,
    String? city,
    String? address,
    DateTime? birthDate,
    String? phoneNumber,
    String? status,
    int? bonusPoint,
    String? typeLogin,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      city: city ?? this.city,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      bonusPoint: bonusPoint ?? this.bonusPoint,
      typeLogin: typeLogin ?? this.typeLogin,
      district: district ?? this.district,
      wardCode: wardCode ?? this.wardCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'avatar': avatar,
      'gender': gender,
      'city': city,
      'address': address,
      'birthDate': birthDate?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'status': status,
      'bonusPoint': bonusPoint,
      'typeLogin': typeLogin,
      'district': district,
      'wardCode': wardCode
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json['userId'],
        userName: json['userName'],
        fullName: json['fullName'],
        email: json['email'],
        avatar: json['avatar'],
        gender: json['gender'],
        city: json['city'],
        address: json['address'],
        birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
        phoneNumber: json['phoneNumber'],
        status: json['status'],
        bonusPoint: json['bonusPoint'],
        typeLogin: json['typeLogin'],
        district: json['district'] ?? 0,
        wardCode: json['wardCode'] ?? 0);
  }

  factory UserModel.empty() {
    return const UserModel(
      userId: 0,
      userName: '',
      fullName: '',
      email: '',
      avatar: '',
      gender: '',
      city: '',
      address: '',
      birthDate: null,
      phoneNumber: '',
      status: '',
      bonusPoint: 0,
      typeLogin: '',
      district: 0,
      wardCode: 0,
    );
  }
}
