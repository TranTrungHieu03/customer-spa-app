part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class AddProductToCartEvent extends CartEvent {
  final AddProductCartParams params;

  AddProductToCartEvent({required this.params});
}

class UpdateProductToCartEvent extends CartEvent {
  final AddProductCartParams params;

  UpdateProductToCartEvent({required this.params});
}

class RemoveProductFromCartEvent extends CartEvent {
  final String id;

  RemoveProductFromCartEvent({required this.id});
}

class GetCartProductsEvent extends CartEvent {}
