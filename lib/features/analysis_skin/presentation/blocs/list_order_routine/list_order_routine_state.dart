part of 'list_order_routine_bloc.dart';

@immutable
sealed class ListOrderRoutineState {}

final class ListOrderRoutineInitial extends ListOrderRoutineState {}

final class ListOrderRoutineLoaded extends ListOrderRoutineState {
  final List<OrderRoutineModel> pending;
  final List<OrderRoutineModel> completed;
  final List<OrderRoutineModel> cancelled;

  // // final List<OrderRoutineModel> arrived;
  final bool isLoadingMorePending;
  final bool isLoadingMoreCompleted;
  final bool isLoadingMoreCancelled;

  // final bool isLoadingMoreArrived;
  final PaginationModel paginationPending;
  final PaginationModel paginationCompleted;
  final PaginationModel paginationCancelled;

  // final PaginationModel paginationArrived;

  ListOrderRoutineLoaded({
    required this.pending,
    required this.completed,
    // // required this.arrived,
    required this.isLoadingMorePending,
    required this.isLoadingMoreCompleted,
    required this.paginationPending,
    // required this.paginationArrived,
    required this.paginationCompleted,
    required this.cancelled,
    required this.isLoadingMoreCancelled,
    // required this.isLoadingMoreArrived,
    required this.paginationCancelled,
  });

  ListOrderRoutineLoaded copyWith({
    List<OrderRoutineModel>? pending,
    List<OrderRoutineModel>? completed,
    List<OrderRoutineModel>? cancelled,
    // // List<OrderRoutineModel>? arrived,
    bool? isLoadingMorePending,
    bool? isLoadingMoreCompleted,
    bool? isLoadingMoreCancelled,
    // bool? isLoadingMoreArrived,
    PaginationModel? paginationPending,
    PaginationModel? paginationCompleted,
    PaginationModel? paginationCancelled,
    // PaginationModel? paginationArrived,
  }) {
    return ListOrderRoutineLoaded(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
      // // arrived: arrived ?? this.arrived,
      isLoadingMorePending: isLoadingMorePending ?? this.isLoadingMorePending,
      isLoadingMoreCompleted: isLoadingMoreCompleted ?? this.isLoadingMoreCompleted,
      isLoadingMoreCancelled: isLoadingMoreCancelled ?? this.isLoadingMoreCancelled,
      // isLoadingMoreArrived: isLoadingMoreArrived ?? this.isLoadingMoreArrived,
      paginationPending: paginationPending ?? this.paginationPending,
      paginationCompleted: paginationCompleted ?? this.paginationCompleted,
      paginationCancelled: paginationCancelled ?? this.paginationCancelled,
      // paginationArrived: paginationArrived ?? this.paginationArrived,
    );
  }
}

final class ListOrderRoutineLoading extends ListOrderRoutineState {
  final List<OrderRoutineModel> pending;
  final List<OrderRoutineModel> completed;
  final List<OrderRoutineModel> cancelled;

  // final List<OrderRoutineModel> arrived;

  final bool isLoadingMorePending;
  final bool isLoadingMoreCompleted;
  final bool isLoadingMoreCancelled;

  // final bool isLoadingMoreArrived;

  final PaginationModel paginationPending;
  final PaginationModel paginationCompleted;
  final PaginationModel paginationCancelled;

  // final PaginationModel paginationArrived;

  ListOrderRoutineLoading({
    required this.pending,
    required this.completed,
    required this.cancelled,
    required this.isLoadingMorePending,
    required this.isLoadingMoreCompleted,
    // required this.isLoadingMoreArrived,
    required this.paginationPending,
    required this.paginationCompleted,
    // required this.paginationArrived,
    // required this.arrived,
    required this.isLoadingMoreCancelled,
    required this.paginationCancelled,
  });

  ListOrderRoutineLoading copyWith({
    List<OrderRoutineModel>? pending,
    List<OrderRoutineModel>? completed,
    List<OrderRoutineModel>? cancelled,
    // List<OrderRoutineModel>? arrived,
    bool? isLoadingMorePending,
    bool? isLoadingMoreCompleted,
    bool? isLoadingMoreCancelled,
    // bool? isLoadingMoreArrived,
    PaginationModel? paginationPending,
    PaginationModel? paginationCompleted,
    PaginationModel? paginationCancelled,
    // PaginationModel? paginationArrived,
  }) {
    return ListOrderRoutineLoading(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
      // arrived: arrived ?? this.arrived,
      isLoadingMorePending: isLoadingMorePending ?? this.isLoadingMorePending,
      isLoadingMoreCompleted: isLoadingMoreCompleted ?? this.isLoadingMoreCompleted,
      isLoadingMoreCancelled: isLoadingMoreCancelled ?? this.isLoadingMoreCancelled,
      // isLoadingMoreArrived: isLoadingMoreArrived ?? this.isLoadingMoreArrived,
      paginationPending: paginationPending ?? this.paginationPending,
      paginationCompleted: paginationCompleted ?? this.paginationCompleted,
      paginationCancelled: paginationCancelled ?? this.paginationCancelled,
      // paginationArrived: paginationArrived ?? this.paginationArrived,
    );
  }
}

final class ListOrderRoutineError extends ListOrderRoutineState {
  final String message;

  ListOrderRoutineError(this.message);
}
