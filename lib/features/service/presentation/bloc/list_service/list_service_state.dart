part of 'list_service_bloc.dart';

@immutable
sealed class ListServiceState {
  const ListServiceState();
}

final class ListServiceInitial extends ListServiceState {}

class ListServiceEmpty extends ListServiceState {}

class ListServiceChangeBranch extends ListServiceState {}

class ListServiceLoading extends ListServiceState {
  final bool isLoadingMore;
  final List<ServiceModel> services;
  final PaginationModel pagination;

  const ListServiceLoading({required this.services, required this.pagination, this.isLoadingMore = false});
}

class ListServiceLoaded extends ListServiceState {
  final List<ServiceModel> services;
  final PaginationModel pagination;
  final bool isLoadingMore;

  const ListServiceLoaded({
    required this.services,
    required this.pagination,
    this.isLoadingMore = false,
  });

  ListServiceLoaded copyWith({
    List<ServiceModel>? services,
    PaginationModel? pagination,
    bool? isLoadingMore,
  }) {
    return ListServiceLoaded(
      services: services ?? this.services,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ListServiceFailure extends ListServiceState {
  final String message;

  const ListServiceFailure(this.message);
}
