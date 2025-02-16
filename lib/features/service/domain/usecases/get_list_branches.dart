import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/branch_repository.dart';

class GetListBranches implements UseCase<Either, NoParams> {
  final BranchRepository _repository;

  GetListBranches(this._repository);

  @override
  Future<Either<Failure, List<BranchModel>>> call(NoParams params) async {
    return await _repository.getBranches();
  }
}
