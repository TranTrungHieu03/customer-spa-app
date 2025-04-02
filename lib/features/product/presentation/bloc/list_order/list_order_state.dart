part of 'list_order_bloc.dart';

@immutable
sealed class ListOrderState {}

final class ListOrderInitial extends ListOrderState {}

final class ListOrderLoaded extends ListOrderState {
  final List<OrderProductModel> pending;
  final List<OrderProductModel> completed;
  final List<OrderProductModel> shipping;
  final List<OrderProductModel> cancelled;

  final bool isLoadingMorePending;
  final bool isLoadingMoreCompleted;
  final bool isLoadingMoreCancelled;
  final bool isLoadingMoreShipping;

  final PaginationModel paginationPending;
  final PaginationModel paginationCompleted;
  final PaginationModel paginationCancelled;
  final PaginationModel paginationShipping;

  ListOrderLoaded({
    required this.pending,
    required this.completed,
    required this.shipping,
    required this.cancelled,
    required this.isLoadingMorePending,
    required this.isLoadingMoreCompleted,
    required this.isLoadingMoreCancelled,
    required this.isLoadingMoreShipping,
    required this.paginationPending,
    required this.paginationCompleted,
    required this.paginationCancelled,
    required this.paginationShipping,
  });

  ListOrderLoaded copyWith({
    List<OrderProductModel>? pending,
    List<OrderProductModel>? completed,
    List<OrderProductModel>? shipping,
    List<OrderProductModel>? cancelled,
    bool? isLoadingMorePending,
    bool? isLoadingMoreCompleted,
    bool? isLoadingMoreCancelled,
    bool? isLoadingMoreShipping,
    PaginationModel? paginationPending,
    PaginationModel? paginationCompleted,
    PaginationModel? paginationCancelled,
    PaginationModel? paginationShipping,
  }) {
    return ListOrderLoaded(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      shipping: shipping ?? this.shipping,
      cancelled: cancelled ?? this.cancelled,
      isLoadingMorePending: isLoadingMorePending ?? this.isLoadingMorePending,
      isLoadingMoreCompleted: isLoadingMoreCompleted ?? this.isLoadingMoreCompleted,
      isLoadingMoreCancelled: isLoadingMoreCancelled ?? this.isLoadingMoreCancelled,
      isLoadingMoreShipping: isLoadingMoreShipping ?? this.isLoadingMoreShipping,
      paginationPending: paginationPending ?? this.paginationPending,
      paginationCompleted: paginationCompleted ?? this.paginationCompleted,
      paginationCancelled: paginationCancelled ?? this.paginationCancelled,
      paginationShipping: paginationShipping ?? this.paginationShipping,
    );
  }
}

final class ListOrderLoading extends ListOrderState {
  final List<OrderProductModel> pending;
  final List<OrderProductModel> completed;
  final List<OrderProductModel> shipping;
  final List<OrderProductModel> cancelled;

  final bool isLoadingMorePending;
  final bool isLoadingMoreCompleted;
  final bool isLoadingMoreCancelled;
  final bool isLoadingMoreShipping;

  final PaginationModel paginationPending;
  final PaginationModel paginationCompleted;
  final PaginationModel paginationCancelled;
  final PaginationModel paginationShipping;

  ListOrderLoading({
    required this.pending,
    required this.completed,
    required this.shipping,
    required this.cancelled,
    required this.isLoadingMorePending,
    required this.isLoadingMoreCompleted,
    required this.isLoadingMoreCancelled,
    required this.isLoadingMoreShipping,
    required this.paginationPending,
    required this.paginationCompleted,
    required this.paginationCancelled,
    required this.paginationShipping,
  });

  ListOrderLoading copyWith({
    List<OrderProductModel>? pending,
    List<OrderProductModel>? completed,
    List<OrderProductModel>? shipping,
    List<OrderProductModel>? cancelled,
    bool? isLoadingMorePending,
    bool? isLoadingMoreCompleted,
    bool? isLoadingMoreCancelled,
    bool? isLoadingMoreShipping,
    PaginationModel? paginationPending,
    PaginationModel? paginationCompleted,
    PaginationModel? paginationCancelled,
    PaginationModel? paginationShipping,
  }) {
    return ListOrderLoading(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      shipping: shipping ?? this.shipping,
      cancelled: cancelled ?? this.cancelled,
      isLoadingMorePending: isLoadingMorePending ?? this.isLoadingMorePending,
      isLoadingMoreCompleted: isLoadingMoreCompleted ?? this.isLoadingMoreCompleted,
      isLoadingMoreCancelled: isLoadingMoreCancelled ?? this.isLoadingMoreCancelled,
      isLoadingMoreShipping: isLoadingMoreShipping ?? this.isLoadingMoreShipping,
      paginationPending: paginationPending ?? this.paginationPending,
      paginationCompleted: paginationCompleted ?? this.paginationCompleted,
      paginationCancelled: paginationCancelled ?? this.paginationCancelled,
      paginationShipping: paginationShipping ?? this.paginationShipping,
    );
  }
}

final class ListOrderError extends ListOrderState {
  final String message;

  ListOrderError(this.message);
}
