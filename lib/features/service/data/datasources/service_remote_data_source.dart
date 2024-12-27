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
        return ListServiceModel.fromJson(
            apiResponse.result!.data, apiResponse.result!.pagination);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
