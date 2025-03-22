import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';

abstract class CartRemoteDataSource {
  Future<int> addProductToCart(AddProductCartParams product);

  Future<void> removeProductFromCart(ProductModel product);

  Future<void> clearCart();

  Future<List<ProductModel>> getCartProducts();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  @override
  Future<int> addProductToCart(product) async {
    // TODO: implement addProductToCart
    throw UnimplementedError();
  }

  @override
  Future<void> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> getCartProducts() {
    // TODO: implement getCartProducts
    throw UnimplementedError();
  }

  @override
  Future<void> removeProductFromCart(product) {
    // TODO: implement removeProductFromCart
    throw UnimplementedError();
  }
}
