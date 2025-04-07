part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final CreateOrderParams params;

  CreateOrderEvent(this.params);
}

class GetOrderEvent extends OrderEvent {
  final GetOrderProductDetailParams params;

  GetOrderEvent(this.params);
}
