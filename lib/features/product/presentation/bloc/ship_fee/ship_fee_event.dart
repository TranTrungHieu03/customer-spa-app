part of 'ship_fee_bloc.dart';

@immutable
sealed class ShipFeeEvent {}

class GetShipFeeEvent extends ShipFeeEvent {
  final GetFeeShippingParams params;

  GetShipFeeEvent(this.params);
}

class GetLeadTimeEvent extends ShipFeeEvent {
  final GetLeadTimeParams params;

  GetLeadTimeEvent(this.params);
}

class GetAvailableServiceEvent extends ShipFeeEvent {
  final GetAvailableServiceParams params;

  GetAvailableServiceEvent(this.params);
}
