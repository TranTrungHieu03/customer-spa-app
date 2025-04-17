import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network_api_services.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/service/data/model/list_service_model.dart';
import 'package:spa_mobile/features/service/data/model/service_feedback_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/feedback_service.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_feedback_service.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_services.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_service_detail.dart';

abstract class ServiceRemoteDataSrc {
  Future<ListServiceModel> getServices(GetListServiceParams param);

  Future<ListServiceModel> getServicesByBranch(GetListServiceParams param);

  Future<ServiceModel> getServiceDetail(GetServiceDetailParams params);

  Future<ServiceFeedbackModel> feedbackService(FeedbackServiceParams params);

  Future<List<ServiceFeedbackModel>> getListFeedbackService(GetListFeedbackServiceParams params);
}

class ServiceRemoteDataSrcImpl extends ServiceRemoteDataSrc {
  final NetworkApiService _apiServices;

  ServiceRemoteDataSrcImpl(this._apiServices);

  @override
  Future<ServiceModel> getServiceDetail(GetServiceDetailParams params) async {
    try {
      final response = await _apiServices.getApi('/Service/get-service-by-id?id=${params.id}');
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
  Future<ListServiceModel> getServices(GetListServiceParams param) async {
    try {
      final response = await _apiServices.getApi('/Service/get-all-services?page=${param.page}&pageSize=${param.pageSize}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return ListServiceModel.fromJson(apiResponse.result!.data, apiResponse.result!.pagination);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<ListServiceModel> getServicesByBranch(GetListServiceParams param) async {
    try {
      final response = await _apiServices
          .getApi('/Service/get-all-services-for-branch?branchId=${param.branchId}&page=${param.page}&pageSize=${param.pageSize}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return ListServiceModel.fromJson(apiResponse.result!.data, apiResponse.result!.pagination);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<ServiceFeedbackModel> feedbackService(FeedbackServiceParams params) async {
    try {
      final response = await _apiServices.postApi('/ServiceFeedback/create', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return ServiceFeedbackModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<ServiceFeedbackModel>> getListFeedbackService(GetListFeedbackServiceParams params) async {
    try {
      final response = await _apiServices.getApi('/ServiceFeedback/get-by-service/${params.serviceId}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => ServiceFeedbackModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
