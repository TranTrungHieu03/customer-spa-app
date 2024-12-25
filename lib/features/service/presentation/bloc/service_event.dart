part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

class GetListServicesEvent extends ServiceEvent {
  final int page;

  GetListServicesEvent(this.page);
}

class GetServiceDetailEvent extends ServiceEvent {
  final String id;

  GetServiceDetailEvent(this.id);
}
