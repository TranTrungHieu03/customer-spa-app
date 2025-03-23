import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';

abstract class CartRepository {
  const CartRepository();

  Future<Either<Failure, String>> addProductToCart(AddProductCartParams product);

  Future<Either<Failure, String>> removeProductFromCart(String product);

  Future<Either<Failure, List<ProductCartModel>>> getCartProducts();
}
