import 'package:spa_mobile/features/auth/data/models/user_model.dart';

class StaffModel {
  final int staffId;
  final int branchId;
  final UserModel staffInfo;

  const StaffModel({
    required this.staffId,
    required this.branchId,
    required this.staffInfo,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      staffId: json['staffId'] as int,
      branchId: json['branchId'] as int,
      staffInfo: UserModel.fromJson(json['staffInfo']),
    );
  }
}
