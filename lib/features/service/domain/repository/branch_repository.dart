import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_branch_detail.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_branches_by_routine.dart';

abstract class BranchRepository {
  Future<Either<Failure, List<BranchModel>>> getBranches();

  Future<Either<Failure, BranchModel>> getBranchDetail(GetBranchDetailParams params);

  Future<Either<Failure, List<BranchModel>>> getBranchesByRoutine(GetBranchesByRoutineParams params);
}
