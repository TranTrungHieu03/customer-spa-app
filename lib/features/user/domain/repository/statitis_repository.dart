import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/user/data/model/list_service_product_model.dart';
import 'package:spa_mobile/features/user/data/model/skinhealth_statistic_model.dart';
import 'package:spa_mobile/features/user/domain/usecases/get_recommend.dart';
import 'package:spa_mobile/features/user/domain/usecases/list_skinhealth.dart';

abstract class StatisticRepository {
  Future<Either<Failure, List<SkinHealthStatisticModel>>> getListSkinHealth(GetListSkinHealthParams params);

  Future<Either<Failure, ListServiceProductModel>> getListRecommend(GetRecommendParams params);
}
