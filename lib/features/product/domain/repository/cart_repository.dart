import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';

abstract class CartRepository {
  Future<int> addProductToCart(AddProductCartParams product);

  Future<void> removeProductFromCart(ProductModel product);

  Future<void> clearCart();

  Future<List<ProductModel>> getCartProducts();
}
