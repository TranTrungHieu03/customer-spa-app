part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {
  const ProductEvent();
}

class GetProductDetailEvent extends ProductEvent {
  final int productId;

  const GetProductDetailEvent(this.productId);
}

class GetProductDetailByProductIdEvent extends ProductEvent {
  final int productId;

  const GetProductDetailByProductIdEvent(this.productId);
}
