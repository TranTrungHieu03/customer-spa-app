part of 'list_appointment_bloc.dart';

@immutable
sealed class ListAppointmentState {
  const ListAppointmentState();
}

final class ListAppointmentInitial extends ListAppointmentState {}

final class ListAppointmentLoaded extends ListAppointmentState {
  final List<OrderAppointmentModel> pending;
  final List<OrderAppointmentModel> completed;
  final List<OrderAppointmentModel> cancelled;
  final List<OrderAppointmentModel> arrived;
  final bool isLoadingMorePending;
  final bool isLoadingMoreCompleted;
  final bool isLoadingMoreCancelled;
  final bool isLoadingMoreArrived;
  final PaginationModel paginationPending;
  final PaginationModel paginationCompleted;
  final PaginationModel paginationCancelled;
  final PaginationModel paginationArrived;

  const ListAppointmentLoaded({
    required this.pending,
    required this.completed,
    required this.arrived,
    required this.isLoadingMorePending,
    required this.isLoadingMoreCompleted,
    required this.paginationPending,
    required this.paginationArrived,
    required this.paginationCompleted,
    required this.cancelled,
    required this.isLoadingMoreCancelled,
    required this.isLoadingMoreArrived,
    required this.paginationCancelled,
  });

  ListAppointmentLoaded copyWith({
    List<OrderAppointmentModel>? pending,
    List<OrderAppointmentModel>? completed,
    List<OrderAppointmentModel>? cancelled,
    List<OrderAppointmentModel>? arrived,
    bool? isLoadingMorePending,
    bool? isLoadingMoreCompleted,
    bool? isLoadingMoreCancelled,
    bool? isLoadingMoreArrived,
    PaginationModel? paginationPending,
    PaginationModel? paginationCompleted,
    PaginationModel? paginationCancelled,
    PaginationModel? paginationArrived,
  }) {
    return ListAppointmentLoaded(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
      arrived: arrived ?? this.arrived,
      isLoadingMorePending: isLoadingMorePending ?? this.isLoadingMorePending,
      isLoadingMoreCompleted: isLoadingMoreCompleted ?? this.isLoadingMoreCompleted,
      isLoadingMoreCancelled: isLoadingMoreCancelled ?? this.isLoadingMoreCancelled,
      isLoadingMoreArrived: isLoadingMoreArrived ?? this.isLoadingMoreArrived,
      paginationPending: paginationPending ?? this.paginationPending,
      paginationCompleted: paginationCompleted ?? this.paginationCompleted,
      paginationCancelled: paginationCancelled ?? this.paginationCancelled,
      paginationArrived: paginationArrived ?? this.paginationArrived,
    );
  }
}

final class ListAppointmentLoading extends ListAppointmentState {
  final List<AppointmentModel> pending;
  final List<AppointmentModel> completed;
  final List<AppointmentModel> cancelled;
  final List<AppointmentModel> arrived;

  final bool isLoadingMorePending;
  final bool isLoadingMoreCompleted;
  final bool isLoadingMoreCancelled;
  final bool isLoadingMoreArrived;

  final PaginationModel paginationPending;
  final PaginationModel paginationCompleted;
  final PaginationModel paginationCancelled;
  final PaginationModel paginationArrived;

  const ListAppointmentLoading({
    required this.pending,
    required this.completed,
    required this.cancelled,
    required this.isLoadingMorePending,
    required this.isLoadingMoreCompleted,
    required this.isLoadingMoreArrived,
    required this.paginationPending,
    required this.paginationCompleted,
    required this.paginationArrived,
    required this.arrived,
    required this.isLoadingMoreCancelled,
    required this.paginationCancelled,
  });

  ListAppointmentLoading copyWith({
    List<AppointmentModel>? pending,
    List<AppointmentModel>? completed,
    List<AppointmentModel>? cancelled,
    List<AppointmentModel>? arrived,
    bool? isLoadingMorePending,
    bool? isLoadingMoreCompleted,
    bool? isLoadingMoreCancelled,
    bool? isLoadingMoreArrived,
    PaginationModel? paginationPending,
    PaginationModel? paginationCompleted,
    PaginationModel? paginationCancelled,
    PaginationModel? paginationArrived,
  }) {
    return ListAppointmentLoading(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
      arrived: arrived ?? this.arrived,
      isLoadingMorePending: isLoadingMorePending ?? this.isLoadingMorePending,
      isLoadingMoreCompleted: isLoadingMoreCompleted ?? this.isLoadingMoreCompleted,
      isLoadingMoreCancelled: isLoadingMoreCancelled ?? this.isLoadingMoreCancelled,
      isLoadingMoreArrived: isLoadingMoreArrived ?? this.isLoadingMoreArrived,
      paginationPending: paginationPending ?? this.paginationPending,
      paginationCompleted: paginationCompleted ?? this.paginationCompleted,
      paginationCancelled: paginationCancelled ?? this.paginationCancelled,
      paginationArrived: paginationArrived ?? this.paginationArrived,
    );
  }
}

final class ListAppointmentError extends ListAppointmentState {
  final String message;

  const ListAppointmentError(this.message);
}
