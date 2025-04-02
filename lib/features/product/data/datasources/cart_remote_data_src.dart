import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_cart.dart';
import 'package:spa_mobile/features/product/domain/usecases/remove_product_cart.dart';

abstract class CartRemoteDataSource {
  Future<List<ProductCartModel>> addProductToCart(AddProductCartParams params);

  Future<String> removeProductFromCart(RemoveProductCartParams params);

  Future<List<ProductCartModel>> getCartProducts(GetCartParams params);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final NetworkApiService _apiServices;

  CartRemoteDataSourceImpl(this._apiServices);

  @override
  Future<List<ProductCartModel>> addProductToCart(params) async {
    try {
      final response = await _apiServices.postApi('/Cart/add-cart', params.toJson());
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((e) => ProductCartModel.fromJson(e)).toList();
      } else {
        AppLogger.info(apiResponse.result!.message);
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<ProductCartModel>> getCartProducts(params) async {
    try {
      final response = await _apiServices.getApi('/Cart/get-cart/${params.userId}');
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
  Future<String> removeProductFromCart(params) async {
    try {
      final response = await _apiServices.deleteApi('/Cart/${params.userId}/${params.productId}');
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
