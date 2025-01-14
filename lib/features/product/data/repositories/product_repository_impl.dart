import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/network/connection_checker.dart';
import 'package:spa_mobile/features/product/data/datasources/product_remote_data_src.dart';
import 'package:spa_mobile/features/product/data/model/list_product_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';

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
  Future<Either<Failure, ListProductModel>> getProducts(int page) async {
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
}
