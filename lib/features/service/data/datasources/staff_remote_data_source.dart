import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network_api_services.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';

abstract class StaffRemoteDataSource {
  Future<StaffModel> getStaffDetail(String id);

  Future<List<StaffModel>> getStaffs(GetListStaffParams param);
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
  Future<List<StaffModel>> getStaffs(GetListStaffParams param) async {
    try {
      final response = await _apiServices.getApi('/Staff/by-branch/${param.id}');

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
}
