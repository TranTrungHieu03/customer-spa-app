import 'package:spa_mobile/features/product/data/datasources/cart_remote_data_src.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/repository/cart_repository.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource cartDataSource;

  CartRepositoryImpl({required this.cartDataSource});

  @override
  Future<int> addProductToCart(AddProductCartParams product) async {
   return await cartDataSource.addProductToCart(product);
  }

  @override
  Future<void> removeProductFromCart(ProductModel product) async {
    await cartDataSource.removeProductFromCart(product);
  }

  @override
  Future<List<ProductModel>> getCartProducts() async {
    return await cartDataSource.getCartProducts();
  }

  @override
  Future<void> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }
}