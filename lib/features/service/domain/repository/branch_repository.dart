import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/errors/failure.dart';

abstract class BranchRepository {
  Future<Either<Failure, List<BranchModel>>> getBranches();
}
