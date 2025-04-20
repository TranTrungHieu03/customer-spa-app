import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/model/list_product_model.dart';
import 'package:spa_mobile/features/product/data/model/product_category_model.dart';
import 'package:spa_mobile/features/product/data/model/product_feedback_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/feedback_product.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_list_products.dart';
import 'package:spa_mobile/features/product/domain/usecases/list_feedback_product.dart';

abstract class ProductRepository {
  Future<Either<Failure, ListProductModel>> getProducts(GetListProductParams page);

  Future<Either<Failure, ProductModel>> getProduct(int productId);

  Future<Either<Failure, ListProductModel>> searchProducts(String query);

  Future<Either<Failure, ProductFeedbackModel>> feedback(FeedbackProductParams params);

  Future<Either<Failure, List<ProductFeedbackModel>>> getListFeedback(ListProductFeedbackParams params);

  Future<Either<Failure, List<ProductCategoryModel>>> getProductCategories();
}
