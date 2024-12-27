import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/model/list_product_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, ListProductModel>> getProducts(int page);

  Future<Either<Failure, ProductModel>> getProduct(int productId);

  Future<Either<Failure, ListProductModel>> searchProducts(String query);
}
