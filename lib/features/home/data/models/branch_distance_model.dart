import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/features/home/data/models/distance_model.dart';

class BranchDistanceModel {
  final DistanceModel distance;
  final BranchModel branchModel;

  const BranchDistanceModel({required this.branchModel, required this.distance});
}
