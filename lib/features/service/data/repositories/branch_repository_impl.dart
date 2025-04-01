import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/datasources/branch_remote_data_source.dart';
import 'package:spa_mobile/features/service/domain/repository/branch_repository.dart';

class BranchRepositoryImpl implements BranchRepository {
  final BranchRemoteDataSource _branchRemoteDataSrc;

  BranchRepositoryImpl(this._branchRemoteDataSrc);

  @override
  Future<Either<Failure, List<BranchModel>>> getBranches() async {
    try {
      List<BranchModel> response = await _branchRemoteDataSrc.getBranches();
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BranchModel>> getBranchDetail(params) async {
    try {
      BranchModel response = await _branchRemoteDataSrc.getBranchDetail(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
