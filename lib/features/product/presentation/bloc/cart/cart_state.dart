part of 'cart_bloc.dart';

@immutable
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<ProductCartModel> products;

  const CartLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

final class CartError extends CartState {
  final String message;

  CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CartSuccess extends CartState {
  final String message;

  CartSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
