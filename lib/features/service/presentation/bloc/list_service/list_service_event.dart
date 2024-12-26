part of 'list_service_bloc.dart';

@immutable
sealed class ListServiceEvent {}

class GetListServicesEvent extends ListServiceEvent {
  final int page;

  GetListServicesEvent(this.page);
}
