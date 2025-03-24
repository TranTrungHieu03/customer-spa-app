import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/goong_api_services.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/core/services/permission.dart';
import 'package:spa_mobile/features/home/data/models/distance_model.dart';
import 'package:spa_mobile/features/home/data/models/location_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_distance.dart';

abstract class LocationRemoteDataSource {
  Future<LocationModel> getAddress();

  Future<List<DistanceModel>> getDistance(GetDistanceParams params);
}

class LocationRemoteDataSourceImpl extends LocationRemoteDataSource {
  final GoongApiService _apiService;
  final PermissionService _permissionService;

  LocationRemoteDataSourceImpl(this._permissionService, this._apiService);

  @override
  Future<LocationModel> getAddress() async {
    try {
      final location = await _permissionService.getCurrentLocation();

      final response = await _apiService.getApi('Geocode?latlng=${location?.latitude},${location?.longitude}');

      // final apiResponse = ApiResponse.fromJson(response);

      return LocationModel.fromJson(response);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<DistanceModel>> getDistance(params) async {
    try {
      final location = await _permissionService.getCurrentLocation();

      final response =
          await _apiService.getApi('DistanceMatrix?origins=${location?.latitude},${location?.longitude}&destinations=${params.toString()}');

      return (response['rows'][0]['elements'] as List).map((x) => DistanceModel.fromJson(x)).toList();
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
