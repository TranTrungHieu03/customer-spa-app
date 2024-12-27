part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final ProductModel product;

  ProductLoaded(
    this.product,
  );
}

final class ProductFailure extends ProductState {
  final String message;

  ProductFailure(this.message);
}
