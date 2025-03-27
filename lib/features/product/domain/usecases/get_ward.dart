import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/ghn_repositoty.dart';

class GetWardParams {
  final int districtId;

  GetWardParams(this.districtId);
}

class GetWard implements UseCase<Either, GetWardParams> {
  final GHNRepository _repository;

  GetWard(this._repository);

  @override
  Future<Either> call(GetWardParams params) async {
    return await _repository.getWard(params);
  }
}
