part of 'ship_fee_bloc.dart';

@immutable
sealed class ShipFeeState {}

final class ShipFeeInitial extends ShipFeeState {}

final class ShipFeeLoading extends ShipFeeState {}

final class ShipFeeLoaded extends ShipFeeState {
  final int fee;
  final String leadTime;

  ShipFeeLoaded({required this.fee, required this.leadTime});
}

final class ShipFeeLoadedServiceId extends ShipFeeState {
  final int serviceId;

  ShipFeeLoadedServiceId(this.serviceId);
}

final class ShipFeeError extends ShipFeeState {
  final String message;

  ShipFeeError(this.message);
}
