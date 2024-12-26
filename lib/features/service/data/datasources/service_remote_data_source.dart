import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network_api_services.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/service/data/model/list_service_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_service_detail.dart';

abstract class ServiceRemoteDataSrc {
  Future<ListServiceModel> getServices(int param);

  Future<ServiceModel> getServiceDetail(GetServiceDetailParams params);
}

class ServiceRemoteDataSrcImpl extends ServiceRemoteDataSrc {
  final NetworkApiService _apiServices;

  ServiceRemoteDataSrcImpl(this._apiServices);

  @override
  Future<ServiceModel> getServiceDetail(GetServiceDetailParams params) async {
    try {
      final response = await _apiServices
          .getApi('/Service/get-service-by-id?id=${params.id}');
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return ServiceModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<ListServiceModel> getServices(int param) async {
    try {
      final response =
          await _apiServices.getApi('/Service/get-all-services?page=$param');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return ListServiceModel(
            services: apiResponse.result!.data != null &&
                    apiResponse.result!.data is List
                ? (apiResponse.result!.data! as List)
                    .map((serviceJson) => ServiceModel.fromJson(serviceJson))
                    .toList()
                : [],
            pagination: PaginationModel.fromJson(
                apiResponse.result!.pagination as Map<String, dynamic>));
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
