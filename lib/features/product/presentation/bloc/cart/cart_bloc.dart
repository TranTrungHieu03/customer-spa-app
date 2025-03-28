import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
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
    on<UpdateProductToCartEvent>(_onUpdateProduct);
    on<RemoveProductFromCartEvent>(_onRemoveProduct);
  }

  Future<void> _onGetCart(
    GetCartProductsEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    int userId;
    if (jsonDecode(userJson) != null) {
      userId = UserModel.fromJson(jsonDecode(userJson)).userId;
      final result = await _getProductCart.call(GetCartParams(userId));
      result.fold(
        (failure) => emit(CartError(message: failure.message)),
        (products) => emit(CartLoaded(products: products)),
      );
    } else {
      goLoginNotBack();
    }
  }

  Future<void> _onAddProduct(
    AddProductToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    int userId;
    if (jsonDecode(userJson) != null) {
      userId = UserModel.fromJson(jsonDecode(userJson)).userId;
      final result = await _addProductCart.call(AddProductCartParams(
          userId: userId, productId: event.params.productId, quantity: event.params.quantity, operation: event.params.operation));
      result.fold(
        (failure) => emit(CartError(message: failure.message)),
        (product) {
          emit(CartSuccess(message: "Thêm vào giỏ hàng thành công"));
          emit(CartLoaded(products: product));
        },
      );
    } else {
      goLoginNotBack();
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    // emit(CartUpdateLoading());
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    int userId;
    if (jsonDecode(userJson) != null) {
      userId = UserModel.fromJson(jsonDecode(userJson)).userId;
      final result = await _addProductCart.call(AddProductCartParams(
          userId: userId, productId: event.params.productId, quantity: event.params.quantity, operation: event.params.operation));
      result.fold(
        (failure) => emit(CartError(message: failure.message)),
        (product) {
          // emit(CartSuccess(message: "Thêm vào giỏ hàng thành công"));
          // emit(CartLoaded(products: product));
        },
      );
    } else {
      goLoginNotBack();
    }
  }

  Future<void> _onRemoveProduct(
    RemoveProductFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    int userId;
    if (jsonDecode(userJson) != null) {
      userId = UserModel.fromJson(jsonDecode(userJson)).userId;
      final result = await _removeProductCart(RemoveProductCartParams(userId: userId, productId: event.id));
      result.fold(
        (failure) => emit(CartError(message: failure.message)),
        (message) => emit(CartSuccess(message: message)),
      );
    } else {
      goLoginNotBack();
    }
  }
}
