import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/add_product_cart.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_cart.dart';
import 'package:spa_mobile/features/product/domain/usecases/remove_product_cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddProductCart _addProductCart;
  final GetCart _getProductCart;
  final RemoveProductCart _removeProductCart;

  CartBloc({required AddProductCart addProductCart, required GetCart getProductCart, required RemoveProductCart removeProductCart})
      : _addProductCart = addProductCart,
        _getProductCart = getProductCart,
        _removeProductCart = removeProductCart,
        super(CartInitial()) {
    on<GetCartProductsEvent>(_onGetCart);
    on<AddProductToCartEvent>(_onAddProduct);
    on<RemoveProductFromCartEvent>(_onRemoveProduct);
  }

  Future<void> _onGetCart(
    GetCartProductsEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await _getProductCart.call(NoParams());
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (products) => emit(CartLoaded(products: products)),
    );
  }

  Future<void> _onAddProduct(
    AddProductToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await _addProductCart
        .call(AddProductCartParams(productId: event.params.productId, quantity: event.params.quantity, operation: event.params.operation));
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (message) => emit(CartSuccess(message: message)),
    );
  }

  Future<void> _onRemoveProduct(
    RemoveProductFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await _removeProductCart(event.id);
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (message) => emit(CartSuccess(message: message)),
    );
  }
}
