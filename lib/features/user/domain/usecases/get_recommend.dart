import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/user/domain/repository/statitis_repository.dart';

class GetRecommendParams {
  final int userId;

  GetRecommendParams(this.userId);
}

class GetRecommend implements UseCase<Either, GetRecommendParams> {
  final StatisticRepository _repository;

  GetRecommend(this._repository);

  @override
  Future<Either> call(GetRecommendParams params) async {
    return _repository.getListRecommend(params);
  }
}
