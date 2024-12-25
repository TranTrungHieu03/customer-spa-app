import 'package:spa_mobile/core/common/entities/branch.dart';

class BranchModel extends Branch {
  const BranchModel(
      {required super.branchId,
      required super.branchName,
      required super.branchAddress,
      required super.branchPhone,
      required super.longAddress,
      required super.latAddress,
      required super.status,
      required super.managerId});
}
