import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/datasources/cart_remote_data_src.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';
import 'package:spa_mobile/features/product/domain/repository/cart_repository.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';
import 'package:spa_mobile/features/product/domain/usecases/remove_product_cart.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _cartDataSource;

  CartRepositoryImpl(this._cartDataSource);

  @override
  Future<Either<Failure, List<ProductCartModel>>> addProductToCart(AddProductCartParams params) async {
    try {
      List<ProductCartModel> result = await _cartDataSource.addProductToCart(params);
      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, String>> removeProductFromCart(RemoveProductCartParams id) async {
    try {
      String result = await _cartDataSource.removeProductFromCart(id);
      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ProductCartModel>>> getCartProducts(params) async {
    try {
      List<ProductCartModel> result = await _cartDataSource.getCartProducts(params);
      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
