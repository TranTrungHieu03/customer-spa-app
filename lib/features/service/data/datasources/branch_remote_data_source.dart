import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';

abstract class BranchRemoteDataSource {
  Future<List<BranchModel>> getBranches();

// Future<double> getDistance(double lat, double long);
}

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final NetworkApiService _apiService;

  // final ThirdPartyApiServices _thirdPartyApiServices;

  BranchRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<BranchModel>> getBranches() async {
    try {
      final response = await _apiService.getApi('/Branch/get-all?status=Active');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((e) => BranchModel.fromJson(e)).toList();
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

// @override
// Future<double> getDistance(double lat, double long) async {
//   try {
//     final response = await _thirdPartyApiServices.getApi('?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&vehicle=car&api_key=$apiKey');
//     return response.data;
//   } catch (e) {
//     throw AppException(e.toString());
//   }
// }
}
