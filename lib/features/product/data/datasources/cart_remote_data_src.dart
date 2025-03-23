import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';

abstract class CartRemoteDataSource {
  Future<String> addProductToCart(AddProductCartParams params);

  Future<String> removeProductFromCart(String id);

  Future<List<ProductCartModel>> getCartProducts();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final NetworkApiService _apiServices;

  CartRemoteDataSourceImpl(this._apiServices);

  @override
  Future<String> addProductToCart(params) async {
    try {
      final response = await _apiServices.postApi('/Cart', params.toJson());
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

  @override
  Future<List<ProductCartModel>> getCartProducts() async {
    try {
      final response = await _apiServices.getApi('/Cart');
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((e) => ProductCartModel.fromJson(e)).toList();
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> removeProductFromCart(id) async {
    try {
      final response = await _apiServices.deleteApi('/Cart/$id');
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
