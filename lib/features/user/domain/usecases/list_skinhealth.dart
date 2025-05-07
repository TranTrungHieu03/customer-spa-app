import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/user/domain/repository/statitis_repository.dart';

class GetListSkinHealth implements UseCase<Either, GetListSkinHealthParams> {
  final StatisticRepository _repository;

  GetListSkinHealth(this._repository);

  @override
  Future<Either> call(GetListSkinHealthParams params) async {
    return await _repository.getListSkinHealth(params);
  }
}

class GetListSkinHealthParams {
  final int userId;

  GetListSkinHealthParams(this.userId);
}
