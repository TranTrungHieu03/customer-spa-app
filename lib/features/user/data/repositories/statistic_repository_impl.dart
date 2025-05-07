import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/user/data/datasources/statistic_remote_data_source.dart';
import 'package:spa_mobile/features/user/data/model/list_service_product_model.dart';
import 'package:spa_mobile/features/user/data/model/skinhealth_statistic_model.dart';
import 'package:spa_mobile/features/user/domain/repository/statitis_repository.dart';
import 'package:spa_mobile/features/user/domain/usecases/get_recommend.dart';
import 'package:spa_mobile/features/user/domain/usecases/list_skinhealth.dart';

class StatisticRepositoryImpl implements StatisticRepository {
  final StatisticRemoteDataSource _dataSource;

  StatisticRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<SkinHealthStatisticModel>>> getListSkinHealth(GetListSkinHealthParams params) async {
    try {
      List<SkinHealthStatisticModel> response = await _dataSource.getListSkinHealth(params);
      return right(response);
    } on AppException catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ListServiceProductModel>> getListRecommend(GetRecommendParams params) async {
    try {
      ListServiceProductModel response = await _dataSource.getRecommend(params);
      return right(response);
    } on AppException catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
