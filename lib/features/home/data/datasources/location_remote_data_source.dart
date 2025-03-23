import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/goong_api_services.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/core/services/permission.dart';
import 'package:spa_mobile/features/home/data/models/location_model.dart';

abstract class LocationRemoteDataSource {
  Future<LocationModel> getAddress();
}

class LocationRemoteDataSourceImpl extends LocationRemoteDataSource {
  final GoongApiService _apiService;
  final PermissionService _permissionService;

  LocationRemoteDataSourceImpl(this._permissionService, this._apiService);

  @override
  Future<LocationModel> getAddress() async {
    try {
      final location = await _permissionService.getCurrentLocation();

      final response = await _apiService.getApi('Geocode?latlng=${location?.latitude},=${location?.longitude}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return LocationModel.fromJson(apiResponse.result!.data!);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
