part of 'list_service_bloc.dart';

@immutable
sealed class ListServiceEvent {}

class GetListServicesEvent extends ListServiceEvent {
  final int page;
  final int branchId;
  final int pageSize;

  GetListServicesEvent(this.page, this.branchId, this.pageSize);
}

class GetListServicesForSelectionEvent extends ListServiceEvent {
  final int page;
  final int branchId;

  final int pageSize;

  GetListServicesForSelectionEvent(this.page, this.branchId, this.pageSize);
}

class GetListServiceChangeBranchEvent extends ListServiceEvent {
  final int branchId;

  GetListServiceChangeBranchEvent(this.branchId);
}

class SelectCategoryEvent extends ListServiceEvent {
  final int categoryId;

  SelectCategoryEvent(this.categoryId);
}

class RefreshListServiceEvent extends ListServiceEvent {}
