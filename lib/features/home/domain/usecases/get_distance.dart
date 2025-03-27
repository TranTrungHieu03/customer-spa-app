import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/location_repository.dart';

class GetDistanceParams {
  final List<BranchModel> branches;

  GetDistanceParams(this.branches);

  @override
  String toString() => branches.map((x) => '${x.latAddress},${x.longAddress}').join('|');
}

class GetDistance implements UseCase<Either, GetDistanceParams> {
  final LocationRepository _repository;

  GetDistance(this._repository);

  @override
  Future<Either> call(GetDistanceParams params) async {
    return await _repository.getDistance(params);
  }
}
