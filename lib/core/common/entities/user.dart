import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int userId;
  final String userName;
  final String? fullName;
  final String email;
  final String? avatar;
  final String? gender;
  final String? city;
  final String? address;
  final DateTime? birthDate;
  final String? phoneNumber;
  final String? status;
  final int? bonusPoint;
  final String? typeLogin;
  final int? district;
  final int? wardCode;

  const User({
    required this.userId,
    required this.userName,
    this.fullName,
    this.district,
    this.wardCode,
    required this.email,
    this.avatar,
    this.gender,
    this.city,
    this.address,
    this.birthDate,
    this.phoneNumber,
    this.status,
    this.bonusPoint,
    this.typeLogin,
  });

  @override
  List<Object?> get props => [userId];
}
