part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderLoaded extends OrderState {
  final OrderProductModel order;

  OrderLoaded(this.order);
}

final class OrderSuccess extends OrderState {
  final int orderId;

  OrderSuccess(this.orderId);
}

final class OrderCancelSuccess extends OrderState {
  final String message;
  final int orderId;

  OrderCancelSuccess({required this.orderId, required this.message});
}

final class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}
