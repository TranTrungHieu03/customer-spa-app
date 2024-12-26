part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

class GetServiceDetailEvent extends ServiceEvent {
  final int id;

  GetServiceDetailEvent(this.id);
}
