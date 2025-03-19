import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network_api_services.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_service_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff_by_list_id.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_single_staff.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_staff_free_in_time.dart';

abstract class StaffRemoteDataSource {
  Future<StaffModel> getStaffDetail(String id);

  Future<List<StaffServiceModel>> getStaffs(GetListStaffParams param);

  Future<StaffModel> getSingleStaff(GetSingleStaffParams param);

  Future<List<StaffModel>> getStaffByListIds(GetListStaffByListIdParams param);

  Future<List<StaffServiceModel>> getStaffFreeInTime(GetStaffFreeInTimeParams param);
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  final NetworkApiService _apiServices;

  StaffRemoteDataSourceImpl(this._apiServices);

  @override
  Future<StaffModel> getStaffDetail(String id) {
    // TODO: implement getStaffDetail
    throw UnimplementedError();
  }

  @override
  Future<List<StaffServiceModel>> getStaffs(GetListStaffParams param) async {
    try {
      final response = await _apiServices.postApi('/Staff/staff-by-service-category', param.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => StaffServiceModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<StaffModel>> getStaffByListIds(GetListStaffByListIdParams param) async {
    try {
      final response = await _apiServices.getApi('/Staff/by-branch/${param.staffIds}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => StaffModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<StaffModel> getSingleStaff(GetSingleStaffParams param) async {
    try {
      final response = await _apiServices.getApi('/Staff/${param.staffId}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return StaffModel.fromJson(apiResponse.result!.data['data']);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<StaffServiceModel>> getStaffFreeInTime(GetStaffFreeInTimeParams param) async {
    try {
      final response = await _apiServices.postApi('/Staff/staff-free-in-time', param.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => StaffServiceModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
