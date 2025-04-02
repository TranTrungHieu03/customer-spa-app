import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/branch_repository.dart';

class GetBranchDetailParams {
  int id;

  GetBranchDetailParams(this.id);
}

class GetBranchDetail implements UseCase<Either, GetBranchDetailParams> {
  final BranchRepository _repository;

  GetBranchDetail(this._repository);

  @override
  Future<Either> call(GetBranchDetailParams params) async {
    return await _repository.getBranchDetail(params);
  }
}
