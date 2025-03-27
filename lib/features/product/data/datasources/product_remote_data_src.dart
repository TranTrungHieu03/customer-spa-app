import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/product/data/model/list_product_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_list_products.dart';

abstract class ProductRemoteDataSource {
  Future<ListProductModel> getProducts(GetListProductParams page);

  Future<ProductModel> getProduct(int productId);

  Future<ListProductModel> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final NetworkApiService _apiServices;

  ProductRemoteDataSourceImpl(this._apiServices);

  @override
  Future<ProductModel> getProduct(int productId) async {
    try {
      final response = await _apiServices.getApi('/Product/detail-by-productBranchId?productBranchId=$productId');
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return ProductModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<ListProductModel> getProducts(GetListProductParams params) async {
    try {
      final response = await _apiServices.getApi(
          '/Product/filter?BrandId=${params.branchId}&Brand=${params.brand}&CategoryId=${params.categoryId == 0 ? "" : params.categoryId}&MinPrice=${params.minPrice == -1.0 ? "" : params.minPrice}&MaxPrice=${params.maxPrice == -1.0 ? "" : params.maxPrice}&SortBy=${params.sortBy}&page=${params.page}');

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return ListProductModel.fromJson(apiResponse.result!.data, apiResponse.result!.pagination);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<ListProductModel> searchProducts(String query) {
    // TODO: implement searchProducts
    throw UnimplementedError();
  }
}
