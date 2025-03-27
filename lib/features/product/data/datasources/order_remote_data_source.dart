import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';

abstract class OrderRemoteDataSource {
  Future<int> createOrder(CreateOrderParams params);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final NetworkApiService _apiServices;

  OrderRemoteDataSourceImpl(this._apiServices);

  @override
  Future<int> createOrder(CreateOrderParams params) async {
    try {
      final response = await _apiServices.postApi('/Order/create-full', params.toJson());
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return (apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
