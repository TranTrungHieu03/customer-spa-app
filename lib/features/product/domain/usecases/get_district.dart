import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/ghn_repositoty.dart';

class GetDistrictParams {
  final int provinceId;

  GetDistrictParams(this.provinceId);
}

class GetDistrict implements UseCase<Either, GetDistrictParams> {
  final GHNRepository _repository;

  GetDistrict(this._repository);

  @override
  Future<Either> call(GetDistrictParams params) async {
    return await _repository.getDistrict(params);
  }
}
