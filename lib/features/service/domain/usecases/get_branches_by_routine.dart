import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/branch_repository.dart';

class GetBranchesByRoutineParams {
  final String routineId;

  GetBranchesByRoutineParams(this.routineId);
}

class GetBranchesByRoutine implements UseCase<Either, GetBranchesByRoutineParams> {
  final BranchRepository _branchRepository;

  GetBranchesByRoutine(this._branchRepository);

  @override
  Future<Either<Failure, List<BranchModel>>> call(GetBranchesByRoutineParams params) async {
    return await _branchRepository.getBranchesByRoutine(params);
  }
}
