import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/product/data/model/list_product_model.dart';
import 'package:spa_mobile/features/product/data/model/product_category_model.dart';
import 'package:spa_mobile/features/product/data/model/product_feedback_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/feedback_product.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_list_products.dart';
import 'package:spa_mobile/features/product/domain/usecases/list_feedback_product.dart';

abstract class ProductRemoteDataSource {
  Future<ListProductModel> getProducts(GetListProductParams page);

  Future<ProductModel> getProduct(int productId);

  Future<ListProductModel> searchProducts(String query);

  Future<ProductFeedbackModel> feedbackProduct(FeedbackProductParams params);

  Future<List<ProductFeedbackModel>> getlistFeedbackProduct(ListProductFeedbackParams params);

  Future<List<ProductCategoryModel>> getAllProductCategories();
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
          '/Product/filter?BranchId=${params.branchId}&Brand=${params.brand}&CategoryIds=${params.categoryId?.isNotEmpty ?? false ? params.categoryId : ""}&MinPrice=${params.minPrice == -1.0 ? "" : params.minPrice}&MaxPrice=${params.maxPrice == -1.0 ? "" : params.maxPrice}&SortBy=${params.sortBy}&PageNumber=${params.page}&PageSize=20');

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

  @override
  Future<ProductFeedbackModel> feedbackProduct(FeedbackProductParams params) async {
    try {
      final response = await _apiServices.postApi('/ProductFeedback/create', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return ProductFeedbackModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<ProductFeedbackModel>> getlistFeedbackProduct(ListProductFeedbackParams params) async {
    try {
      final response = await _apiServices.getApi('/ProductFeedback/get-by-product/${params.productId}');

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => ProductFeedbackModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<ProductCategoryModel>> getAllProductCategories() async {
    try {
      final response = await _apiServices.getApi('/Category/get-all');

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => ProductCategoryModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
