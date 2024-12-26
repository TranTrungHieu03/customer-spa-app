part of 'service_bloc.dart';

@immutable
sealed class ServiceState {
  const ServiceState();
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceDetailSuccess extends ServiceState {
  final ServiceModel service;

  const ServiceDetailSuccess(this.service);
}

class ServiceDetailFailure extends ServiceState {
  final String message;

  const ServiceDetailFailure(this.message);
}
