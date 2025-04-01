import 'package:spa_mobile/core/common/entities/branch.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';

class BranchModel extends Branch {
  final UserModel? managerBranch;
  final double? distance;

  const BranchModel(
      {required super.branchId,
      required super.branchName,
      required super.branchAddress,
      required super.branchPhone,
      required super.longAddress,
      required super.latAddress,
      required super.status,
      required super.managerId,
      required super.district,
      required super.wardCode,
      this.managerBranch,
      this.distance});

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['branchId'],
      branchName: json['branchName'],
      branchAddress: json['branchAddress'],
      branchPhone: json['branchPhone'],
      longAddress: json['longAddress'],
      latAddress: json['latAddress'],
      status: json['status'],
      managerId: json['managerId'],
      district: json['district'] ?? 0,
      wardCode: json['wardCode'] ?? 0,
      distance: json['distance'] ?? 0,
      managerBranch: json['managerBranch'] != null ? UserModel.fromJson(json['managerBranch']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'branchAddress': branchAddress,
      'branchPhone': branchPhone,
      'longAddress': longAddress,
      'latAddress': latAddress,
      'status': status,
      'managerId': managerId,
      'managerBranch': managerBranch?.toJson(),
      'district': district,
      'wardCode': wardCode,
    };
  }

  Map<String, dynamic> isEmpty() {
    return {
      'branchId': "",
      'branchName': "",
      'branchAddress': "",
      'branchPhone': "",
      'longAddress': "",
      'latAddress': "",
      'status': "",
      'managerId': "",
      'district': "",
      'wardCode': ""
    };
  }

  Branch copyWith({
    int? branchId,
    String? branchName,
    String? branchAddress,
    String? branchPhone,
    String? longAddress,
    String? latAddress,
    String? status,
    int? managerId,
    int? district,
    int? wardCode,
    double? distance,
  }) {
    return BranchModel(
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      branchAddress: branchAddress ?? this.branchAddress,
      branchPhone: branchPhone ?? this.branchPhone,
      longAddress: longAddress ?? this.longAddress,
      latAddress: latAddress ?? this.latAddress,
      status: status ?? this.status,
      managerId: managerId ?? this.managerId,
      managerBranch: managerBranch ?? this.managerBranch,
      distance: distance ?? this.distance,
      district: district ?? this.district,
      wardCode: wardCode ?? this.wardCode,
    );
  }
}
