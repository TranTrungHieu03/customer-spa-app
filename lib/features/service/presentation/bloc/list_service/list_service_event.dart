part of 'list_service_bloc.dart';

@immutable
sealed class ListServiceEvent {}

class GetListServicesEvent extends ListServiceEvent {
  final int page;
  final int branchId;

  GetListServicesEvent(this.page, this.branchId);
}

class GetListServiceChangeBranchEvent extends ListServiceEvent {
  final int branchId;

  GetListServiceChangeBranchEvent(this.branchId);
}
