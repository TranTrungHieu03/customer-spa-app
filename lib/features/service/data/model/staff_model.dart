import 'package:equatable/equatable.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';

class StaffModel extends Equatable {
  final int staffId;
  final int branchId;
  final int roleId;
  final UserModel? staffInfo;

  const StaffModel({
    required this.staffId,
    required this.branchId,
    required this.staffInfo,
    required this.roleId,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      staffId: json['staffId'] as int,
      branchId: json['branchId'] as int,
      roleId: json['roleId'] ?? 0 as int,
      staffInfo: json['staffInfo'] != null ? UserModel.fromJson(json['staffInfo']) : null,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [staffId, branchId];
}
