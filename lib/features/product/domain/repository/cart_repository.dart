import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_cart.dart';
import 'package:spa_mobile/features/product/domain/usecases/remove_product_cart.dart';

abstract class CartRepository {
  const CartRepository();

  Future<Either<Failure, List<ProductCartModel>>> addProductToCart(AddProductCartParams product);

  Future<Either<Failure, String>> removeProductFromCart(RemoveProductCartParams product);

  Future<Either<Failure, List<ProductCartModel>>> getCartProducts(GetCartParams params);
}
