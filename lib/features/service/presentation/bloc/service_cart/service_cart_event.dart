part of 'service_cart_bloc.dart';

@immutable
sealed class ServiceCartEvent {}

class LoadServices extends ServiceCartEvent {}

class AddService extends ServiceCartEvent {
  final ServiceModel service;

  AddService(this.service);
}

class RemoveService extends ServiceCartEvent {
  final int serviceId;

  RemoveService(this.serviceId);
}

class ToggleCartVisibility extends ServiceCartEvent {}
