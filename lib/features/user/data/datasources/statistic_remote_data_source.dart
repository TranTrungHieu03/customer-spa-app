import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/user/data/model/list_service_product_model.dart';
import 'package:spa_mobile/features/user/data/model/skinhealth_statistic_model.dart';
import 'package:spa_mobile/features/user/domain/usecases/get_recommend.dart';
import 'package:spa_mobile/features/user/domain/usecases/list_skinhealth.dart';

abstract class StatisticRemoteDataSource {
  Future<List<SkinHealthStatisticModel>> getListSkinHealth(GetListSkinHealthParams params);

  Future<ListServiceProductModel> getRecommend(GetRecommendParams params);
}

class StatisticRemoteDataSourceImpl implements StatisticRemoteDataSource {
  final NetworkApiService _apiService;

  StatisticRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<SkinHealthStatisticModel>> getListSkinHealth(params) async {
    try {
      final response = await _apiService.getApi('/SkinHealth/get-my-skin-health/${params.userId}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => SkinHealthStatisticModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<ListServiceProductModel> getRecommend(GetRecommendParams params) async {
    try {
      final response = await _apiService.getApi('/Routine/get-list-service-and-product-rcm/${params.userId}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return ListServiceProductModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
