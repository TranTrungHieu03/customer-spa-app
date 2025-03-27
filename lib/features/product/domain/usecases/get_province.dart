import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/ghn_repositoty.dart';

class GetProvince implements UseCase<Either, NoParams> {
  final GHNRepository _repository;

  GetProvince(this._repository);

  @override
  Future<Either> call(NoParams params) async {
    return await _repository.getProvince();
  }
}
