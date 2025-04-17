import 'package:equatable/equatable.dart';

class Staff extends Equatable {
  final int staffId;
  final int userId;
  final int branchId;
  final int roleId;

  const Staff({
    required this.staffId,
    required this.userId,
    required this.branchId,
    required this.roleId,
  });

  @override
  List<Object> get props => [staffId, userId, branchId, roleId];
}
