part of 'service_bloc.dart';

@immutable
sealed class ServiceState {
  const ServiceState();
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ListServiceLoaded extends ServiceState {
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

class ServiceDetailSuccess extends ServiceState {
  final ServiceModel service;

  const ServiceDetailSuccess(this.service);
}

class ServiceFailure extends ServiceState {
  final String message;

  const ServiceFailure(this.message);
}
