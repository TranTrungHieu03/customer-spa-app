import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/model/list_product_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_list_products.dart';

abstract class ProductRepository {
  Future<Either<Failure, ListProductModel>> getProducts(GetListProductParams page);

  Future<Either<Failure, ProductModel>> getProduct(int productId);

  Future<Either<Failure, ListProductModel>> searchProducts(String query);
}
