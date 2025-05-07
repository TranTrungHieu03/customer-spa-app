import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/network/connection_checker.dart';
import 'package:spa_mobile/features/product/data/datasources/product_remote_data_src.dart';
import 'package:spa_mobile/features/product/data/model/list_product_model.dart';
import 'package:spa_mobile/features/product/data/model/product_branch_model.dart';
import 'package:spa_mobile/features/product/data/model/product_category_model.dart';
import 'package:spa_mobile/features/product/data/model/product_feedback_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';
import 'package:spa_mobile/features/product/domain/usecases/feedback_product.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_branch_has_product.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_list_products.dart';
import 'package:spa_mobile/features/product/domain/usecases/list_feedback_product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;
  final ConnectionChecker _connectionChecker;

  ProductRepositoryImpl(this._productRemoteDataSource, this._connectionChecker);

  @override
  Future<Either<Failure, ProductModel>> getProduct(int productId) async {
    try {
      ProductModel result = await _productRemoteDataSource.getProduct(productId);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ListProductModel>> getProducts(GetListProductParams page) async {
    try {
      ListProductModel result = await _productRemoteDataSource.getProducts(page);

      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ListProductModel>> searchProducts(String query) async {
    // TODO: implement searchProducts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProductFeedbackModel>> feedback(FeedbackProductParams params) async {
    try {
      ProductFeedbackModel result = await _productRemoteDataSource.feedbackProduct(params);

      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ProductFeedbackModel>>> getListFeedback(ListProductFeedbackParams params) async {
    try {
      List<ProductFeedbackModel> result = await _productRemoteDataSource.getlistFeedbackProduct(params);

      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ProductCategoryModel>>> getProductCategories() async {
    try {
      List<ProductCategoryModel> result = await _productRemoteDataSource.getAllProductCategories();

      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductByProductId(int productId) async {
    try {
      ProductModel result = await _productRemoteDataSource.getProductByProductId(productId);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ProductBranchModel>>> getBranchHasProduct(GetBranchHasProductParams params) async {
    try {
      List<ProductBranchModel> result = await _productRemoteDataSource.getBranchHasProduct(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
